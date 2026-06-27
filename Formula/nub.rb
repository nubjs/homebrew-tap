class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.5/nub-darwin-arm64.tar.gz"
      sha256 "d3553a2b8038069d5deacc31b5edf5b9d18587cf6dc42d31c2c038d2bb60c853"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.5/nub-darwin-x64.tar.gz"
      sha256 "0f79b97816905f048876ea3361ec1b480b2b29cc6ae4ad2fd24fdf13ee2373a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.5/nub-linux-arm64.tar.gz"
      sha256 "914808f5b1501d15ad2cfd082425842cc5fd6503661e756337d70b35a8b0f76f"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.5/nub-linux-x64.tar.gz"
      sha256 "15a02b58b814ac31a5a56bcd825428d9c347922fa17df03cebe8fac1517d2e31"
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
