import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

const dispatch = ws => Hyprland.sendMessage(`dispatch workspace ${ws}`);

const getIcons = (workspace_id) => {
    const clientList = Hyprland.clients;
    const clients = clientList.filter(client => client.workspace.id === workspace_id);
    
    const iconMap = {
        ' ': ['Vivaldi-stable'],
        ' ': ['foot', 'foot-dropterm'],
        ' ': ['equibop', 'vesktop', 'discord'],
        '󰨞 ': ['code', 'code-url-handler'],
        ' ': ['steam'],
        ' ': ['spotify'],
        '󰨈 ': ['lutris'],
        ' ': ['obsidian', 'mousepad'],
        '󰊴 ': ['/.*steam_app.*'],
        'default': ' ' 
    };

    const getIconForClass = (clientClass) => {
        for (const [icon, matchList] of Object.entries(iconMap)) {
            if (Array.isArray(matchList) && matchList.some(match => {
                if (match instanceof RegExp) {
                    return match.test(clientClass);
                } else {
                    return match === clientClass;
                }
            })) {
                return icon;
            }
        }
        return iconMap['default'];
    };

    const clientIcons = clients.map(client => getIconForClass(client.class));
    return clientIcons.join('');
}

export const Workspaces = () => {
    const workspacesWithClients = Array.from({ length: 10 }, (_, i) => i + 1).filter(i => {
        const clients = Hyprland.clients.filter(client => client.workspace.id === i);
        return clients.length > 0;
    });

    return Widget.EventBox({
        onScrollUp: () => dispatch('+1'),
        onScrollDown: () => dispatch('-1'),
        child: Widget.Box({
            children: workspacesWithClients.map(i => Widget.Button({
                class_name: "ws-button",
                attribute: i,
                // Keeps button from expanding to fit its container
                onClicked: () => dispatch(i),
                child: Widget.Box({
                    class_name: "ws-indicator",
                    // vpack: "start",
                    vpack: "center",
                    hpack: "center",
                    children: [
                        Widget.Label({
                            label: `${i} ${getIcons(i)}`,
                            justification: "center",
                        })
                    ],
                    setup: self => self.hook(Hyprland, () => {
                        console.log(Hyprland.getWorkspace(i))
                        // The "?" is used here to return "undefined" if the workspace doesn't exist
                        self.toggleClassName('ws-inactive', (Hyprland.getWorkspace(i)?.windows || 0) === 0);
                        self.toggleClassName('ws-occupied', (Hyprland.getWorkspace(i)?.windows || 0) > 0);
                        self.toggleClassName('ws-active', Hyprland.active.workspace.id === i);
                        self.toggleClassName('ws-large', (Hyprland.getWorkspace(i)?.windows || 0) > 1);
                    }),
                }),
            })),
        }),
    });
}

// export const SpecialWorkspace = () => Widget.Label({
//     label: "test", 
// }).hook(Hyprland, self => {
//     print(Hyprland.active.workspace.id)
//     if (Hyprland.active.workspace.id == -99){
//         self.label = "special"
//     }
//     else {
//         self.label = "not"
//     }
// })