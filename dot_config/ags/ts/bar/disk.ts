const diskUsage = Variable(
  {},
  {
    listen: [App.configDir + "/scripts/disk.sh 2", (out) => JSON.parse(out)],
  },
);

export default Widget.Box({
  spacing: 8,
  children: [
    Widget.Icon({ icon: "drive-harddisk-symbolic" }),
    Widget.Label({
      label: diskUsage.bind().as(({ use }) => {
        return use || "";
      }),
    }),
  ],
});
