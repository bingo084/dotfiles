import { disk } from "variables";

export default Widget.Box({
  spacing: 8,
  children: [
    Widget.Icon("drive-harddisk-symbolic"),
    Widget.Label({
      label: disk.bind().as(({ use }) => {
        return use || "";
      }),
    }),
  ],
});
