{ pkgs, ... }: {
  imports = [
    ./system.nix
    ./defaults.nix
    ./fonts.nix
    ./homebrew.nix
    ./sketchybar
  ];
}
