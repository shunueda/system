{
  fetchFromGitHub,
  melpaBuild,
  lib,
  magit,
  ...
}:

melpaBuild {
  pname = "majutsu";
  version = "0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "0WD0";
    repo = "majutsu";
    rev = "bb9cd25cb97e5b8948d0e91f8746a81acc8ed1d1";
    hash = "sha256-4H2P9NnQne5P14+VrH27VIw4I2340o+8F6AiCofY8i4=";
  };

  buildInputs = [ magit ];

  meta = {
    description = "Majutsu! Magit for jujutsu";
    license = lib.licenses.agpl3Only;
  };
}
