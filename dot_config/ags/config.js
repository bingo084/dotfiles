const systemtray = await Service.import("systemtray");

const hyprland = await Service.import("hyprland");

function Workspaces() {
  const dispatch = (ws) => hyprland.messageAsync(`dispatch workspace ${ws}`);
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .map(({ id }) => id)
      .sort()
      .map((id) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as((i) => (i === id ? "focused" : "")),
        }),
      ),
  );
  return Widget.EventBox({
    className: "workspaces",
    onScrollUp: () => dispatch("-1"),
    onScrollDown: () => dispatch("+1"),
    child: Widget.Box({
      children: workspaces,
    }),
  });
}

const ClientTitle = Widget.Label({
  className: "client-title",
  label: hyprland.active.client.bind("title"),
  visible: hyprland.active.client.bind("address").as((addr) => !!addr),
});

const date = Variable("", {
  poll: [1000, 'date "+%H:%M  %a %d. %b"'],
});

const Clock = Widget.Label({
  class_name: "clock",
  label: date.bind(),
});

const audio = await Service.import("audio");
function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  function getIcon() {
    const icon = audio.speaker.is_muted
      ? 0
      : [101, 67, 34, 1, 0].find(
        (threshold) => threshold <= audio.speaker.volume * 100,
      );

    return `audio-volume-${icons[icon]}-symbolic`;
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const label = Widget.Label({
    label: audio.speaker
      .bind("volume")
      .as((v) => " " + Math.round(v * 100) + "%"),
  });

  const changeVolume = (n) =>
    (audio.speaker.volume = Math.min(audio.speaker.volume + n / 100, 1));

  return Widget.EventBox({
    className: "volume",
    onMiddleClick: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
    onScrollUp: () => changeVolume(1),
    onScrollDown: () => changeVolume(-1),
    child: Widget.Box({
      children: [icon, label],
    }),
  });
}

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
    children: [Workspaces(), ClientTitle],
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
    children: [Network(), Bluetooth(), Volume(), Battery, Clock, SysTray()],
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

Utils.monitorFile(`${App.configDir}/style.css`, function() {
  App.resetCss();
  App.applyCss(`${App.configDir}/style.css`);
});

export { };
