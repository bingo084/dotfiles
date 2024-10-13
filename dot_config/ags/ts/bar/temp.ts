const cpuTemp = Variable("", {
  poll: [
    2000,
    ["bash", "-c", "sensors -A | grep 'Package id' | awk '{print $4}'"],
  ],
});

export default Widget.Box({
  children: [
    Widget.Label({
      label: cpuTemp.bind(),
    }),
  ],
});
