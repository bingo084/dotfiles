const updates = Variable("", {
  poll: [
    60 * 1000,
    [
      "bash",
      "-c",
      "echo $(($(checkupdates 2>/dev/null | wc -l) + $(paru -Qua 2>/dev/null | wc -l)))",
    ],
  ],
});

export default Widget.Box({
  spacing: 8,
  children: [
    Widget.Icon({
      icon: "emblem-synchronizing-symbolic",
    }),
    Widget.Label({
      label: updates.bind(),
    }),
  ],
});
