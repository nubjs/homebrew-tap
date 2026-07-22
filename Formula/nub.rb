class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.5.0/nub-darwin-arm64.tar.gz"
      sha256 "97364ec066d673d01185c9e3f0704531f8adc51806cfb2c5140fabc6b113532d"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.5.0/nub-darwin-x64.tar.gz"
      sha256 "786aeb87d2cbbea10a08f97008dd1c2e77030ecadebc04ccaedc0adb19267c5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.5.0/nub-linux-arm64.tar.gz"
      sha256 "361756af1eca35a8945e4b333c8daae42627d74eb1b8e0de0b1c3fb4cd63acd8"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.5.0/nub-linux-x64.tar.gz"
      sha256 "26218366269476abfea1ad01531bc9edf317339bbc2783e398d23d212e108ebd"
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
