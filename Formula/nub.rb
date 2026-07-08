class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.3/nub-darwin-arm64.tar.gz"
      sha256 "416c609ed291ddad148ba150bc2ff3b189b5701193b0b600f4220bb67bbf1bbd"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.3/nub-darwin-x64.tar.gz"
      sha256 "61e8e4959cfd1a47ef30d60e116575b0467aa1a37ad6a6a40d0eb38c37412ce8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.3/nub-linux-arm64.tar.gz"
      sha256 "f416837b41e6f00fe7e28bab4122ea8385579fd6584c10f8dd6a56a40878d949"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.3/nub-linux-x64.tar.gz"
      sha256 "c086619a98c055f9cae764a7e869ccae5c63b07eb0f09f67b37f7d8152968c35"
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
