class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.7.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.5/nub-darwin-arm64.tar.gz"
      sha256 "dd5a6a9bf30d96e36fe5ba7df870156db7089b3b5bbf73734c881ecc86ed693f"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.5/nub-darwin-x64.tar.gz"
      sha256 "45396491a922e9a6ff75ab6add500bf597b2be51b80acbaeaa055a7a9d845748"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.5/nub-linux-arm64.tar.gz"
      sha256 "de28e3df5a84fb410640d7ab820e172401d85d63ba44d4b6f6454bf9c27380d3"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.5/nub-linux-x64.tar.gz"
      sha256 "34ad027792b7702e88f71eadde9fc2bf4ebade13a1c91b92fa056954f15880eb"
    end
  end

  def install
    # nub is a single self-contained binary: it embeds its runtime (preload +
    # vendored polyfills + native addon) and JIT-extracts it to ~/.cache/nub on
    # first run, so there is no sidecar to keep beside the binary. The archive ships
    # bin/ (one real binary, bin/nub) PLUS a vestigial empty runtime/ that exists
    # only to satisfy the sidecar-era `nub upgrade` (see release.yml). Two top-level
    # entries means Homebrew does NOT flatten a lone directory, so reference the
    # binary by its bin/ path explicitly — install it straight onto PATH, no libexec,
    # and ignore runtime/.
    bin.install "bin/nub"
    # `nubx` is the same binary under a second name: nub reads its verb from the
    # argv[0] basename (Argv0::detect in crates/nub-cli/src/cli.rs). Only one copy
    # ships, so the alias is created here — install.sh, install.ps1 and flake.nix
    # each do the same for their own channel.
    bin.install_symlink bin/"nub" => "nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    # The alias must EXIST and DISPATCH. `nubx --help` prints the exec grammar,
    # which plain `nub` never does — so this fails both if bin/nubx is missing and
    # if it somehow resolves back to the top-level CLI.
    assert_match "Usage: nub nubx", shell_output("#{bin}/nubx --help")
    # Do NOT run a transpile here: `brew test` runs on a clean machine with no Node
    # on PATH, and nub augments the user's Node rather than bundling one.
  end
end
