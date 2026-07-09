class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.5/nub-darwin-arm64.tar.gz"
      sha256 "73a80ca1c0492e514b2b305ecc49bf87a5f2a029ac51342549ed075859bbb319"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.5/nub-darwin-x64.tar.gz"
      sha256 "91fcdf248bcfbfac61d9ee58c1a44df069f7f4f55174f249e2f01ce9dc37d953"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.5/nub-linux-arm64.tar.gz"
      sha256 "c30b3418ee711a25e0f3ccae563144e1a3d75588e1265e81017fd88e138447b7"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.5/nub-linux-x64.tar.gz"
      sha256 "d5fd9e211cedfe994867a9c3df97463162b9f4a8b33bf6045c2c716487a8d5cc"
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
