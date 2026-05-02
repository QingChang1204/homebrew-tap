class RubCli < Formula
  desc "Browser automation CLI built for AI agents"
  homepage "https://github.com/QingChang1204/rub"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.9/rub-cli-aarch64-apple-darwin.tar.xz"
      sha256 "65259ef94339d36b3b4295060576b3c951495254c8a2e26337918472ce728a52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/QingChang1204/rub/releases/download/v0.1.9/rub-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5d557d90124f65b85fa518fc8130a9014148557dee4b507611aac654a2086a3f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/QingChang1204/rub/releases/download/v0.1.9/rub-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6eb472c648edb34df072a11e7657c76fde850d6035a924d8e4eb5ff752809f66"
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
