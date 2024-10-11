const Power = Widget.Button({
  onClicked: () => Utils.subprocess("wlogout"),
  child: Widget.Icon({
    icon: "system-shutdown",
  }),
});

const Search = Widget.Button({
  onClicked: () => Utils.subprocess("rofi -show"),
  child: Widget.Icon({
    icon: "system-search",
  }),
});

const systemtray = await Service.import("systemtray");

const hyprland = await Service.import("hyprland");

const dispatch = (
  /** @type string */ dispatcher,
  /** @type {string | number} */ ws,
) => hyprland.messageAsync(`dispatch ${dispatcher} ${ws}`);
const activeId = hyprland.active.workspace.bind("id");
const defaultIds = [1, 2, 3, 4, 5];

const Workspaces = Widget.EventBox({
  className: "workspaces",
  onScrollUp: () => dispatch("workspace", "-1"),
  onScrollDown: () => dispatch("workspace", "+1"),
  child: Widget.Box({
    children: hyprland.bind("workspaces").as((ws) =>
      [...new Set([...defaultIds, ...ws.map(({ id }) => id)])]
        .sort((a, b) => a - b)
        .map((id) =>
          Widget.Button({
            className: activeId.as((i) => (i === id ? "focused" : "")),
            onClicked: () => dispatch("workspace", id),
            child: Widget.Label(`${id}`),
          }),
        ),
    ),
  }),
});

const { query } = await Service.import("applications");
const activeClient = hyprland.active.client.bind("address");
const Clients = Widget.Box({
  className: "clients",
  children: hyprland.bind("clients").as((clients) =>
    clients
      .sort((c1, c2) =>
        c1.workspace.id - c2.workspace.id != 0
          ? c1.workspace.id - c2.workspace.id
          : c1.at[0] - c2.at[0] != 0
            ? c1.at[0] - c2.at[0]
            : c1.at[1] - c2.at[1],
      )
      .map(({ address, class: clazz, title }) =>
        Widget.Button({
          className: activeClient.as((a) => (a === address ? "focused" : "")),
          onClicked: () => dispatch("focuswindow", `address:${address}`),
          onMiddleClick: () => dispatch("closewindow", `address:${address}`),
          child: Widget.Icon(query(clazz)[0]?.icon_name || "image-missing"),
          tooltipText: title,
        }),
      ),
  ),
});

const ClientTitle = Widget.Label({
  className: "client-title",
  label: hyprland.active.client.bind("title"),
  visible: hyprland.active.client.bind("address").as((addr) => !!addr),
});

const speed = Variable(
  { rx_bps: 0, tx_bps: 0 },
  {
    listen: [App.configDir + "/scripts/traffic.sh 2", (out) => JSON.parse(out)],
  },
);

