export def clean [] {
  ^nix-collect-garbage -d
  ^nix-store --gc
  ^nix store optimise
  ^nix-store --verify --check-contents
}
