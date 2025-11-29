{ lib, stdenv, gnumake, clang }:
{ src
, colors
, theme
, spacesCount
}:

let
  colorVars = {
    color_black = colors.black;
    color_white = colors.white;
    color_red = colors.red;
    color_green = colors.green;
    color_blue = colors.blue;
    color_yellow = colors.yellow;
    color_orange = colors.orange;
    color_magenta = colors.magenta;
    color_grey = colors.grey;
    color_transparent = colors.transparent;
    color_bar_bg = colors.bar.bg;
    color_bar_border = colors.bar.border;
    color_popup_bg = colors.popup.bg;
    color_popup_border = colors.popup.border;
    color_bg1 = colors.bg1;
    color_bg2 = colors.bg2;
  };

  mkExportLines = vars:
    lib.concatStringsSep "\n"
      (lib.mapAttrsToList (name: value: "export ${name}='${value}'") vars);
in
stdenv.mkDerivation {
  pname = "sketchybar-config";
  version = "1.0.0";
  inherit src;
  nativeBuildInputs = [ gnumake clang ];
  dontConfigure = true;

  postPatch = ''
    ${mkExportLines colorVars}
    substituteAllInPlace colors.lua.in
    mv colors.lua.in colors.lua

    export paddings='${toString theme.paddings}'
    export group_paddings='${toString theme.groupPaddings}'
    export icon_set='${theme.iconSet}'
    export font_module='${theme.fontModule}'
    substituteAllInPlace settings.lua.in
    mv settings.lua.in settings.lua

    export spaces_count='${toString spacesCount}'
    substituteAllInPlace items/spaces.lua.in
    mv items/spaces.lua.in items/spaces.lua
  '';

  buildPhase = ''
    runHook preBuild
    make -C helpers
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -R . $out
    chmod +x $out/sketchybarrc
    runHook postInstall
  '';
}
