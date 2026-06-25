class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.1/nub-darwin-arm64.tar.gz"
      sha256 "ab62a204c636dba0d9e4767effeef7359137b1cdbc1080a187fd7a57854fa309"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.1/nub-darwin-x64.tar.gz"
      sha256 "6760cf54cfbe5d85740a8e82e95faaab0abbd131c3c6344c6fb86e726408bc43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.1/nub-linux-arm64.tar.gz"
      sha256 "c8af43d9b224b2973070b5cc1202b767ad7bd2e3a24e0982f69dbadd338ca606"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.1/nub-linux-x64.tar.gz"
      sha256 "66df508523feaa89314c84a8c87c52928bb9cc22cf9d8de1d28c1ca935821132"
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
