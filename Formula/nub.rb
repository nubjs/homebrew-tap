class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.11/nub-darwin-arm64.tar.gz"
      sha256 "e55e0b6fbd0491e4302d23b2e5ee391691d368ac27bc5455a8bc97de6fe98c67"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.11/nub-darwin-x64.tar.gz"
      sha256 "8fcb5dc711422db543bd2fc896f88aa7316dc1e043e5a81500865d2954d41fce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.11/nub-linux-arm64.tar.gz"
      sha256 "bbda5e95c94ff25e1498fb04d99f10ad0d6e9344309082d011746121c77fcf45"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.11/nub-linux-x64.tar.gz"
      sha256 "083e3f8c2f3fb432c3794b70fbe968218c97c120f697ec62f1cd386899e37576"
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
