{
  description = "Hazed nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
      hostname = "air";
      user = "hazed";

      nixpkgsConfig = {
        allowUnfree = true;
        allowUnsupportedSystem = false;
      };

      pkgs = import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
      };

      unstable = import inputs.nixpkgs-unstable { inherit system; };
      sketchybarDefaults = import ./darwin/sketchybar/defaults.nix;
      mkSketchybarConfig = pkgs.callPackage ./darwin/sketchybar/package.nix { };
      mkSbarLua = pkgs.callPackage ./darwin/sketchybar/sbar-lua.nix { };
    in {
      formatter.${system} = pkgs.nixfmt;

      packages.${system} = {
        sketchybar-config = mkSketchybarConfig {
          src = ./darwin/sketchybar/src;
          colors = sketchybarDefaults.colors;
          theme = sketchybarDefaults.theme;
          spacesCount = sketchybarDefaults.spaces.count;
        };
        sketchybar-lua = mkSbarLua;
      };

      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs unstable; };

        modules = [
          inputs.nix-index-database.darwinModules.nix-index
          ./darwin
          ({ pkgs, inputs, ... }: {
            nixpkgs.config = nixpkgsConfig;

            system = {
              stateVersion = 6;
              primaryUser = user;
              configurationRevision = self.rev or self.dirtyRev or null;
            };

            users.users.${user} = {
              home = "/Users/${user}";
              shell = pkgs.nushell;
            };

            networking = {
              computerName = hostname;
              hostName = hostname;
              localHostName = hostname;
            };

            nix = {
              package = pkgs.nixVersions.stable;
              enable = true;
              gc.automatic = false;
              settings = {
                allowed-users = [ user ];
                experimental-features = [ "nix-command" "flakes" ];
                warn-dirty = false;
                auto-optimise-store = false;
              };
            };
          })
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              extraSpecialArgs = {
                inherit inputs unstable;
              };

              users.${user} = { ... }: with inputs; {
                imports = [ ./shell ];
                home.stateVersion = "25.11";
              };
            };
          }
        ];
      };
    };
}
