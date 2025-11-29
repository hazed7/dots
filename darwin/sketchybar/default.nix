{ pkgs, lib, config, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;

  defaults = import ./defaults.nix;
  mkSketchybarConfig = pkgs.callPackage ./package.nix { };
  cfg = config.hazed.sketchybar;

  hexType = types.strMatching "0x[0-9a-fA-F]+";
  colorOption = default: mkOption {
    inherit default;
    type = hexType;
    example = "0xff1a1b26";
  };
  nestedColorOption = default: types.submodule {
    options = {
      bg = colorOption default.bg;
      border = colorOption default.border;
    };
  };
in {
  options.hazed.sketchybar = {
    enable = mkEnableOption "opinionated sketchybar configuration" // {
      default = true;
    };

    colors = mkOption {
      default = defaults.colors;
      type = types.submodule {
        options = {
          black = colorOption defaults.colors.black;
          white = colorOption defaults.colors.white;
          red = colorOption defaults.colors.red;
          green = colorOption defaults.colors.green;
          blue = colorOption defaults.colors.blue;
          yellow = colorOption defaults.colors.yellow;
          orange = colorOption defaults.colors.orange;
          magenta = colorOption defaults.colors.magenta;
          grey = colorOption defaults.colors.grey;
          transparent = colorOption defaults.colors.transparent;
          bar = nestedColorOption defaults.colors.bar;
          popup = nestedColorOption defaults.colors.popup;
          bg1 = colorOption defaults.colors.bg1;
          bg2 = colorOption defaults.colors.bg2;
        };
      };
      description = "Color palette used by the Lua configuration.";
    };

    theme = mkOption {
      default = defaults.theme;
      type = types.submodule {
        options = {
          paddings = mkOption {
            type = types.int;
            default = defaults.theme.paddings;
            description = "Outer padding for widgets.";
          };
          groupPaddings = mkOption {
            type = types.int;
            default = defaults.theme.groupPaddings;
            description = "Spacing inserted between grouped widgets.";
          };
          iconSet = mkOption {
            type = types.str;
            default = defaults.theme.iconSet;
            example = "nerd-font";
            description = "Icon set hint consumed by the Lua layer.";
          };
          fontModule = mkOption {
            type = types.str;
            default = defaults.theme.fontModule;
            example = "helpers.nerd_font";
            description = "Lua module (relative to CONFIG_DIR) that returns the font map.";
          };
        };
      };
      description = "General SketchyBar theme knobs surfaced to Nix.";
    };

    spaces.count = mkOption {
      type = types.int;
      default = defaults.spaces.count;
      description = "Number of spaces rendered on the left side.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [ jq gh switchaudio-osx ];
      description = "Packages added to PATH for helper scripts.";
    };
  };

  config = mkIf cfg.enable (
    let
      sketchybarConfig = mkSketchybarConfig {
        src = ./src;
        colors = cfg.colors;
        theme = cfg.theme;
        spacesCount = cfg.spaces.count;
      };
    in {
      services.sketchybar = {
        enable = true;
        extraPackages = cfg.extraPackages;
      };

      launchd.user.agents.sketchybar.serviceConfig = {
        ProgramArguments = lib.mkForce [
          "${config.services.sketchybar.package}/bin/sketchybar"
          "--config"
          "${sketchybarConfig}/sketchybarrc"
        ];
        EnvironmentVariables = lib.mkForce {
          CONFIG_DIR = "${sketchybarConfig}";
          LUA_PATH = "${sketchybarConfig}/?.lua;${sketchybarConfig}/?/init.lua;;";
        };
      };

      system.defaults.NSGlobalDomain._HIHideMenuBar = true;
    }
  );
}
