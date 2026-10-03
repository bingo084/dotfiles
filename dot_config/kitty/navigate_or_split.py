from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    tab = window.tabref()
    if tab is None:
        return

    direction = args[1]
    if direction not in ("left", "right", "top", "bottom"):
        return

    # Stack is a temporary view of the splits; restore it before navigating.
    if tab.current_layout.name == "stack":
        tab.goto_layout("splits")

    if tab.neighboring_group_id(direction) is not None:
        tab.neighboring_window(direction)
        return

    location = "hsplit" if direction in ("top", "bottom") else "vsplit"
    boss.launch("--cwd=current", f"--location={location}")
    if direction in ("left", "top"):
        tab.move_window(direction)
