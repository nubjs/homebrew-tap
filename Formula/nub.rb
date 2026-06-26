class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.3/nub-darwin-arm64.tar.gz"
      sha256 "b550e25cd119db95c9d56fb14cec972956e1d835cea15228c8625cd13cd77f94"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.3/nub-darwin-x64.tar.gz"
      sha256 "6f8fa5b1acc5aa047d1447d1e93d05d46acd4146ca332a2489252db5293b300d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.3/nub-linux-arm64.tar.gz"
      sha256 "9441cc730cb0fdf5acc0762b296f997f2590e0ed1a71ca3ca96a92a34a7a8552"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.3/nub-linux-x64.tar.gz"
      sha256 "40f5148ec41988a23bf6d22ed6673a9c0ab69c084eaedaa241ac36a597f883db"
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
