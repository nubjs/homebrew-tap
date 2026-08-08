class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.7.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.4/nub-darwin-arm64.tar.gz"
      sha256 "037eda6237ffdf622a505c48ec6e393760e0530c337cd408515085a5d1cc0f2c"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.4/nub-darwin-x64.tar.gz"
      sha256 "727faa9df8e3f2ffb08a313f7c81e16fb2fadc19a2dc0b3f2cf92f1a60a64a13"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.4/nub-linux-arm64.tar.gz"
      sha256 "e269a007a914cc959ccf267cfeb2387da56d02a89706309fa5640ba484d41c73"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.4/nub-linux-x64.tar.gz"
      sha256 "48af00aced24e8b6f74cd8cbf372c4a3a16f75748a0837c7f30f8823570332a4"
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
