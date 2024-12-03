## Keys
from libqtile.config import Key, KeyChord
from libqtile.lazy import lazy

## Mouse
from libqtile.config import Click, Drag

## Groups
from libqtile.config import Group, Match

## Layouts
from libqtile import layout

## Screens
from libqtile.config import Screen
from libqtile import bar, widget

## Qtile Extras
from qtile_extras.widget.groupbox2 import GroupBoxRule
from qtile_extras import widget as extraWidget

## ScratchPad and DropDown
from libqtile.config import ScratchPad, DropDown

## Startup
import os
import subprocess
from libqtile import hook


## Startup ------------------------------
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.Popen([home + "/dotfiles/qtile/autostart"])


# Dunst notifications
notify_cmd = "dunstify -u low -h string:x-dunst-stack-tag:qtileconfig"

## Key Bindings ------------------------------

# The mod key for the default config is 'mod4', which is typically bound to the "Super" keys,
# which are things like the windows key and the mac command key.
mod = "mod4"

# Scripts/Apps Variables
home = os.path.expanduser("~")
volume = home + "/dotfiles/qtile/volume"
rofi_launcher = home + "/dotfiles/rofi/rofi_launcher"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Terminal --
    Key([mod], "Return", lazy.spawn("wezterm"), desc="Launch wezterm"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Toggle wezterm scratchpad",
    ),
    # Rofi Applets --
    Key(["mod1"], "F1", lazy.spawn(rofi_launcher), desc="Run application launcher"),
    # GUI Apps --
    Key([mod, "shift"], "f", lazy.spawn("thunar"), desc="Launch Thunar file manager"),
    Key([mod, "shift"], "w", lazy.spawn("vivaldi"), desc="Launch Vivaldi web browser"),
    Key([mod, "shift"], "d", lazy.spawn("discord"), desc="Launch Discord"),
    Key([mod, "shift"], "l", lazy.spawn("lutris"), desc="Launch Lutris"),
    Key([mod, "shift"], "s", lazy.spawn("steam"), desc="Launch Steam"),
    Key(
        [mod, "shift"],
        "y",
        lazy.spawn("wezterm start --always-new-process yazi"),
        desc="Launch Yazi",
    ),
    Key([mod, "shift"], "c", lazy.spawn("copyq toggle"), desc="Toggle CopyQ"),
    # Screenshot
    Key([mod], "s", lazy.spawn("flameshot gui"), desc="Take screenshot with Flameshot"),
    # Function keys : Volume --
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn(volume + " --inc"),
        desc="Raise speaker volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn(volume + " --dec"),
        desc="Lower speaker volume",
    ),
    Key([], "XF86AudioMute", lazy.spawn(volume + " --toggle"), desc="Toggle mute"),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn(volume + " --toggle-mic"),
        desc="Toggle mute for mic",
    ),
    # Function keys : Media --
    Key([], "XF86AudioNext", lazy.spawn("mpc next"), desc="Next track"),
    Key([], "XF86AudioPrev", lazy.spawn("mpc prev"), desc="Previous track"),
    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle"), desc="Toggle play/pause"),
    Key([], "XF86AudioStop", lazy.spawn("mpc stop"), desc="Stop playing"),
    # WM Specific --
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    # Control Qtile
    Key(
        [mod, "control"],
        "r",
        lazy.reload_config(),
        lazy.spawn(notify_cmd + ' "Configuration Reloaded!"'),
        desc="Reload the config",
    ),
    Key(
        [mod, "control"],
        "s",
        lazy.restart(),
        lazy.spawn(notify_cmd + ' "Restarting Qtile..."'),
        desc="Restart Qtile",
    ),
    Key(
        [mod, "control"],
        "q",
        lazy.shutdown(),
        lazy.spawn(notify_cmd + ' "Exiting Qtile..."'),
        desc="Shutdown Qtile",
    ),
    # Switch between windows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "shift"],
        "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "control"],
        "Left",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "Right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key(
        [mod, "control"],
        "Return",
        lazy.layout.normalize(),
        desc="Reset all window sizes",
    ),
    # Toggle floating and fullscreen
    Key(
        [mod],
        "space",
        lazy.window.toggle_floating(),
        desc="Put the focused window to/from floating mode",
    ),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Put the focused window to/from fullscreen mode",
    ),
    # Go to next/prev group
    Key(
        [mod, "mod1"],
        "Right",
        lazy.screen.next_group(),
        desc="Move to the group on the right",
    ),
    Key(
        [mod, "mod1"],
        "Left",
        lazy.screen.prev_group(),
        desc="Move to the group on the left",
    ),
    # Back-n-forth groups
    Key([mod], "b", lazy.screen.toggle_group(), desc="Move to the last visited group"),
    # Change focus to other window
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Toggle between different layouts as defined below
    Key([mod, "shift"], "space", lazy.next_layout(), desc="Toggle between layouts"),
    # Increase the space for master window at the expense of slave windows
    Key(
        [mod],
        "equal",
        lazy.layout.increase_ratio(),
        desc="Increase the space for master window",
    ),
    # Decrease the space for master window in the advantage of slave windows
    Key(
        [mod],
        "minus",
        lazy.layout.decrease_ratio(),
        desc="Decrease the space for master window",
    ),
    # Toggle between split and unsplit sides of stack.
    Key(
        [mod, "shift"],
        "s",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
]

