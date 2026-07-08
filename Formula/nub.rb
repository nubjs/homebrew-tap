class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.4/nub-darwin-arm64.tar.gz"
      sha256 "579f5dc76eff500ef425bfc21fc6e1f8912c682ea59e0843a27fde3d2214ad71"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.4/nub-darwin-x64.tar.gz"
      sha256 "81053f60676e91284775a99127a07f5ee1bea98724eead47b62edecae969be84"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.4/nub-linux-arm64.tar.gz"
      sha256 "2a963a8510f5270125d6957c66f23f64212a585893a3d0dd7dd49acf652e7066"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.4/nub-linux-x64.tar.gz"
      sha256 "b9cbea1ba6d137deb117209d060d1dfa2ca670d8699c20989957e085d09a852b"
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
