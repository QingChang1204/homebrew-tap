class RubCli < Formula
  desc "Browser automation CLI built for AI agents"
  homepage "https://github.com/QingChang1204/rub"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.3/rub-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d0980a0be2f76ebfe18b249c8e051f5bab88f4e1e8b3031102053903dd93aca6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.3/rub-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2cc44c3bd43b016e9d174991514abcbcc8051e8d43f8eb403d51343f9c68d495"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/QingChang1204/rub/releases/download/v0.1.3/rub-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f63757d4a65b1d379e449561efcd1d25ecbeff19bb219b364a83526550f3aa09"
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
