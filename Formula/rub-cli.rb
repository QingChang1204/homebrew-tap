class RubCli < Formula
  desc "Browser automation CLI built for AI agents"
  homepage "https://github.com/QingChang1204/rub"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.0/rub-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b344af7d0f79429075efcc0a80adb2d070a9b94b8ca975052435c1c227f08cab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.0/rub-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6b4d03386ebe9f62904e5d81a689f454f03d3f95d40a6819d9abb80c801eb49b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/QingChang1204/rub/releases/download/v0.1.0/rub-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "32557e856f382fd34cb99a88a601d2cae69e6bfc4f629074b0099f5a3d9e7a1f"
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
