{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.homerow;

  homerow = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "Homerow";
    version = "1.4.1";

    src = pkgs.fetchzip {
      extension = "zip";
      name = "Homerow.app";
      url = "https://builds.homerow.app/v${finalAttrs.version}/Homerow.zip";
      hash = "sha256-/Zp62UOvjnj+sN8VTpGC9EZ5cLsjOe/A5ZZkJAx/5Xc=";
    };

    dontConfigure = true;
    dontBuild = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -r *.app "$out/Applications"

      runHook postInstall
    '';
  });
in
{
  options.programs.homerow = {
    enable = lib.mkEnableOption "Lightweight coding agent that runs in your terminal";
  };

  config = lib.mkIf cfg.enable { home.packages = [ homerow ]; };
}
