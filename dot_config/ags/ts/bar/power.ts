export default Widget.Button({
  onClicked: () => Utils.subprocess("wlogout"),
  child: Widget.Icon({
    icon: "system-shutdown",
  }),
});
