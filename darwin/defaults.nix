{ ... }: {
  system.defaults = {
    ".GlobalPreferences"."com.apple.mouse.scaling" = 2.0;

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      orientation = "bottom";
      dashboard-in-overlay = true;
      largesize = 85;
      tilesize = 50;
      magnification = true;
      launchanim = false;
      mru-spaces = false;
      show-recents = false;
      show-process-indicators = false;
      static-only = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      QuitMenuItem = true;
    };

    NSGlobalDomain = {
      AppleFontSmoothing = 0;
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      AppleScrollerPagingBehavior = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 10;
      KeyRepeat = 2;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSWindowResizeTime = 0.0;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.trackpad.scaling" = 1.0;
    };

    CustomUserPreferences = {
      "com.apple.Safari" = {
        WebGrammarCheckingEnabled = false;
        WebContinuousSpellCheckingEnabled = false;
      };
    };
  };
}
