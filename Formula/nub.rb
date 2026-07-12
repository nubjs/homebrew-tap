class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.10/nub-darwin-arm64.tar.gz"
      sha256 "27403eea0d6bc352043f806c930a9885d786625544ae72c9b9272bb7c0ec1f3f"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.10/nub-darwin-x64.tar.gz"
      sha256 "f01399a3bcfede7f14f6d80e651a711d482347fe5ee4c181a8230995adf50cf3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.10/nub-linux-arm64.tar.gz"
      sha256 "b0b342a5e0729fefd6fa2ebf4aa0a22f895622e43da94eeec876a639d5d15f4b"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.10/nub-linux-x64.tar.gz"
      sha256 "35284c2f0f6b44de14606e170c89048e0fdb03dcd44ea59be1058dd408768379"
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
