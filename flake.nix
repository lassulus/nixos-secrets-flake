{
  description = "NixOS vars (nixos-secrets) from nixpkgs PR 547171, usable without patching nixpkgs";

  # nixos/ and pkgs/ are copied from prescientmoon's PR branch
  # (starlitcanopy/nixpkgs da9414f3aae988c17af2854ed6c43e31a2e939ea),
  # keeping the nixpkgs paths.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      backends = ./nixos/modules/security/secrets/example/common;
    in
    {
      nixosModules = {
        default = ./nixos/modules/security/secrets;
        backend-age = backends + "/backend-age.nix";
        backend-plain = backends + "/backend-plain.nix";
      };

      packages = forAllSystems (system: rec {
        nixos-secrets = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/by-name/ni/nixos-secrets/package.nix { };
        default = nixos-secrets;
      });
    };
}
