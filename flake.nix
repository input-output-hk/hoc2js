{
  description = "Convert HOCON to JSON";

  edition = 201909;

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "x86_64-darwin" ];

    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

    # Memoize nixpkgs for different platforms for efficiency.
    nixpkgsFor = forAllSystems (system:
    import nixpkgs {
      inherit system;
      inherit (self) overlays;
    });

  in {
    packages = forAllSystems (system: {
      hoc2js = import ./. { inherit system; };
    });

    devShell = forAllSystems (system: import ./shell.nix { inherit system; });

    defaultPackage = forAllSystems (system: self.packages.${system}.hoc2js);
  };
}
