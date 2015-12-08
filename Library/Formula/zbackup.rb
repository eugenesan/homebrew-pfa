require "formula"

class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup.git", :commit => "d421fdfa89014987fd53cccf22ede38fef824391"
  version "1.5alpha+20150923"
  head "https://github.com/zbackup/zbackup.git", :branch => "master"

  option "with-brewed-openssl", "Build with Homebrew OpenSSL instead of the system version"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils
  depends_on "lzo"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup --non-encrypted backup backups/test.bak"
  end
end
