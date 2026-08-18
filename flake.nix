{
  description = "Personal website built with Hugo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nur-packages = {
      url = "github:mikidep/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: let
        bibman = inputs.nur-packages.packages.${pkgs.stdenv.hostPlatform.system}.bibman;
        bibmanGen = let
          source = ./assets/bib/publications.bib;
        in
          pkgs.writeShellApplication {
            name = "bibman-gen";
            runtimeInputs = [bibman pkgs.jq];
            text = ''
              bibman export --from biblatex --to csljson - < ${source} \
                | jq 'map({
                  date: (.issued."date-parts" | flatten | mktime ),
                  DOI, URL, author, venue: ."container-title", title
                })'
            '';
          };
      in {
        packages = rec {
          website = pkgs.stdenvNoCC.mkDerivation {
            pname = "personal-website";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [pkgs.hugo bibmanGen];
            buildPhase = ''
              export HUGO_PUBLICATIONS_JSON="$(bibman-gen)"
              hugo --minify --destination "$out"
            '';
            dontInstall = true;
          };

          default = website;
        };

        devShells.default = pkgs.mkShell {
          packages = [pkgs.hugo bibmanGen];
          shellHook = ''
            export HUGO_PUBLICATIONS_JSON="$(bibman-gen)"
          '';
        };
      };
    };
}
