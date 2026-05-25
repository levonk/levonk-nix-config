{
  description = "Computer Use Agent";

  outputs = { self, nixpkgs }: {
    packages.x86_64-darwin.default = nixpkgs.legacyPackages.x86_64-darwin.buildEnv {
        name ="agent-balik";
        paths = [
            nixpkgs.legacyPackages.x86_64-darwin.git
            nixpkgs.legacyPackages.x86_64-darwin.htop
            nixpkgs.legacyPackages.x86_64-darwin.fd
            nixpkgs.legacyPackages.x86_64-darwin.ripgrep
            nixpkgs.legacyPackages.x86_64-darwin.firefox-devedition
            nixpkgs.legacyPackages.x86_64-darwin.microsoft-edge

        ]
    }
  }
}