const formatBps = (/** @type {number} */ bps) => {
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

const trafficIcon = (/** @type {number} */ tx, /** @type {number} */ rx) => {
  if (tx === 0 && rx === 0) return "network-idle-symbolic";
  if (tx === rx) return "network-transmit-receive-symbolic";
  return tx > rx ? "network-transmit-symbolic" : "network-receive-symbolic";
};

const Traffic = Widget.Box({
  className: "traffic",
  children: speed.bind().as(({ tx_bps, rx_bps }) => {
    const maxBps = Math.max(tx_bps, rx_bps);
    if (maxBps < 102400) {
      return [];
    }
    const { value, unit } = formatBps(maxBps);
    return [
      Widget.Icon({
        className: "icon",
        icon: trafficIcon(tx_bps, rx_bps),
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

const Updates = Widget.Box({
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

const diskUsage = Variable(
  {},
  {
    listen: [App.configDir + "/scripts/disk.sh 2", (out) => JSON.parse(out)],
  },
);

const Disk = Widget.Box({
  spacing: 8,
  children: [
    Widget.Icon({ icon: "drive-harddisk-symbolic" }),
    Widget.Label({ label: diskUsage.bind().as(({ use }) => use) }),
  ],
});

const divide = ([total, free]) => free / total;

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
          .split(/\s+/)[1]
          .replace(",", "."),
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
          .split(/\s+/)
          .splice(1, 2),
      ),
  ],
});
const Hardware = Widget.EventBox({
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

const cpuTemp = Variable("", {
  poll: [
    2000,
    ["bash", "-c", "sensors -A | grep 'Package id' | awk '{print $4}'"],
  ],
});

const Temp = Widget.Box({
  children: [
    Widget.Label({
      label: cpuTemp.bind(),
    }),
  ],
});

const date = Variable("", {
  poll: [1000, "date '+%a, %b %d  %H:%M'"],
});

const Calendar = Widget.Window({
  name: "calendar",
  anchor: ["top", "right"],
  visible: false,
  keymode: "on-demand",
  child: Widget.Calendar({}),
  setup: (self) => {
    self.keybind("Escape", () => App.closeWindow("calendar"));
  },
});

const Clock = Widget.EventBox({
  onPrimaryClickRelease: () => App.toggleWindow("calendar"),
  child: Widget.Label({
    className: "clock",
    label: date.bind(),
  }),
});

const hypridle = Variable(Utils.exec("pidof hypridle"));

const Coffee = Widget.EventBox({
  className: "coffee",
  onPrimaryClick: () => {
    hypridle.value
      ? Utils.exec("killall hypridle")
      : Utils.subprocess("hypridle");
    hypridle.value = Utils.exec("pidof hypridle");
  },
  child: Widget.Icon({
    css: hypridle.bind().as((p) => (p ? " " : "color: red")),
    icon: "preferences-desktop-screensaver-symbolic",
  }),
});

const audio = await Service.import("audio");
const changeVolume = (/** @type {number} */ n) =>
  (audio.speaker.volume = Math.min(audio.speaker.volume + n / 100, 1));
const Volume = Widget.EventBox({
  className: "volume",
  onPrimaryClickRelease: () =>
    (audio.speaker.is_muted = !audio.speaker.is_muted),
  onMiddleClickRelease: () => Utils.subprocess("pavucontrol"),
  onScrollUp: () => changeVolume(1),
  onScrollDown: () => changeVolume(-1),
  child: Widget.Box({
    tooltipText: audio.speaker.bind("description").as((d) => `${d}`),
    children: [
      Widget.Icon().hook(audio.speaker, (self) => {
        const volume = audio.speaker.volume * 100;
        const icon = audio.speaker.is_muted
          ? "muted"
          : [
              [101, "overamplified"],
              [67, "high"],
              [34, "medium"],
              [1, "low"],
              [0, "muted"],
            ].find(([threshold]) => threshold <= volume)?.[1];
        self.icon = `audio-volume-${icon}-symbolic`;
      }),
      Widget.Label({
        label: audio.speaker
          .bind("volume")
          .as((volume) => ` ${Math.round(volume * 100)}%`),
      }),
    ],
  }),
});

import brightness from "./services/brightness.js";

const brightnessIcons = [
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
];
const icon = (/** @type {number} */ v, /** @type {string[]} */ icons) =>
  icons[Math.round((v / 100) * (icons.length - 1))];

const Brightness = Widget.EventBox({
  className: "brightness",
  onScrollUp: () => (brightness.screen_value += 0.01),
  onScrollDown: () => (brightness.screen_value -= 0.01),
  child: Widget.Label({
    label: brightness
      .bind("screen_value")
      .as((v) => `${icon(v * 100, brightnessIcons)}  ${Math.round(v * 100)}%`),
  }),
});

const battery = await Service.import("battery");
const Battery = Widget.Box({
  classNames: battery
    .bind("charging")
    .as((ch) => (ch ? ["battery", "charging"] : ["battery"])),
  visible: battery.bind("available"),
  tooltipText: battery
    .bind("time_remaining")
    .as(
      (s) =>
        `Time to ${battery.charging ? "full" : "empty"}: ${Math.floor(s / 3600)} h ${Math.floor((s % 3600) / 60)} m`,
    ),
  children: [
    Widget.Icon({ icon: battery.bind("icon_name") }),
    Widget.Label({
      label: battery.bind("percent").as((b) => " " + b + "%"),
    }),
  ],
});

const bluetooth = await Service.import("bluetooth");
const deviceMap = {
  "input-keyboard": "",
  "input-mouse": "  ",
  "audio-headset": " ",
};
const batteryIcons = ["", "", "", "", ""];
const Bluetooth = Widget.EventBox({
  onPrimaryClickRelease: () => (bluetooth.enabled = !bluetooth.enabled),
  onMiddleClickRelease: () => Utils.subprocess("blueman-manager"),
  child: Widget.Icon().hook(bluetooth, (self) => {
    self.tooltip_text = bluetooth.connected_devices
      .map(
        ({ icon_name, name, battery_percentage }) =>
          `${deviceMap[icon_name] || " "} ${name}  ${icon(battery_percentage, batteryIcons)} ${battery_percentage}%`,
      )
      .join("\n");
    self.icon = `bluetooth-${bluetooth.enabled ? "active" : "disabled"}-symbolic`;
  }),
});

const network = await Service.import("network");

const Network = Widget.EventBox({
  onMiddleClickRelease: () => Utils.subprocess("nm-applet"),
  child: Widget.Icon().hook(network, (self) => {
    const icon = network[network.primary || "wifi"]?.icon_name;
    self.icon = icon || "";
    self.visible = !!icon;
    const { ssid, strength } = network.wifi;
    self.tooltip_text = ssid ? `${ssid}    ${strength}%` : "";
  }),
});

const SysTray = Widget.Box({
  children: systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon") }),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
        tooltipMarkup: item.bind("tooltip_markup"),
      }),
    ),
  ),
});

const Left = Widget.Box({
  spacing: 8,
  children: [Power, Search, Workspaces, Clients, ClientTitle],
});

const Center = Widget.Box({
  spacing: 8,
  children: [],
});

const Right = Widget.Box({
  hpack: "end",
  spacing: 8,
  children: [
    Traffic,
    Updates,
    Disk,
    Hardware,
    Temp,
    Network,
    Bluetooth,
    Coffee,
    Volume,
    Brightness,
    Battery,
    Clock,
    SysTray,
  ],
});

const Bar = (monitor = 0) =>
  Widget.Window({
    name: `bar-${monitor}`,
    className: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      startWidget: Left,
      centerWidget: Center,
      endWidget: Right,
    }),
  });

App.config({
  style: "./style.css",
  windows: [Bar(), Calendar],
});

Utils.monitorFile(`${App.configDir}/style.css`, function () {
  App.resetCss();
  App.applyCss(`${App.configDir}/style.css`);
});

export {};
