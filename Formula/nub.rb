class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.0/nub-darwin-arm64.tar.gz"
      sha256 "1fb7886d87ebc7d8f375c9ea14b8e89334cf263baf075d335eccea70bb734b1d"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.0/nub-darwin-x64.tar.gz"
      sha256 "023cdff047aa485e65d79f7d356355ec00c6eb45601a46785988ea024a7e98ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.0/nub-linux-arm64.tar.gz"
      sha256 "9986e38e0608e02d2cef2b2533f125ee3667814a3f7b257f38803095d33cdfcf"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.0/nub-linux-x64.tar.gz"
      sha256 "d6fffced304b37b204206ef6830226a1b0a7444838876fdaf0d81269ea550acc"
    end
  end

  def install
    # The release archive is a tree (bin/nub, bin/nubx, runtime/), not a bare
    # binary: nub loads runtime/ (preload + vendored polyfills + native addon)
    # relative to the real binary, so the whole tree must stay together. Install
    # it into libexec and symlink the executables onto PATH. Plain symlinks (no
    # wrapper script) so each call execs the native binary with zero overhead;
    # nub canonicalizes current_exe() to find runtime/ beside the real binary.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/nub"
    bin.install_symlink libexec/"bin/nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")

    # Prove the runtime tree (preload + vendored polyfills + native addon) was
    # installed alongside the binary — a bare-binary install would be missing it.
    # Do NOT run a transpile here: `brew test` runs on a clean machine with no Node
    # on PATH, and nub augments the user's Node rather than bundling one.
    assert_path_exists libexec/"runtime/preload.mjs"
    assert_path_exists libexec/"runtime/addons/nub-native.node"
  end
end
