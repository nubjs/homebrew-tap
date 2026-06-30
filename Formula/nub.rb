class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.2.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.10/nub-darwin-arm64.tar.gz"
      sha256 "f1d6112d44444ad2397198d810bd18922b2077f06f2e23a944c18500118a19bc"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.10/nub-darwin-x64.tar.gz"
      sha256 "064eac6340e8da93746a8f7e367eafc9f27d3925def6d186d2fe57206e8ca7eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.2.10/nub-linux-arm64.tar.gz"
      sha256 "bd482def32a796625eba8868baf4bf20ec7d503ce8c7ddfacda074b239608e61"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.2.10/nub-linux-x64.tar.gz"
      sha256 "05fd31582904c590aca4bd46f6ebe8d086cd8269b1d7b7e8b11ee959cdace121"
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
