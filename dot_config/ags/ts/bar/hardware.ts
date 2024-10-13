const divide = ([total, free]: any) => free / total;

const cpu = Variable(0, {
  poll: [
    2000,
    "top -b -n 1",
    (out) =>
      divide([
        100,
        out
          .split("\n")
          .find((line) => line.includes("Cpu(s)"))
          ?.split(/\s+/)[1]
          ?.replace(",", "."),
      ]),
  ],
});

const ram = Variable(0, {
  poll: [
    2000,
    "free",
    (out) =>
      divide(
        out
          .split("\n")
          .find((line) => line.includes("Mem:"))
          ?.split(/\s+/)
          .splice(1, 2),
      ),
  ],
});
export default Widget.EventBox({
  onMiddleClickRelease: () => Utils.subprocess("missioncenter"),
  child: Widget.Box({
    className: "hardware",
    vertical: true,
    children: [
      Widget.Label({
        className: "cpu",
        label: cpu.bind().as((v) => `${(v * 100).toFixed(0).padStart(3)}%`),
      }),
      Widget.Label({
        className: "ram",
        label: ram.bind().as((v) => `${(v * 100).toFixed(0).padStart(3)}%`),
      }),
    ],
  }),
});
