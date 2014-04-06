require 'formula'

class X2goclient < Formula
  homepage 'http://www.x2go.org'
  url 'http://code.x2go.org/releases/source/x2goclient/x2goclient-4.0.1.3.tar.gz'
  sha1 '37b946b5b6d0a072a6d1fee98ae43bef929f2abd'
  head 'http://code.x2go.org/git/x2goclient.git'

  depends_on :x11
  depends_on :libpng
  depends_on 'jpeg'
  depends_on 'nxcomp'
  depends_on 'libssh'
  depends_on 'qt'

  def install
    # Configure
    system "lrelease", "#{name}.pro"
    system "qmake", "-config", "release"

    # Actual build
    system "make"

    # Bundle build
    system "macdeployqt", "#{name}.app"

    # Link nxproxy binary (this quirck avoids patching upstream)
    system "mkdir", "-p", "#{name}.app/Contents/exe"
    system "ln", "-s", "#{HOMEBREW_PREFIX}/bin/nxproxy", "#{name}.app/Contents/exe/"

    # Install app
    prefix.install "#{name}.app"

    # Symlink in the command-line version
    bin.install_symlink prefix/"#{name}.app/Contents/MacOS/#{name}"
  end

  def caveats; <<-EOS
    #{name}.app was installed in:
    #{prefix}
    To symlink into ~/Applications, you can do:
      brew linkapps
    or
      sudo ln -s #{prefix}/#{name}.app /Applications
    EOS
  end
end
