const bluetooth = await Service.import("bluetooth");
const deviceMap = {
  "input-keyboard": "",
  "input-mouse": "  ",
  "audio-headset": " ",
};
const icons = ["", "", "", "", ""];
const icon = (v: number, icons: string[]) =>
  icons[Math.round((v / 100) * (icons.length - 1))];

export default Widget.EventBox({
  onPrimaryClickRelease: () => (bluetooth.enabled = !bluetooth.enabled),
  onMiddleClickRelease: () => Utils.subprocess("blueman-manager"),
  child: Widget.Icon().hook(bluetooth, (self) => {
    self.tooltip_text = bluetooth.connected_devices
      .map(
        ({ icon_name, name, battery_percentage }) =>
          `${deviceMap[icon_name] || " "} ${name}  ${icon(battery_percentage, icons)} ${battery_percentage}%`,
      )
      .join("\n");
    self.icon = `bluetooth-${bluetooth.enabled ? "active" : "disabled"}-symbolic`;
  }),
});
