#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Screenshots scripts

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

dir="$(xdg-user-dir)/Pictures/Screenshots"

# notify and view screenshot
notify_view() {
    local check_file="$1"
    case "$2" in
        save)
            if [[ -e "$check_file" ]]; then
                ${notify_cmd_shot} "Screenshot Saved."
                "${sDIR}/Sounds.sh" --screenshot
            else
                ${notify_cmd_shot} "Screenshot NOT Saved."
                "${sDIR}/Sounds.sh" --error
            fi
            ;;
        copy)
            if wl-copy < "$check_file"; then
                ${notify_cmd_shot} "Screenshot Copied."
            else
                ${notify_cmd_shot} "Screenshot NOT Copied."
            fi
            ;;
        swappy)
            swappy -f "$check_file"
            if [[ $? -eq 0 ]]; then
                if [[ -e "$check_file" ]]; then
                    ${notify_cmd_shot} "Screenshot Saved."
                    "${sDIR}/Sounds.sh" --screenshot
                else
                    ${notify_cmd_shot} "Screenshot Copied."
                fi
            else
                ${notify_cmd_shot} "Error: Couldn't Open Swappy."
                "${sDIR}/Sounds.sh" --error
            fi
            ;;
        *)
            ${notify_cmd_shot} "Invalid Argument."
            "${sDIR}/Sounds.sh" --error
            ;;
    esac
}

# countdown
countdown() {
    for sec in $(seq $1 -1 1); do
        notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR"/timer.png "Taking shot in : $sec"
        sleep 1
    done
}

# take shots
shotnow() {
    local filename="$dir/Screenshot_$(date +%b-%e-%y_%r).png"
    grim "$filename" && notify_view "$filename" "save"
}

shotworkspace() {
    local filename="$dir/Screenshot_$(date +%b-%e-%y_%r).png"
    if hyprctl activeworkspace | grep -q "DP-1"; then
        grim -c -o DP-1 "$filename" && notify_view "$filename" "save"
    elif hyprctl activeworkspace | grep -q "HDMI-A-1"; then
        grim -c -o HDMI-A-1 "$filename" && notify_view "$filename" "save"
    fi
}

shotarea() {
    local filename="$dir/Screenshot_$(date +%b-%e-%y_%r).png"
    grim -g "$(slurp)" "$filename" && notify_view "$filename" "save"
}

shotactive() {
    local filename="$dir/Screenshot_$(date +%b-%e-%y_%r).png"
    local w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
    local w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
    grim -g "$w_pos $w_size" "$filename" && notify_view "$filename" "save"
}

# shot5() {
#     countdown '5'
#     tmpfile=$(mktemp)
#     grim - | tee "$tmpfile" && "${sDIR}/Sounds.sh" --screenshot && notify_view "save"
#     swappy -f - <"$tmpfile"
#     rm "$tmpfile"
# }

# shot10() {
#     countdown '10'
#     tmpfile=$(mktemp)
#     grim - | tee "$tmpfile" && "${sDIR}/Sounds.sh" --screenshot && notify_view "save"
#     swappy -f - <"$tmpfile"
#     rm "$tmpfile"
# }

shotnow_copy() {
    tmpfile=$(mktemp)
    grim - | tee "$tmpfile" | wl-copy
    notify_view "$tmpfile" "copy"
    rm "$tmpfile"
}

shotarea_copy() {
    tmpfile=$(mktemp)
    grim -g "$(slurp)" - >"$tmpfile" && wl-copy < "$tmpfile"
    notify_view "$tmpfile" "copy"
    rm "$tmpfile"
}

shotworkspace_copy() {
    tmpfile=$(mktemp)
    if hyprctl activeworkspace | grep -q "DP-1"; then
        grim -c -o DP-1 - >"$tmpfile" && wl-copy < "$tmpfile"
    elif hyprctl activeworkspace | grep -q "HDMI-A-1"; then
        grim -c -o HDMI-A-1 - >"$tmpfile" && wl-copy < "$tmpfile"
    fi
    notify_view "$tmpfile" "copy"
    rm "$tmpfile"
}

shotactive_copy() {
    tmpfile=$(mktemp)
    local w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
    local w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
    grim -g "$w_pos $w_size" - >"$tmpfile" && wl-copy < "$tmpfile"
    notify_view "$tmpfile" "copy"
    rm "$tmpfile"
}

shotnow_swappy() {
    tmpfile=$(mktemp)
    grim - >"$tmpfile"
    notify_view "$tmpfile" "swappy"
    rm -f "$tmpfile"
}

shotarea_swappy() {
    tmpfile=$(mktemp)
    grim -g "$(slurp)" - >"$tmpfile"
    notify_view "$tmpfile" "swappy"
    rm -f "$tmpfile"
}

shotworkspace_swappy() {
    tmpfile=$(mktemp)
    if hyprctl activeworkspace | grep -q "DP-1"; then
        grim -c -o DP-1 - >"$tmpfile"
    elif hyprctl activeworkspace | grep -q "HDMI-A-1"; then
        grim -c -o HDMI-A-1 - >"$tmpfile"
    fi
    notify_view "$tmpfile" "swappy"
    rm -f "$tmpfile"
}

shotactive_swappy() {
    tmpfile=$(mktemp)
    local w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
    local w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
    grim -g "$w_pos $w_size" - >"$tmpfile"
    notify_view "$tmpfile" "swappy"
    rm -f "$tmpfile"
}


if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

if [[ "$1" == "--now" ]]; then
    shotnow
elif [[ "$1" == "--workspace" ]]; then
    shotworkspace
elif [[ "$1" == "--area" ]]; then
    shotarea
elif [[ "$1" == "--active" ]]; then
    shotactive
elif [[ "$1" == "--now-copy" ]]; then
    shotnow_copy
elif [[ "$1" == "--area-copy" ]]; then
    shotarea_copy
elif [[ "$1" == "--workspace-copy" ]]; then
    shotworkspace_copy
elif [[ "$1" == "--now-swappy" ]]; then
    shotnow_swappy
elif [[ "$1" == "--area-swappy" ]]; then
    shotarea_swappy
elif [[ "$1" == "--workspace-swappy" ]]; then
    shotworkspace_swappy
elif [[ "$1" == "--active-copy" ]]; then
    shotactive_copy
elif [[ "$1" == "--active-swappy" ]]; then
    shotactive_swappy
else
    echo "Invalid option"
    exit 1
fi

exit 0
