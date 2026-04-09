{ stdenvNoCC, fetchzip }:

# https://github.com/NixOS/nixpkgs/pull/470905
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "homerow";
  version = "1.5.3";

  src = fetchzip {
    url = "https://builds.homerow.app/v${finalAttrs.version}/Homerow.zip";
    hash = "sha256-zqa1QYq7UF80z0cvMZJMgTQFo3vqGdwzuLVMwgyuMME=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R *.app "$out/Applications"

    runHook postInstall
  '';
})
