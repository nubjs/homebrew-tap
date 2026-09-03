class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.8.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.8.3/nub-darwin-arm64.tar.gz"
      sha256 "9d27ebec48e3d90e86ea35c088ddaf2f87b8b466e047722cb9c96e333e5a5252"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.8.3/nub-darwin-x64.tar.gz"
      sha256 "e92b589d7c39e954a83697f68b5a677cfd4e7f664112163c73d081369019d430"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.8.3/nub-linux-arm64.tar.gz"
      sha256 "060a31aeab3024f6db54fee74db2a1552759a8fee98e1b3dd6924977f9732bca"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.8.3/nub-linux-x64.tar.gz"
      sha256 "249b064916db290c53de5bc1721a1dd78cf82e0f951f320782598b477cad7af9"
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
