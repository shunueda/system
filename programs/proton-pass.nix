# https://github.com/NixOS/nixpkgs/pull/472021
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.proton-pass;

  proton-pass = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "proton-pass";
    version = "1.33.0";

    meta = {
      description = "Desktop application for Proton Pass";
      homepage = "https://proton.me/pass";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      mainProgram = "proton-pass";
    };

    src = pkgs.fetchurl {
      url = "https://proton.me/download/PassDesktop/darwin/universal/ProtonPass_${finalAttrs.version}.dmg";
      hash = "sha256-zYQ7CV4tzpxkjO11oFzWTRy0CD4CDIVN6SL9VlhCUHQ=";
    };

    nativeBuildInputs = [ pkgs.undmg ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  });
in
{
  options.programs.proton-pass = {
    enable = lib.mkEnableOption "Proton Pass";
  };

  config = lib.mkIf cfg.enable { home.packages = [ proton-pass ]; };
}
