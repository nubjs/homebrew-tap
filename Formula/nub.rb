class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.3.0/nub-darwin-arm64.tar.gz"
      sha256 "e4040b99156a98f1a0193c46ba0ec10964873842d1d08cdca38a60ffd3916705"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.3.0/nub-darwin-x64.tar.gz"
      sha256 "0940e3b753c97d5c4d3cc8ed2af2f7f8883f69e86a2e29b3ae79625c40e7ae2f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.3.0/nub-linux-arm64.tar.gz"
      sha256 "54f8fdc567378b6842e7c88620741804d3fd9b60d71ffd830c71c7bf7ef2f1e4"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.3.0/nub-linux-x64.tar.gz"
      sha256 "6ac5d417f9b2c5406de8e106e0bf73f177f3afc0f3bd04446bc69a8d9272f38a"
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
