class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.9.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.9.3/nub-darwin-arm64.tar.gz"
      sha256 "a21477648c12168404fe177d69011eebde973d14d7b9714026d6d0e5776efce9"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.9.3/nub-darwin-x64.tar.gz"
      sha256 "b866b2eeef447bf174d597e9425e757aa051d4d9460169eef004a30372b30d34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.9.3/nub-linux-arm64.tar.gz"
      sha256 "244355d322eeb332be938634148b81019a9b838d0bb889c668351f5b55b2908a"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.9.3/nub-linux-x64.tar.gz"
      sha256 "f085a11ed0fa18050d3dad31e676ba3e2f69d6b4a4a35a17cd88077485802cf0"
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
    # `nubr` is the third name: the unified runner (a file, a package.json
    # script, or an installed bin), the command `@nubjs/runner` ships, run out of
    # the embedded runtime. Same argv[0] dispatch, same one copy.
    bin.install_symlink bin/"nub" => "nubr"
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
    # Same for `nubr`: its `--version` is the bare version, where `nub` prints
    # `v<version>`, so exact equality proves the alias dispatched. `--version` is
    # answered by the binary itself and never reaches Node, which matters below.
    assert_equal version.to_s, shell_output("#{bin}/nubr --version").strip
    # Do NOT run a transpile here: `brew test` runs on a clean machine with no Node
    # on PATH, and nub augments the user's Node rather than bundling one.
  end
end
