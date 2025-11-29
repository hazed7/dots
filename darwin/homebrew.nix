{ ... }: {
  homebrew = {
    enable = true;
    global = { autoUpdate = false; };
    onActivation = {
      cleanup = "zap";
      autoUpdate = false;
      upgrade = false;
    };
    brews = [
      "yt-dlp"
      "ruff"
      "mas"
    ];
    casks = [
      "cursor"

      "ghostty"
      "siyuan"

      # other
      "keka"
      "sf-symbols"
      "iina"

      "telegram"
    ];
    taps = [ ];
  };
}
