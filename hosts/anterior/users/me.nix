{ flake, ... }:
{
  imports = with flake.modules.home; [ common ];
}
