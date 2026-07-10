class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.6/nub-darwin-arm64.tar.gz"
      sha256 "2e9dd7fb00f8be2a856ef760a70764498109de2d20b6a6acc008968705ac511a"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.6/nub-darwin-x64.tar.gz"
      sha256 "5282ceed66b31618f187c882cff3b7b63d020b4aec72501f284c88b734896f8f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.6/nub-linux-arm64.tar.gz"
      sha256 "b6f7157de41bdb193447a1247ef0049ea5ad5f60cb685667e10b31cfc122f1bb"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.6/nub-linux-x64.tar.gz"
      sha256 "ebb86034d879df50fa13439f166d9b75165949846d61c9e1c6962dc3992ee99c"
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
