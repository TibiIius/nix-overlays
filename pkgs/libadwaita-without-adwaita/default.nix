{ pkgs, fetchFromGitLab, fetchpatch }:

pkgs.stdenv.mkDerivation rec {
  pname = "libadwaita-without-adwaita";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = "${version}";
    sha256 = "sha256-+bgCD2jy3M0gEAtbB+nOptQGEXXkvk1idoggJz4UMy0=";
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
