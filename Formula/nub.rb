class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://github.com/nubjs/nub"
  version "0.1.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.1.14/nub-darwin-arm64.tar.gz"
      sha256 "cdaa6250bbdb85100334a95543fdb50dd2bd09b87dbf7b00d611041e76133a4c"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.1.14/nub-darwin-x64.tar.gz"
      sha256 "368491d4e6654666dee270071aff356be1e90ab82fa5621fea737f21176da66c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nubjs/nub/releases/download/v0.1.14/nub-linux-arm64.tar.gz"
      sha256 "0fb7b60291d24e7078f20874bd970457c4069ee8687e1e1898b4b651fb3920e1"
    end
    on_intel do
      url "https://github.com/nubjs/nub/releases/download/v0.1.14/nub-linux-x64.tar.gz"
      sha256 "f6ae9c6f73b47b836f365a54899493a4a50bc1211baebc07791a886d8780c997"
    end
  end

  def install
    # The release archive is a tree (bin/nub, bin/nubx, runtime/), not a bare
    # binary: nub loads runtime/ (preload + vendored polyfills + native addon)
    # relative to the real binary, so the whole tree must stay together. Install
    # it into libexec and symlink the executables onto PATH. Plain symlinks (no
    # wrapper script) so each call execs the native binary with zero overhead;
    # nub canonicalizes current_exe() to find runtime/ beside the real binary.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/nub"
    bin.install_symlink libexec/"bin/nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")

    # Prove runtime/ was installed correctly: a bare-binary install passes
    # --version but cannot transpile TS (it needs runtime/preload).
    (testpath/"hello.ts").write("const x: string = \"hi nub\";\nconsole.log(x);\n")
    assert_equal "hi nub", shell_output("#{bin}/nub #{testpath}/hello.ts").strip
  end
end
