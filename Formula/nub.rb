class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.0/nub-darwin-arm64.tar.gz"
      sha256 "b399bdcd95e5bce92ee1c8c4f78aa28c844e25ba091406f701dc8a76f8ccaea5"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.0/nub-darwin-x64.tar.gz"
      sha256 "8afd59ef1a83ecfaa3bd92395bb3f8e796098a501fa02a4eda69c092a57f324c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.0/nub-linux-arm64.tar.gz"
      sha256 "b7bedfb761808c2a1e6858f5004bd6c03d600faf98205b62f4af13d0f5dda7da"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.0/nub-linux-x64.tar.gz"
      sha256 "85e5fcf5486a66e2c4de5d04e665d86b29591882ef6da7e6138d5e79350f59b6"
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
