class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.3.1/nub-darwin-arm64.tar.gz"
      sha256 "bb5f0d282c9ad2c8b443e69d0a72a4e3b9ac6445aee70128cef480582b5c2ff8"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.3.1/nub-darwin-x64.tar.gz"
      sha256 "6f9cd0f1f17d929d2383b39ba97625ff9b22785cc8129192261d55933793eee5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.3.1/nub-linux-arm64.tar.gz"
      sha256 "f4de23dc4f809be115e59fa26b81be8c03dda408aa21d8b6058de11b122b43a4"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.3.1/nub-linux-x64.tar.gz"
      sha256 "af878e63303bd9a79bf3e5d5f491fd17cf64ca458e7f2243ee9f73d58b414238"
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
