class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.7.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.2/nub-darwin-arm64.tar.gz"
      sha256 "3d5f3b4005f56cbf78337bb0e7708817b5c98de0e2528897f628996084150837"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.2/nub-darwin-x64.tar.gz"
      sha256 "7d80793e4b6125cbdd3a0a1adedf25ca842862581af97f13aa78364560265bc2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.2/nub-linux-arm64.tar.gz"
      sha256 "e15297db0fcc2db93b701aea755e59a1780f3e77a2ca2e8eee6a3a6e255d3058"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.2/nub-linux-x64.tar.gz"
      sha256 "4be7915a47079422ceb38d79f43a6f9018e59eab0895736ad8e42d1c04a5f15c"
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
