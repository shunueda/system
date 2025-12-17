{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.homerow;

  # https://github.com/NixOS/nixpkgs/pull/470905
  homerow = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "homerow";
    version = "1.4.1";
    src = pkgs.fetchzip {
      url = "https://builds.homerow.app/v${finalAttrs.version}/Homerow.zip";
      hash = "sha256-tvFZE8lOdyJ+D5T/93c3tiZzA6TbFGWtOghEyoCFYuc=";
      stripRoot = false;
    };

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R *.app "$out/Applications"

      runHook postInstall
    '';
  });
in
{
  options.programs.homerow = {
    enable = lib.mkEnableOption "Keyboard shortcuts for every button in macOS";
  };

  config = lib.mkIf cfg.enable { home.packages = [ homerow ]; };
}
