{ pkgs, fetchFromGitLab }:

pkgs.python310Packages.buildPythonPackage rec {
  pname = "hydrapaper";
  version = "3.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GabMus";
    repo = "HydraPaper";
    rev = "${version}";
    sha256 = "sha256-NkTLgvWM+6oL8IoMn7KorYndzoLnDFZxwlQkIoKMRjU=";
  };

  buildInputs = with pkgs; [
    gtk4
    libadwaita
    python310
    glib
    dbus
    gobject-introspection
  ];

  propagatedBuildInputs = with pkgs.python310Packages; [
    pygobject3
    pillow
    dbus-python
  ];

  nativeBuildInputs = with pkgs; [
    meson
    blueprint-compiler
    wrapGAppsHook4
    ninja
    pandoc
    pkg-config
    cmake
  ];

  patches = [ ./use-gtk4-update-icon-cache.patch ];

  # Forces custom build method, which is used here
  format = "other";

  # Don't wrap twice
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
}
