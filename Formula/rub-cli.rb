class RubCli < Formula
  desc "Browser automation CLI built for AI agents"
  homepage "https://github.com/QingChang1204/rub"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.6/rub-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f2c2b695831f70d8fdab5c9a810b79ffaf605c2b2054a4bb91a1747ba8fdf416"
    end
    if Hardware::CPU.intel?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.6/rub-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b128af37e145355cfa292fcd345408cb3f179ec517c8fc554ec549a528ab85ae"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/QingChang1204/rub/releases/download/v0.1.6/rub-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f067be3c0c6d8756c1b5590d15dce1a7f9cb5be5ed6274d0b4ced2b72d85c420"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rub" if OS.mac? && Hardware::CPU.arm?
    bin.install "rub" if OS.mac? && Hardware::CPU.intel?
    bin.install "rub" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
