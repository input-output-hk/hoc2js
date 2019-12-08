{ sources ? import ./sources.nix }:

rec {
  overlays = [
    (pkgs: _: {
      mavenix = let
        this = import sources.mavenix { inherit pkgs; };
      in this.cli.overrideAttrs (_: {
        passthru = this;
      });

      niv = let
        this = import sources.niv { inherit pkgs; };
      in this.niv.overrideAttrs (_: {
        passthru = { inherit sources; };
      });

      inherit (import sources.gitignore { inherit (pkgs) lib; }) gitignoreSource;
    })
  ];

  pkgs =
    { nixpkgs ? sources.nixpkgs
    , system  ? builtins.currentSystem }: import nixpkgs {

    inherit system overlays;
  };
}
