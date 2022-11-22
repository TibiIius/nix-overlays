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
        gnome = prev.gnome // {
          gnome-keyring = (prev.gnome.gnome-keyring.override {
            glib = prev.glib.overrideAttrs (a: rec {
              patches = a.patches ++ [
                (final.fetchpatch {
                  url =
                    "https://gitlab.gnome.org/GNOME/glib/-/commit/2a36bb4b7e46f9ac043561c61f9a790786a5440c.patch";
                  sha256 = "b77Hxt6WiLxIGqgAj9ZubzPWrWmorcUOEe/dp01BcXA=";
                })
              ];
            });
          });
        };
      };
    };
}
