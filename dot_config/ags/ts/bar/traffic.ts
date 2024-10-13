const speed = Variable(
  { rx_bps: 0, tx_bps: 0 },
  {
    listen: [App.configDir + "/scripts/traffic.sh 2", (out) => JSON.parse(out)],
  },
);

const format = (bps: number) => {
  const units = ["B", "KB", "MB", "GB", "TB"];
  let i = 0;
  while (bps >= 1000 && i < units.length - 1) {
    bps /= 1000;
    i++;
  }
  return {
    value: bps.toFixed(bps >= 100 ? 0 : bps >= 10 ? 1 : 2),
    unit: `${units[i]}/s`,
  };
};

const icon = (tx: number, rx: number) => {
  if (tx === 0 && rx === 0) return "network-idle-symbolic";
  if (tx === rx) return "network-transmit-receive-symbolic";
  return tx > rx ? "network-transmit-symbolic" : "network-receive-symbolic";
};

export default Widget.Box({
  className: "traffic",
  children: speed.bind().as(({ tx_bps, rx_bps }) => {
    const maxBps = Math.max(tx_bps, rx_bps);
    if (maxBps < 102400) {
      return [];
    }
    const { value, unit } = format(maxBps);
    return [
      Widget.Icon({
        className: "icon",
        icon: icon(tx_bps, rx_bps),
      }),
      Widget.Label({
        className: "trx",
        label: ` ${value}`,
      }),
      Widget.Label({
        className: "unit",
        label: ` ${unit}`,
      }),
    ];
  }),
});
