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
        in
        {
          packages = {
            inherit (pkgs)
              hydrapaper;
          };
        }
      ) //
    {
      overlays.default = final: prev: {
        hydrapaper = final.callPackage ./pkgs/hydrapaper { };
      };
    };
}
