require "formula"

class Zbackup < Formula
  homepage "http://zbackup.org"
  url "https://github.com/eugenesan/zbackup.git", :commit => "9e13d6b696cb68ba522b3e0841d106f2d8b5d047"
  version "1.3"
  head "https://github.com/eugenesan/zbackup.git", :branch => "master"

  option "with-brewed-openssl", "Build with Homebrew OpenSSL instead of the system version"

  depends_on "cmake" => :build
  depends_on "openssl" if MacOS.version <= :leopard or build.with? "brewed-openssl"
  depends_on "protobuf"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup backup backups/test.bak"
  end
end
