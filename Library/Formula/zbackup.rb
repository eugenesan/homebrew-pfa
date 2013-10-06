require 'formula'

class Zbackup < Formula
  homepage 'http://zbackup.org'
  url 'https://github.com/zbackup/zbackup/archive/1.2.tar.gz'
  sha1 'e87dfaeeeea0d59f4af00d3ce248aaabf1a25cb9'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'

  depends_on 'cmake' => :build
  depends_on 'openssl' if MacOS.version <= :leopard or build.with?('brewed-openssl')
  depends_on 'protobuf'
  depends_on 'xz' # get liblzma compression algorithm library from XZutils

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
