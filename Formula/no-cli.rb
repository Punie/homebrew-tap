class NoCli < Formula
  desc "Say no with some pzazz."
  homepage "https://github.com/Punie/no"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Punie/no/releases/download/0.5.0/no-cli-aarch64-apple-darwin.tar.xz"
      sha256 "664ac88abb03b1f8f528f02fd2a12f2826928c1e98561bf05cfb117d5f3c304e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Punie/no/releases/download/0.5.0/no-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4a109f232fc33db0016b388541a6259615b7f1f7c7a4f99307e8a94f5e9abc27"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Punie/no/releases/download/0.5.0/no-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba67b01f3cd6989653ac624625f3296a68b21e9f63b23efb521333d37bef3624"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Punie/no/releases/download/0.5.0/no-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f1ba309f1ad47fc21ba5a803b077a5f927af2bb94c1f3ad134bdcf7b9c8fdf3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "no" if OS.mac? && Hardware::CPU.arm?
    bin.install "no" if OS.mac? && Hardware::CPU.intel?
    bin.install "no" if OS.linux? && Hardware::CPU.arm?
    bin.install "no" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
