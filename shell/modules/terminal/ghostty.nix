{ ... }: {
  xdg.configFile."ghostty/config".text = ''
    # --- Font ---
    font-family = "0xProto Nerd Font"
    font-size = 14
    # font-style = Bold

    # --- Window ---
    window-padding-x = 5
    window-padding-y = 5
    window-decoration = true
    background-opacity = 0.78
    background-blur = 25

    # --- Mouse & Cursor ---
    mouse-hide-while-typing = true
    cursor-style = block
    cursor-style-blink = true
    mouse-scroll-multiplier = precision:0.8,discrete:2.5

    # --- Scrolling ---
    scrollback-limit = 1000

    # Selection tinting until upstream exposes rounded selection controls.
    selection-background = #1f1f28
    selection-foreground = #dcd7ba

    # --- Link UX ---
    link-previews = true

    # --- macOS ---
    macos-option-as-alt = true
    shell-integration = detect

    # --- Theme ---
    theme = Oxocarbon
  '';
}
