class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.2/nub-darwin-arm64.tar.gz"
      sha256 "507a39d5f856943aae74d49ea55d58411e2fab8c6a416b8bbb08a81ce0588e76"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.2/nub-darwin-x64.tar.gz"
      sha256 "03b02f9be2394688a1d4ef756db7ad924e6d6cfb24a84fd1ac4b2289e1145baa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.2/nub-linux-arm64.tar.gz"
      sha256 "6d41d771bf17ee9e51570af5b294fec9b76fabd1ea0026f5684aa44de490a390"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.2/nub-linux-x64.tar.gz"
      sha256 "1021d6681e87fbd3bb91dba38e1277daf13898b09b6fd57977c13a3df644eef6"
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