## Mouse Bindings ------------------------------

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

## Groups ------------------------------
groups = [
    # Screen affinity here is used to make
    # sure the groups startup on the right screens
    Group(name="1", screen_affinity=1),
    Group(name="2", screen_affinity=0),
    Group(name="3", screen_affinity=1),
    Group(name="4", screen_affinity=0),
    Group(name="5", screen_affinity=1),
    Group(name="6", screen_affinity=0),
    Group(name="7", screen_affinity=1),
    Group(name="8", screen_affinity=0),
    Group(name="9", screen_affinity=1),
    Group(name="0", screen_affinity=0),
]

## ScratchPads ------------------------
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                "wezterm start --class wezterm-scratchpad",
                width=0.4,
                height=0.5,
                x=0.3,
                y=0.1,
                opacity=1,
            ),
        ],
    )
)


## Change active group
def go_to_group(name: str):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.groups_map[name].toscreen()
            return

        if name in "13579":
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()
        else:
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()

    return _inner


for i in groups:
    if i.name != "scratchpad":
        keys.append(Key([mod], i.name, lazy.function(go_to_group(i.name))))


## Move window to group
def go_to_group_and_move_window(name: str):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.current_window.togroup(name, switch_group=True)
            return

        if name in "13579":
            qtile.current_window.togroup(name, switch_group=False)
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()
        else:
            qtile.current_window.togroup(name, switch_group=False)
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()

    return _inner


for i in groups:
    if i.name != "scratchpad":
        keys.append(
            Key(
                [mod, "shift"],
                i.name,
                lazy.function(go_to_group_and_move_window(i.name)),
            )
        )

## Layouts ------------------------------
var_border_width = 3
var_margin = [5, 5, 5, 5]
var_gap_top = 45
var_gap_bottom = 5
var_gap_left = 5
var_gap_right = 5
var_font_name = "AnonymicePro Nerd Font"

layouts = [
    # Extension of the Stack layout
    layout.Columns(
        border_focus="#DD9998",
        border_normal="#A06666",
        border_on_single=False,
        border_width=var_border_width,
        fair=False,
        grow_amount=10,
        insert_position=0,
        margin=var_margin,
        margin_on_single=None,
        num_columns=2,
        split=True,
        wrap_focus_columns=True,
        wrap_focus_rows=True,
        wrap_focus_stacks=True,
    )
]

group_rules = [
    GroupBoxRule(text_colour="#A06666").when(focused=False, occupied=True),
    GroupBoxRule(text_colour="#DD9998").when(focused=True, occupied=True),
    GroupBoxRule(text_colour="#5F8787").when(focused=False, occupied=False),
    GroupBoxRule(line_position=GroupBoxRule.LINE_TOP).when(focused=True, occupied=True),
    GroupBoxRule(line_colour="#DD9998").when(focused=True, occupied=True),
    GroupBoxRule(line_width=3).when(focused=True, occupied=True),
]

