# https://github.com/NixOS/nixpkgs/pull/470905
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.pass-cli;

  pass-cli = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "pass-cli";
    version = "1.4.1";

    src = pkgs.fetchurl {
      src = "https://proton.me/download/pass-cli/1.3.2/pass-cli-macos-aarch64";
      hash = "";
    };

    installPhase = ''
      install -Dm755 $src $out/bin/pass-cli
    '';

  });
in
{
  options.programs.pass-cli = {
    enable = lib.mkEnableOption "Keyboard shortcuts for every button in macOS";
  };

  config = lib.mkIf cfg.enable { home.packages = [ pass-cli ]; };
}
