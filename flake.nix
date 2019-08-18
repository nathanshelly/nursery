{
  description = ".files";

  inputs = {
    nix-darwin.url = "github:lnl7/nix-darwin/master";
  };

  outputs = { self, nix-darwin }: {
    darwinConfigurations.default = nix-darwin.lib.darwinSystem {
      modules = [ ./darwin.nix ];
    };
  };
}