## Screens ------------------------------
screens = [
    # HDMI monitor
    Screen(
        top=bar.Bar(
            [
                widget.LaunchBar(
                    progs=[
                        (
                            "/home/careb0t/dotfiles/qtile/nixos.png",
                            "rofi -show drun -kb-cancel Alt-F1 -theme /home/careb0t/dotfiles/rofi/launcher.rasi",
                            "Rofi Launcher",
                        )
                    ],
                    padding_y=-1,
                    padding=20,
                    icon_size=32,
                ),
                extraWidget.GroupBox2(
                    visible_groups=["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                    rules=group_rules,
                    fontsize=22,
                    padding_x=10,
                ),
                widget.Spacer(),
                widget.WindowName(foreground="DD9998", fontsize=18),
                widget.Spacer(),
                extraWidget.StatusNotifier(),
                widget.Clock(format="%m/%d/%y | %I:%M %p", foreground="#DD9998"),
                widget.QuickExit(foreground="#DD9998"),
                extraWidget.CurrentLayoutIcon(
                    use_mask=True, foreground="#DD9998", scale=0.75
                ),
            ],
            48,
            background="#00000000",
            margin=[0, 0, 0, 0],
            opacity=1,
            border_width=[0, 0, 0, 0],
            border_color=["000000", "000000", "000000", "000000"],
        ),
    ),
    # DPI monitor
    Screen(
        top=bar.Bar(
            [
                widget.LaunchBar(
                    progs=[
                        (
                            "/home/careb0t/dotfiles/qtile/nixos.png",
                            "rofi -show drun -kb-cancel Alt-F1 -theme /home/careb0t/dotfiles/rofi/launcher.rasi",
                            "Rofi Launcher",
                        )
                    ],
                    padding_y=-1,
                    padding=20,
                    icon_size=25,
                ),
                extraWidget.GroupBox2(
                    visible_groups=["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                    rules=group_rules,
                    fontsize=18,
                    padding_x=10,
                ),
                widget.Spacer(),
                widget.WindowName(
                    foreground="DD9998",
                ),
                widget.Spacer(),
                extraWidget.StatusNotifier(),
                widget.Clock(format="%m/%d/%y | %I:%M %p", foreground="#DD9998"),
                widget.QuickExit(foreground="#DD9998"),
                extraWidget.CurrentLayoutIcon(
                    use_mask=True, foreground="#DD9998", scale=0.75
                ),
            ],
            34,
            background="#00000000",
            margin=[0, 0, 0, 0],
            opacity=1,
            border_width=[0, 0, 0, 0],
            border_color=["000000", "000000", "000000", "000000"],
        ),
    ),
]

# Floating configuration
floating_layout = layout.Floating(
    border_focus="#DD9998",
    border_normal="#A06666",
    border_width=var_border_width,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="copyq"),
        Match(wm_class="wezterm-scratchpad"),
        # Match(title="branchdialog"),
    ],
)

## General Configuration Variables ------------------------------

# If a window requests to be fullscreen, it is automatically fullscreened.
# Set this to false if you only want windows to be fullscreen if you ask them to be.
auto_fullscreen = True

# When clicked, should the window be brought to the front or not.
# If this is set to "floating_only", only floating windows will get affected (This sets the X Stack Mode to Above.)
bring_front_click = False

# If true, the cursor follows the focus as directed by the keyboard, warping to the center of the focused window.
# When switching focus between screens, If there are no windows in the screen, the cursor will warp to the center of the screen.
cursor_warp = True

# A function which generates group binding hotkeys. It takes a single argument, the DGroups object, and can use that to set up dynamic key bindings.
# A sample implementation is available in 'libqtile/dgroups.py' called `simple_key_binder()`, which will bind groups to "mod+shift+0-10" by default.
dgroups_key_binder = None

# A list of Rule objects which can send windows to various groups based on matching criteria.
dgroups_app_rules = []  # type: list

# Behavior of the _NET_ACTIVATE_WINDOW message sent by applications
#
# urgent: urgent flag is set for the window
# focus: automatically focus the window
# smart: automatically focus if the window is in the current group
# never: never automatically focus any window that requests it
focus_on_window_activation = "smart"

# Controls whether or not focus follows the mouse around as it moves across windows in a layout.
follow_mouse_focus = True

# Default settings for bar widgets.
widget_defaults = dict(
    font=var_font_name,
    fontsize=14,
    padding=5,
)

# Same as `widget_defaults`, Default settings for extensions.
extension_defaults = widget_defaults.copy()

# Controls whether or not to automatically reconfigure screens when there are changes in randr output configuration.
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
# wmname = "LG3D"

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None
