export default Widget.Button({
  onClicked: () => Utils.subprocess("rofi -show"),
  child: Widget.Icon({
    icon: "system-search",
  }),
});
