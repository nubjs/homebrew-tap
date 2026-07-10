class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.7/nub-darwin-arm64.tar.gz"
      sha256 "5196cdd3faa1b6f6307fa3ca92729b3cdb9b8051b7a8088e048c690e995d6f9f"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.7/nub-darwin-x64.tar.gz"
      sha256 "3add8c6c05ad2fb60d5dafa2f41036e050fa67c0a1755751a78c7dfa605f8c95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.7/nub-linux-arm64.tar.gz"
      sha256 "6d6482ce2d5f827de4eeafa6454e3f637a40eff87b4c50abfa51a9cfbb6e6fe3"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.7/nub-linux-x64.tar.gz"
      sha256 "390575ebf588076ccd88425124d9358c5ab80132a991540147d48cd3ccfbb609"
    end
  end

  def install
    # nub is a single self-contained binary: it embeds its runtime (preload +
    # vendored polyfills + native addon) and JIT-extracts it to ~/.cache/nub on
    # first run, so there is no sidecar to keep beside the binary. The archive ships
    # bin/ (nub + nubx, both real copies; nub picks its verb from the argv[0]
    # basename) PLUS a vestigial empty runtime/ that exists only to satisfy the
    # sidecar-era  (see release.yml). Two top-level entries means
    # Homebrew does NOT flatten a lone directory, so reference the binaries by their
    # bin/ path explicitly — install them straight onto PATH, no libexec, no symlink
    # dance, and ignore runtime/.
    bin.install "bin/nub", "bin/nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    # Do NOT run a transpile here: `brew test` runs on a clean machine with no Node
    # on PATH, and nub augments the user's Node rather than bundling one.
  end
end
