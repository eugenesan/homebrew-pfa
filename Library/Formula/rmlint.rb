require 'formula'

class Rmlint < Formula
  homepage 'https://github.com/sahib/rmlint'
  url 'https://github.com/sahib/rmlint/archive/1.0.6b.tar.gz'
  version '1.0.6b'
  sha1 'c72dd04627a0814c473a35c88eaccfdacdd0d1d1'

  head 'https://github.com/sahib/rmlint.git', :branch => 'master'

  def install
    inreplace "Makefile", "/usr", ""
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
