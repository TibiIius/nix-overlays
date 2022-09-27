{
  description = "My own custom Nix overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      inherit (flake-utils.lib) eachSystem system;
    in
    eachSystem [ system.x86_64-linux ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
          pkgsShell = nixpkgs.legacyPackages.${system};
        in
        {
          devShells.default = import ./shell.nix { inherit pkgsShell; };
          packages = {
            inherit (pkgs)
              hydrapaper
              libadwaita-without-adwaita;
          };
        }
      ) //
    {
      overlays.default = final: prev: {
        hydrapaper = final.callPackage ./pkgs/hydrapaper { };
        libadwaita-without-adwaita = final.callPackage ./pkgs/libadwaita-without-adwaita { };
      };
    };
}
