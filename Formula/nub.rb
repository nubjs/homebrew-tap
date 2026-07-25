class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.6.0/nub-darwin-arm64.tar.gz"
      sha256 "f5abffa7bfe1b6a9b4fecf66d4f97d19b1491df35a7b05b6da5c2cfc495b255c"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.6.0/nub-darwin-x64.tar.gz"
      sha256 "4ee5d6b0db4783885c2d0451e1b1fcd198b457442361444ea5ef166ab5dad50b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.6.0/nub-linux-arm64.tar.gz"
      sha256 "8ab023e14a030a151b3e24e3bef360dcc3b230ea36b657d111919e73a51c28ff"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.6.0/nub-linux-x64.tar.gz"
      sha256 "9da96cc4600abb7995b5e06e8f74c3c89c295a70d9b62747d08b21b0d5de4c5d"
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
