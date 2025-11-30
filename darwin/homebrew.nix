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

      "pearcleaner"
    ];
    masApps = {
      "wBlock" = 6746388723;
      "No Translation for YouTube" = 6754244353; # https://github.com/YouG-o/YouTube-No-Translation
    };
    taps = [ ];
  };
}
