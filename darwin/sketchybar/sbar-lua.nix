{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbar-lua";
  version = "2024-08-12";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "437bd2031da38ccda75827cb7548e7baa4aa9978";
    hash = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
  };

  dontConfigure = true;

  postPatch = ''
    substituteInPlace makefile \
      --replace 'clang $(CFLAGS)' '$(CC) $(CFLAGS)'
    substituteInPlace lua-5.4.7/src/Makefile \
      --replace 'CC= gcc -std=gnu99 -arch arm64' 'CC= ${stdenv.cc}/bin/cc -std=gnu99 -arch arm64' \
      --replace 'CC= gcc -std=gnu99 -arch x86_64' 'CC= ${stdenv.cc}/bin/cc -std=gnu99 -arch x86_64'
  '';

  buildPhase = ''
    runHook preBuild
    mkdir -p bin
    pushd lua-5.4.7/src
      CC=${stdenv.cc}/bin/cc make liblua.a
    popd
    cp lua-5.4.7/src/liblua.a bin/liblua.a
    touch bin/liblua.a
    CC=${stdenv.cc}/bin/cc make bin/sketchybar.so
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/sketchybar.so $out/lib/sketchybar/sketchybar.so
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lua bindings for SketchyBar";
    homepage = "https://github.com/FelixKratz/SbarLua";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin;
  };
})
