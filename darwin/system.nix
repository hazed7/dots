{ pkgs, ... }: {
  programs = {
    zsh.enable = true;
    nix-index.enable = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
