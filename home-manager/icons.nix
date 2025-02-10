{ stdenvNoCC, fetchFromGitHub, autoreconfHook, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenvNoCC.mkDerivation {
    name = "ad-strawberry-numix-icons";
    src = fetchFromGitHub {
        owner = "rtlewis88";
        repo = "rtl88-Themes";
        rev = "a2c0286932466476159d9a2194a5e6980f1a66f8"; # this is Arc-Darkest-COLORS-Complete-Desktop branch
        hash = "sha256-Ez+IyzhcuHfv+Gy2JOt+hwDn8kWOtFcvv8lJ+wkn0hc=";
    };

    nativeBuildInputs = [
        gtk3
    ];

    propagatedBuildInputs = [
        gnome-icon-theme
        hicolor-icon-theme
    ];

    dontDropIconThemeCache = true;

    installPhase = ''
        runHook preInstall

        mkdir -p $out/share/icons
        cp -r AD-Strawberry-Numix $out/share/icons/
        gtk-update-icon-cache $out/share/icons/AD-Strawberry-Numix

        runHook postInstall
    '';
}
