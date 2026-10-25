"""Toggle Codex over the current terminal and working directory."""

import os

from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None or (tab := window.tabref()) is None:
        return

    owner_id = window.user_vars.get("CODEX_SHELL")
    if owner_id is not None:
        owner = boss.window_id_map.get(int(owner_id))
        if owner is not None and owner.tabref() is tab:
            boss.set_active_window(owner)
        return

    cwd = window.cwd_of_child
    if not cwd:
        return
    cwd = os.path.realpath(cwd)
    for pane in tab.windows:
        if pane.user_vars.get("CODEX_SHELL") != str(window.id) or pane.user_vars.get("CODEX_CWD") != cwd:
            continue
        commands = (pane.child.cmdline, pane.child.foreground_cmdline)
        if not any(command and os.path.basename(command[0]) == "codex" for command in commands):
            continue
        boss.set_active_window(pane)
        return

    boss.launch(
        "--type=overlay",
        f"--next-to=id:{window.id}",
        f"--cwd={cwd}",
        f"--var=CODEX_SHELL={window.id}",
        f"--var=CODEX_CWD={cwd}",
        "codex",
        "resume",
        "--remote",
        "unix://",
        "--last",
        "--cd",
        cwd,
        "-c",
        "tui.fullscreen_transcript=true",
        "-c",
        'tui.notification_method="osc9"',
    )
