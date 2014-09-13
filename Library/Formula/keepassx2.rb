require 'formula'

class Keepassx2 < Formula
  homepage 'http://www.keepassx.org'
  url 'https://github.com/keepassx/keepassx/archive/2.0-alpha6.tar.gz'
  sha1 'dc6054d9964c735236de6902b2aede3619ee04b9'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'libgcrypt'
  depends_on 'zlib'

  def install
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args

      # Do no deploy redundent Qt libs (we do no use .dmg bundle and the proccess is broken anyway)
      inreplace 'src/cmake_install.cmake', 'FIXUP_QT4_EXECUTABLE', '#FIXUP_QT4_EXECUTABLE'

      system 'make', 'install'
    end
  end
end
