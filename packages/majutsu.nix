{
  fetchFromGitHub,
  melpaBuild,
  lib,
  magit,
  ...
}:

melpaBuild {
  pname = "majutsu";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "0WD0";
    repo = "majutsu";
    rev = "6951db97ec039f16b063bdcb05bbc2b4c4aae18c";
    hash = "sha256-uf6A0d4ngqYlT/gUXmCgmpGEChuDQNO6qM6KonzULSw=";
  };

  buildInputs = [ magit ];

  meta = {
    description = "Majutsu! Magit for jujutsu";
    license = lib.licenses.agpl3Only;
  };
}
