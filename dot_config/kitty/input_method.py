"""Use Chinese in Codex and English in shell tools; let Neovim manage itself."""

import os
import shlex
import shutil
import sys
import tempfile

from kitty.fast_data_types import add_timer, current_focused_os_window_id
from kitty.utils import log_error

_busctl = shutil.which("busctl") if sys.platform.startswith("linux") else None
_revision = 0
_busy = False
_pending = False
_scheduled = False
_warned = False
_awaiting_prompt = set()
_english_commands = {"lazygit", "lazydocker", "yazi", "fm", "btop", "htop", "fzf", "less", "man", "bat"}


def _command_name(command):
    try:
        words = shlex.split(command)
    except ValueError:
        return ""
    while words and (words[0] in ("command", "exec", "env") or "=" in words[0]):
        words.pop(0)
    return os.path.basename(words[0]) if words else ""


def _target(boss):
    window = boss.active_window
    if window is None or window.destroyed or window.os_window_id != current_focused_os_window_id():
        return None
    if "IS_NVIM" in window.user_vars:
        return None
    if window.last_cmd_output_start_time:
        command = _command_name(window.last_cmd_cmdline)
    else:
        # Also handle programs launched directly as `kitty lazygit`, without a shell.
        command = os.path.basename(window.child.argv[0]).lstrip("-") if window.child.argv else ""
        # Command-end arrives before Fish finishes drawing its next prompt.
        if window.at_prompt or command in ("fish", "bash", "zsh", "sh"):
            return True
    if command == "codex":
        return False
    if command in _english_commands:
        return True
    return None


def _call(boss, method, args, callback):
    output = tempfile.TemporaryFile()
    errors = tempfile.TemporaryFile()

    def completed(status, error):
        global _warned
        output.seek(0)
        result = output.read().decode(errors="replace").strip()
        errors.seek(0)
        message = errors.read().decode(errors="replace").strip()
        output.close()
        errors.close()
        ok = status == 0 and error is None
        if not ok and not _warned:
            _warned = True
            log_error(f"Rime input method: {error or message or 'D-Bus request failed'}")
        callback(ok, result)

    boss.run_background_process(
        [_busctl, "--user", "--timeout=1", "call", "org.fcitx.Fcitx5", "/rime",
         "org.fcitx.Fcitx.Rime1", method, *args],
        stdout=output.fileno(), stderr=errors.fileno(), notify_on_death=completed,
    )


def _apply(boss):
    global _busy, _pending
    if _busy or not _pending:
        return
    _pending = False
    window = boss.active_window
    if window is not None and window.at_prompt:
        _awaiting_prompt.discard(window.id)
    target = _target(boss)
    if target is None:
        return
    _busy = True
    revision = _revision

    def finish(*_):
        global _busy
        _busy = False
        if _pending:
            _apply(boss)

    def queried(ok, result):
        # A newer command or focus event supersedes this query.
        if not ok or revision != _revision or _target(boss) != target:
            finish()
        elif result not in ("b true", "b false") or (result == "b true") == target:
            finish()
        else:
            _call(boss, "SetAsciiMode", ["b", str(target).lower()], finish)

    # Query first: setting an unchanged value would flash Fcitx's mode popup.
    _call(boss, "IsAsciiMode", [], queried)


def _refresh(boss):
    global _revision, _pending, _scheduled
    if not _busctl:
        return
    _revision += 1
    _pending = True
    if _scheduled:
        return
    _scheduled = True

    def settled(timer_id):
        global _scheduled
        _scheduled = False
        _apply(boss)

    # Let Kitty finish updating the active tab, prompt, and Neovim marker.
    add_timer(settled, 0.02, False)


def on_load(boss, data):
    _refresh(boss)


def on_focus_change(boss, window, data):
    _refresh(boss)


def on_resize(boss, window, data):
    old = data["old_geometry"]
    if old.xnum == 0 and old.ynum == 0:
        _awaiting_prompt.add(window.id)
        _refresh(boss)


def on_title_change(boss, window, data):
    # Shells report their prompt title after startup. Only use this event until
    # the first prompt is ready, so later title changes do not override typing.
    if window.id in _awaiting_prompt and data["from_child"] and window is boss.active_window:
        _refresh(boss)


def on_close(boss, window, data):
    _awaiting_prompt.discard(window.id)


def on_cmd_startstop(boss, window, data):
    if window is boss.active_window:
        _refresh(boss)


def on_set_user_var(boss, window, data):
    if data["key"] == "IS_NVIM" and window is boss.active_window:
        _refresh(boss)
