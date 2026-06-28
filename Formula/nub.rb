class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.9/nub-darwin-arm64.tar.gz"
      sha256 "37efedcb5686603f330cc94175a936eb2676e2abfcde726eb4c4db1a1437c23c"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.9/nub-darwin-x64.tar.gz"
      sha256 "2a7a6f21a33f9511a4a481793e6affaa65425e63a51f84a57f05b16e4d777196"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.9/nub-linux-arm64.tar.gz"
      sha256 "f746d541a2720a8310c700cbd5981388c8c3355acfc5585ab12323b54231a73e"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.9/nub-linux-x64.tar.gz"
      sha256 "8c22a121631f2b7f67ac3f3ebf69a0a0a80b91a6a69326b72bd2e226cb8ea8c8"
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
