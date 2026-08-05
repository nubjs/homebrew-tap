class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.1/nub-darwin-arm64.tar.gz"
      sha256 "e5d78c22a9f9b0c09d383317c233c28c61b61bcae29cf34e4cd19885447321d6"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.1/nub-darwin-x64.tar.gz"
      sha256 "87206819541f2eee108d4242d34fa3eb0931291ad38584f39fc0bc4000d89521"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.1/nub-linux-arm64.tar.gz"
      sha256 "301f3387938d0b064552662f8dcd87ee10e6355303a78ff4a261726028de6fe3"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.1/nub-linux-x64.tar.gz"
      sha256 "7093a01c6cdc2110466cd468dc8d639507368513572f116d2e3b53a118d3c552"
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
