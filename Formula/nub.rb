class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.8.1/nub-darwin-arm64.tar.gz"
      sha256 "74f7d32b3b93d25f4789ce04e8af1001acbfaf9247b53d37ab392ac020886bc0"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.8.1/nub-darwin-x64.tar.gz"
      sha256 "1dc9de5f78e7b2f4c9b1b571a87c9d44976a0b6be27eb44b2c615f77c0255444"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.8.1/nub-linux-arm64.tar.gz"
      sha256 "c1bb3e6b4d8084866e11739a28a8050817ed1ef920f01e941c6db36891bead67"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.8.1/nub-linux-x64.tar.gz"
      sha256 "21e48024cfabfbdaf384c78baef54f6e263ff49ebee9a26cd73ddbaf4729b758"
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
    # The nub compile launcher template resolves as a SIBLING of the running nub
    # (compile::launcher::locate), so it has to land wherever the binary did —
    # libexec would put it out of reach. Accepted cost: brew links the keg's bin
    # into the prefix, so the template becomes a (harmless, namespaced) entry on
    # PATH. Globbed, so this still installs from a pre-template archive: this
    # branch stages it at bin/nub-launcher-<platform> (release.yml), main does not.
    bin.install Dir["bin/nub-launcher-*"]
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
