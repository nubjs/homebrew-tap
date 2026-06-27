class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.6/nub-darwin-arm64.tar.gz"
      sha256 "40b9d6999c2126e6c584a333be474db92d5f9a02cc5ec046ecb7807d4cdf37a9"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.6/nub-darwin-x64.tar.gz"
      sha256 "eb887c2b0e74b87705aa673f7ac1b9f77d037e5d312e6518ef2bf0cfb172d80d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.6/nub-linux-arm64.tar.gz"
      sha256 "c8287e018c0aeb95b2da6a46d73a13b2f9c79dedf88758cc415bc0f5f0ef058a"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.6/nub-linux-x64.tar.gz"
      sha256 "e1284ede522855da7845e138ca2e69e02da9db7e36e62bb56e9682e29f3dc219"
    end
  end

  def install
    # nub is a single self-contained binary: it embeds its runtime (preload +
    # vendored polyfills + native addon) and JIT-extracts it to ~/.cache/nub on
    # first run, so there is no sidecar to keep beside the binary. The archive's
    # only top-level entry is bin/ (nub + nubx, both real copies; nub picks its
    # verb from the argv[0] basename), so Homebrew strips that lone directory and
    # stages its contents at the cwd root — the binaries are nub/nubx here, NOT
    # bin/nub. Install them straight onto PATH — no libexec, no symlink dance.
    bin.install "nub", "nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    # Do NOT run a transpile here: `brew test` runs on a clean machine with no Node
    # on PATH, and nub augments the user's Node rather than bundling one.
  end
end
