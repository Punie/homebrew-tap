class No < Formula
  desc "Say no with some pzazz."
  homepage "https://github.com/Punie/no"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Punie/no/releases/download/0.6.0/no-cli-aarch64-apple-darwin.tar.xz"
      sha256 "66ecdd42ca11037ae78a372d586dd080d5ab8b6654922d0585d80de7073fc378"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Punie/no/releases/download/0.6.0/no-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a77714edfed5944dcb7bb7c56cefdde87bfbebb7961e4950c94bdf85caa0d9c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Punie/no/releases/download/0.6.0/no-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ddf594f8ba047d4e95b8322bff2595140304bc2f873ccf05d74a3b6dd0df1b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Punie/no/releases/download/0.6.0/no-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9d3f5d1c12a4bf3324188d30f337e2d80a65d9527b94b44bcaddd6b7b0bf558e"
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
