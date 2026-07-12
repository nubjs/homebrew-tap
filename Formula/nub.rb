class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.9/nub-darwin-arm64.tar.gz"
      sha256 "c61a50699af7b9962dcf73d0a9d6fcfab5079a09224289a6da69c5adbddc7fa4"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.9/nub-darwin-x64.tar.gz"
      sha256 "150c5b8101a88125a3436de4190267841ad300c4a660bb3240b1ece6ab45ef0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.9/nub-linux-arm64.tar.gz"
      sha256 "1ac008bb3dfd55efe0c203374cd39b1bbd82ae98181cdbaae2892f0b7986e6bc"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.9/nub-linux-x64.tar.gz"
      sha256 "d29c38106ff0635a954650a3d36de9faeed7c8ced997002e59f10c1a3e807df0"
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
