{ system ? builtins.currentSystem }:

with (import ./nix {}).pkgs { inherit system; }; mkShell {
  buildInputs = [
    bashInteractive
    cacert
    mavenix
    niv
    jdk
  ];
}
