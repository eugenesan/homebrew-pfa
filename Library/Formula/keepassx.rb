require 'formula'

class Keepassx < Formula
  homepage 'http://www.keepassx.org'
  url 'http://www.keepassx.org/releases/keepassx-0.4.3.tar.gz'
  sha1 'd25ecc9d3caaa5a6d0f39a42c730a95997f37e2e'

  depends_on 'qt'

  def install
    # Fix build on OSX 10.9
    inreplace "src/lib/random.cpp", "#include \"random.h\"", "#include \"random.h\"\n#include <unistd.h>"

    # Simple Qt4 build
    system "qmake", "CONFIG-=app_bundle", "PREFIX=#{prefix}"
    system "make", "install"
  end
end
