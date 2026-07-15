class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.12/nub-darwin-arm64.tar.gz"
      sha256 "63bf148400ae7bdbf020a1cc31aa6538ac550fa3a891b6e09e2f3410aedb1c09"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.12/nub-darwin-x64.tar.gz"
      sha256 "e169e94bed9aeb0d3da9b1f61f2643dce39179e80493f64c751dff8b868d32b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.12/nub-linux-arm64.tar.gz"
      sha256 "1d1937be02cce28d7d53782893e5386e2bd4a4317bcf9278dcf9eed5a558f28c"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.12/nub-linux-x64.tar.gz"
      sha256 "e770764a0106c97316565e64f6d8825064330657c159bfa9d9d8d39bb230a893"
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
