class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.13/nub-darwin-arm64.tar.gz"
      sha256 "18d9aae6ac1c1881c0ee3366feda83152ebcd73f1618c73f72b7469a42f8b2f5"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.13/nub-darwin-x64.tar.gz"
      sha256 "55e9f5c9141a62983c9264c89f44ff48f6e3e34db221539f2b5822c76081f13f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.13/nub-linux-arm64.tar.gz"
      sha256 "b834d5deb7ba0659201d4ce5701805ee190eb70c8a55261591557fe748a81c5d"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.13/nub-linux-x64.tar.gz"
      sha256 "4ce52b4e2b3ffc58d273f3cbc4a4bf2149e78c4b1b130eac69fc58dbca4591f3"
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
