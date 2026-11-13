class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.11.0/nub-darwin-arm64.tar.gz"
      sha256 "6c6e7f970a0e692ae9e05bda4b235866b8a3315d19ab397e72d465eaeab80776"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.11.0/nub-darwin-x64.tar.gz"
      sha256 "c3184ea61c9f6291e1c45149e174df0965c980bc9ccd2218eba7532735c3fc58"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.11.0/nub-linux-arm64.tar.gz"
      sha256 "5a00bd44b016ec16c52bb8eb32cbceeadd55ab7ad49bb142c94b6b302255f2af"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.11.0/nub-linux-x64.tar.gz"
      sha256 "40d72603442885efc06d26ae0a5dbc114e2c8f7101d4dd332730d5ec14dc0c89"
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
    # argv[0] basename (Argv0::detect in crates/nub-cli/src/cli.rs). The archive
    # carries bin/nubx as a symlink, but `bin.install "bin/nub"` above takes the
    # one file, so the alias is created here — flake.nix does the same for its
    # channel.
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
