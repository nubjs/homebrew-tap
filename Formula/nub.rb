class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.7/nub-darwin-arm64.tar.gz"
      sha256 "882125e546fe54c9a4b79084e8509717d33aedd9129f40439b2a0ca964701045"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.7/nub-darwin-x64.tar.gz"
      sha256 "7b44af381e505b8184687c1bd1c34ab3afed10f6236684b9832acb354f13a431"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.7/nub-linux-arm64.tar.gz"
      sha256 "866e95f460afd518aa82c2aa79accd9b40a47eeb0ea3d03a472a4bd8e3fffbdc"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.7/nub-linux-x64.tar.gz"
      sha256 "9f84151c9b1bdd09e0a1d5a323c4d51a73cc5b2143c9492a7eb823264ed60359"
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
