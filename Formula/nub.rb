class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.0/nub-darwin-arm64.tar.gz"
      sha256 "d79b9270fa02c1d3f02d9a6bc533a0c1f72581e312946a0cfc9d60108b10c51a"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.0/nub-darwin-x64.tar.gz"
      sha256 "d0e7db69370717a68d446f22fd6753a7d8af3de37d4e1808ac44390e9146b8b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.7.0/nub-linux-arm64.tar.gz"
      sha256 "5ee4726bc9df7ab20a150ccb2d9efcfcb5c887211c9a9b299842da7d782b8df2"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.7.0/nub-linux-x64.tar.gz"
      sha256 "ee638dc0cddd1a28a4f223ac41879ebf109c6d95b54b0fd221d327b8392409c0"
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
