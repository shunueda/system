{
  perSystem =
    { pkgs, ... }:
    {
      packages.majutsu = pkgs.emacsPackages.melpaBuild {
        pname = "majutsu";
        version = "0-unstable-2026-03-04";

        src = pkgs.fetchFromGitHub {
          owner = "0WD0";
          repo = "majutsu";
          rev = "bb56ca9223df4a54582852b79421d9cccfc0d78e";
          hash = "sha256-GJ1HuacEvir269dE+9V4J/r4mLasQ3eB9yokqx0UJEI=";
        };

        buildInputs = with pkgs.emacsPackages; [ magit ];

        meta = {
          description = "Majutsu! Magit for jujutsu";
          license = pkgs.lib.licenses.agpl3Only;
        };
      };
    };
}
