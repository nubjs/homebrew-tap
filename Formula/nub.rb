class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.1/nub-darwin-arm64.tar.gz"
      sha256 "f1b75595365755f1bef86ff1ce8f2a5ce9386b5361b496c8f4aed6fefa434397"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.1/nub-darwin-x64.tar.gz"
      sha256 "a016cd1f9cb52447705c403092b62b8fab7f40b48693426b3341cc7585da4a3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.1/nub-linux-arm64.tar.gz"
      sha256 "bd0cc8c85ab9812936c46cc0f43d9d6a7771d758e47939db433cc86bde9da5fc"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.1/nub-linux-x64.tar.gz"
      sha256 "8bdffa526db06e7209f3f9eba89e1e2e40c83b1fbccf5d34b4a4fd65bd29a61f"
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
