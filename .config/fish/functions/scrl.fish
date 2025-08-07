function scrl
    set picked (~/.local/bin/python-scripts/script_catalog.py list | rofi -dmenu -p "Script")
    if test -n "$picked"
        set scriptname (string split \t $picked)[1]
        set scriptname (string trim $scriptname)
        ~/.local/bin/python-scripts/script_catalog.py lookup --name "$scriptname" | wl-copy
    end
end
```