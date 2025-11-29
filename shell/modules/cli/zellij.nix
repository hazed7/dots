{ pkgs, ... }: {
  home.packages = with pkgs; [ zellij ];

  xdg.configFile."zellij/config.kdl".text = ''
    simplified_ui true
    pane_frames false
    theme "tokyonight-storm"
    default_layout "compact"
    default_shell "zsh"
    scrollback_editor "nvim"
  '';
}
