{
  melpaBuild,
  lib,
  magit,
  inputs,
  ...
}:

melpaBuild {
  pname = "majutsu";
  # This date is not updated properly because im too lazy
  version = "0-unstable-2026-04-21";

  src = inputs.majutsu;

  buildInputs = [ magit ];

  meta = {
    description = "Majutsu! Magit for jujutsu";
    license = lib.licenses.agpl3Only;
  };
}
