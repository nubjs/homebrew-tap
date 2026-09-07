class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.9.0/nub-darwin-arm64.tar.gz"
      sha256 "082e4d30d358b1976b219409e08f3d84503ad609e23472423d30660c7efb6d3c"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.9.0/nub-darwin-x64.tar.gz"
      sha256 "8c59534d3e3ca27979b9b445fdada10bb418aac4db4a18b034ceb1dc2d0fcb0a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.9.0/nub-linux-arm64.tar.gz"
      sha256 "4af5924461ffab21e916ea201dc6fe9c03ef752ef624976f6f013092e8a049ce"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.9.0/nub-linux-x64.tar.gz"
      sha256 "1b053e3270de7b9a3c0fa57f176312d325adc5bd57fba8fe866956ebd52e5ec0"
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
