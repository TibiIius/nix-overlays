{ pkgsShell ? import <nixpkgs> { } }:
pkgsShell.mkShell {
  nativeBuildInputs = with pkgsShell; [ nixpkgs-fmt rnix-lsp ];
}
