class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.4.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.8/nub-darwin-arm64.tar.gz"
      sha256 "dfa1f3e19f3db8cde4d68266bf381e122f09bd5dc7da96d38eadc98d7a72bd41"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.8/nub-darwin-x64.tar.gz"
      sha256 "c4d603a9a20bb9555e055b35a3af01a01e95dead8a1f4e3beea7a6c185b82531"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.4.8/nub-linux-arm64.tar.gz"
      sha256 "93241d436019fe16e1671ab6c780321f210c790d60c47e3d3e3cbe418a9a47bf"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.4.8/nub-linux-x64.tar.gz"
      sha256 "34a84ccd10eb472e01e4f10997b926820d15e105f4ae5110aa1cea19a6d9a091"
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
