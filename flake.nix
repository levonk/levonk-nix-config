{
  description = "Levonk's Nix Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Host Configurations
      homeConfigurations = {
        # 1. WSL Dev
        "wsl-dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/wsl-dev/default.nix ];
        };

        # 3. Debian Remote
        "debian-remote" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/debian-remote/default.nix ];
        };

        # 4. Debian GUI
        "debian-gui" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/debian-gui/default.nix ];
        };

        # 5. Qubes Dev
        "qubes-dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/qubes-dev/default.nix ];
        };
      };

      # Mac Configuration (managed by nix-darwin)
      darwinConfigurations = {
        # 2. Mac GUI
        "mac-gui" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./hosts/mac-gui/default.nix ];
        };
      };

      # Checks for CI
      checks = forAllSystems (system: {
        # This lets us run 'nix flake check' to verify everything builds
        format = nixpkgs.legacyPackages.${system}.runCommand "check-format" {} ''
          touch $out
        '';
      });
    };
}
