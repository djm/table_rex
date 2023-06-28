# TableRex's dev environment
# ==========================
#
# We base our developer environment on Nix, the functional package
# manager and its sister package nix-shell which allows for per-
# directory "virtual environments".
#
# We use `nix-shell` alongside `direnv`, so that the environment
# gets loaded as soon as you enter the directory with your shell.
#
# We choose to use the rolling Nix Channel named `nixpgks-unstable`,
# as we stay fairly up-to-date with new versions of Elixir.
# Read more about Channels here: https://nixos.wiki/wiki/Nix_channels
#
#
# Re-pinning
# ----------
#
# Re-pinning is the act of updating which version of a specific
# channel (tree of packages) we are relying on at a given moment
# in time. If you require a new Elixir/Erlang version, re-pinning
# is what you want. The process is:
#
# 1. Visit https://status.nixos.org/
# 2. Check the `nixpkgs-unstable`, check its green.
# 3. Update the `fetchTarball` URL below with new commit.

# TODO: Convert to a Nix Flake!

{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/a565059a348422af5af9026b5174dc5c0dcefdae.tar.gz") {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, frameworks ? pkgs.darwin.apple_sdk.frameworks
}:

pkgs.mkShell {

  nativeBuildInputs = [

    # Dev-env tooling
    pkgs.go-task
    pkgs.pre-commit

    # Elixir/BEAM deps
    pkgs.elixir_1_15

    # for many deps
    pkgs.pkg-config

  ] ++ lib.optional stdenv.isDarwin [
    pkgs.xcodebuild
    frameworks.CoreServices
  ];

shellHook = ''
    set -e

    echo ""
    echo "      github.com/djm/table_rex"
    echo ""
    echo "      `elixir --version | grep -Po 'Elixir\s[\d\.]+' --color=never`"
    echo ""

  '';

}
