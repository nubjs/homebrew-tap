class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.4/nub-darwin-arm64.tar.gz"
      sha256 "c9ed9d1b27a02eacb236965e9324286913b2822f02009e2706c23fa1f6900d69"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.4/nub-darwin-x64.tar.gz"
      sha256 "c3b1130e176ea6eac981b762ce7192f4b5dad49d5c4c344fdab36fdacf0d6784"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.4/nub-linux-arm64.tar.gz"
      sha256 "9f92e1a624140eeaa66bd4d8f39b53b52206cb2cec6fdbe3aaf546c79a472af1"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.4/nub-linux-x64.tar.gz"
      sha256 "3412d588f6c57b15dfe0c2f0981f741a76bd634135948c0c975ed9aa5c14a4da"
    end
  end

  def install
    # nub is a single self-contained binary: it embeds its runtime (preload +
    # vendored polyfills + native addon) and JIT-extracts it to ~/.cache/nub on
    # first run, so there is no sidecar to keep beside the binary. The archive ships
    # bin/nub + bin/nubx (both real copies; nub picks its verb from the argv[0]
    # basename), so install them straight onto PATH — no libexec, no symlink dance.
    bin.install "bin/nub", "bin/nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    # Do NOT run a transpile here: `brew test` runs on a clean machine with no Node
    # on PATH, and nub augments the user's Node rather than bundling one.
  end
end
