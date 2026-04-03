{ }:
let
  pins = import ./npins;
  pkgs = import pins.nixpkgs { };
  nixivim = import ./default.nix;

in
pkgs.mkShellNoCC {

  packages = [
    nixivim.packages.${pkgs.stdenv.hostPlatform.system}.testvim
  ];

}
