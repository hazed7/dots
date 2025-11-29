{ ... }: {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "10m";

      # UI/UX
      style = "compact";
      inline_height = 12;
      show_preview = false;
      show_help = false;
      show_line_numbers = false;

      filter_mode = "global";
      search_mode = "fuzzy";
    };
  };
}
