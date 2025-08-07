function smart-rofi
    # Create a comprehensive command list with categories
    begin
        echo "=== Executables ==="
        complete -C ''
        echo -e "\n=== Functions ==="
        functions --names
        echo -e "\n=== Abbreviations ==="
        abbr --list
        echo -e "\n=== Recent ==="
        history | head -20
    end | rofi -dmenu -i -p "Fish Commands" -mesg "Select a command to run"
end
