{ pkgs, fetchFromGitLab, lib }:

pkgs.stdenv.mkDerivation rec {
  pname = "libadwaita-without-adwaita";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = "${version}";
    sha256 = "sha256-3lH7Vi9M8k+GSrCpvruRpLrIpMoOakKbcJlaAc/FK+U=";
  };

  patches = [ ./theming.patch ];

  buildInputs = with pkgs; [
    fribidi
    gtk4
    gobject-introspection
  ];

  nativeBuildInputs = with pkgs; [
    meson
    glib
    ninja
    cmake
    sassc
    vala
    pkg-config
  ];
}
