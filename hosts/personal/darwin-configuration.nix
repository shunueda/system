{ self, inputs, ... }:
let
  user = "me";
  specialArgs = { inherit self inputs; };
in
{
  flake.darwinConfigurations.personal = inputs.nix-darwin.lib.darwinSystem {
    inherit specialArgs;
    modules = [
      self.darwinModules.common
      {
        nixpkgs.hostPlatform = "aarch64-darwin";
        users.users.${user}.home = "/Users/${user}";
        system.primaryUser = user;
        system.stateVersion = 6;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.${user} = {
          imports = [ ./users/me.nix ];
          home.stateVersion = "25.11";
        };
      }
    ];
  };
}
