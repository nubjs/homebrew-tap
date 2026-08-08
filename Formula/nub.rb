class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.7.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.3/nub-darwin-arm64.tar.gz"
      sha256 "c2cb836e91a2aa5652291f0cca3a4dc21dab9ab91b8f87098e134a3eec4f7f5f"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.3/nub-darwin-x64.tar.gz"
      sha256 "f20a1e7d6ba36e83d705c25a9c8a6c62d8e50af2505f53928278169d32fa036b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.3/nub-linux-arm64.tar.gz"
      sha256 "5cbc0ffa2a0da9aa838068b7fd8b86166cfffb6db797d9fa0bfee84e5e27d2fa"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.3/nub-linux-x64.tar.gz"
      sha256 "208236503aeeed6668bde94184d58c4714ff739f8a569e1ccc808bee7d3250f5"
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
