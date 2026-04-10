class RubCli < Formula
  desc "Browser automation CLI built for AI agents"
  homepage "https://github.com/QingChang1204/rub"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.4/rub-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ef2c719daf5325c9c0a9a9b8eefdd84bedd77f7d54a10d2266ddefab03e6ea70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.4/rub-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e39ef004cbdb78d6ee1dfb1b4f509c5196f74ae4b9850cc2d6a6cc5c305ee743"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/QingChang1204/rub/releases/download/v0.1.4/rub-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e154c812455e3dc0101670e14c84844aaf6bc47d448ee0cfeb106c3dead88dba"
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
