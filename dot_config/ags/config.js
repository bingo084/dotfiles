const systemtray = await Service.import("systemtray");

const hyprland = await Service.import("hyprland");

const dispatch = (
  /** @type string */ dispatcher,
  /** @type {string | number} */ ws,
) => hyprland.messageAsync(`dispatch ${dispatcher} ${ws}`);
const activeId = hyprland.active.workspace.bind("id");
const defaultIds = [1, 2, 3, 4, 5];

const Workspaces = () =>
  Widget.EventBox({
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
          // onHover: () => console.log(at),
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

const date = Variable("", {
  poll: [1000, "date '+%a, %b %d  %H:%M'"],
});

const Clock = Widget.Label({
  className: "clock",
  label: date.bind(),
});

const audio = await Service.import("audio");
const changeVolume = (/** @type {number} */ n) =>
  (audio.speaker.volume = Math.min(audio.speaker.volume + n / 100, 1));
const Volume = Widget.EventBox({
  onMiddleClick: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
  onScrollUp: () => changeVolume(1),
  onScrollDown: () => changeVolume(-1),
  child: Widget.Icon().hook(audio.speaker, (self) => {
    const vol = audio.speaker.volume * 100;
    const icon = audio.speaker.is_muted
      ? "muted"
      : [
          [101, "overamplified"],
          [67, "high"],
          [34, "medium"],
          [1, "low"],
          [0, "muted"],
        ].find(([threshold]) => threshold <= vol)?.[1];

    self.icon = `audio-volume-${icon}-symbolic`;
    self.tooltip_text = `${Math.floor(vol)}%`;
  }),
});

const battery = await Service.import("battery");
const Battery = Widget.Box({
  classNames: battery
    .bind("charging")
    .as((ch) => (ch ? ["battery", "charging"] : ["battery"])),
  visible: battery.bind("available"),
  children: [
    Widget.Icon({ icon: battery.bind("icon_name") }),
    Widget.Label({
      label: battery.bind("percent").as((b) => " " + b + "%"),
    }),
  ],
});

const bluetooth = await Service.import("bluetooth");

function Bluetooth() {
  const connectedList = Widget.Box({
    setup: (self) =>
      self.hook(
        bluetooth,
        (self) => {
          self.children = bluetooth.connected_devices.map(
            ({ icon_name, name }) =>
              Widget.Box([
                Widget.Icon(icon_name + "-symbolic"),
                Widget.Label(name),
              ]),
          );

          self.visible = bluetooth.connected_devices.length > 0;
        },
        "notify::connected-devices",
      ),
  });

  const indicator = Widget.Icon({
    icon: bluetooth
      .bind("enabled")
      .as((on) => `bluetooth-${on ? "active" : "disabled"}-symbolic`),
  });

  return Widget.EventBox({
    onMiddleClick: () => (bluetooth.enabled = !bluetooth.enabled),
    child: Widget.Box([indicator, connectedList]),
  });
}

const network = await Service.import("network");

function Network() {
  const WifiIndicator = Widget.Box({
    children: [
      Widget.Icon({
        icon: network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: network.wifi.bind("ssid").as((ssid) => ssid || "Unknown"),
      }),
    ],
  });

  const WiredIndicator = Widget.Icon({
    icon: network.wired.bind("icon_name"),
  });

  return Widget.Stack({
    children: {
      wifi: WifiIndicator,
      wired: WiredIndicator,
    },
    shown: network.bind("primary").as((p) => p || "wifi"),
  });
}

function SysTray() {
  const items = systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon") }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      }),
    ),
  );

  return Widget.Box({
    children: items,
  });
}

// layout of the bar
const Left = () =>
  Widget.Box({
    spacing: 8,
    children: [Workspaces(), Clients, ClientTitle],
  });

const Center = () =>
  Widget.Box({
    spacing: 8,
    children: [],
  });

const Right = () =>
  Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [Network(), Bluetooth(), Volume, Battery, Clock, SysTray()],
  });

const Bar = (monitor = 0) =>
  Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

App.config({
  style: "./style.css",
  windows: [Bar()],
});

Utils.monitorFile(`${App.configDir}/style.css`, function () {
  App.resetCss();
  App.applyCss(`${App.configDir}/style.css`);
});

export {};
