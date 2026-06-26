class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.2/nub-darwin-arm64.tar.gz"
      sha256 "1c561d820145e9eb7640f6f97c0fe2f2d8b8d4a4d64b19f78fccf8f9dd79ac46"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.2/nub-darwin-x64.tar.gz"
      sha256 "39c0f5200be3688e776c51ee2978e3cfe50fdb50946261a52ca42f6481145d75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.2/nub-linux-arm64.tar.gz"
      sha256 "b9a292a725a959809fd629e7b3d8d6d886480300b8451bb41f8fb4a5098107ec"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.2/nub-linux-x64.tar.gz"
      sha256 "6cc63a89f25f12719bce9afc97e513cc8ee22ef203e4a72a3c7398e62b413a23"
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
