class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.8/nub-darwin-arm64.tar.gz"
      sha256 "5ade565affaffe60d19f10114c1c7e388e36b12117edcc0a779165f711722c68"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.8/nub-darwin-x64.tar.gz"
      sha256 "95b2dcec1816c76a3d90dc571349ae9d8269b3cd0ad3acc3d7cde2afce1ad173"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.8/nub-linux-arm64.tar.gz"
      sha256 "f95f62e43a091e59246f90bbddf7ec640573fc8ba6f798ee59bc0e905cbcc2ee"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.8/nub-linux-x64.tar.gz"
      sha256 "fd4e183bf99183decb08387d405b8d4b2d35305adadf93f62284ad5f5f4de330"
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
