FROM nixos/nix

RUN nix-channel --update

RUN nix-env -iA \
    nixpkgs.just \
    nixpkgs.git \
    nixpkgs.util-linux

WORKDIR /nocturne-image
