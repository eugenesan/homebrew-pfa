require "formula"

class RadiantPlayer < Formula
  homepage "https://github.com/kbhomes/google-music-mac"
  url "https://github.com/kbhomes/google-music-mac/archive/v1.1.3.tar.gz"
  sha1 "9c962efeaec17804b134865e3785322ebe37c9ee"

  depends_on :xcode

  def install
    # Fix CasE SeNsItIvItY!
    inreplace "google-music-mac/LastFm/LastFmPopover.h", "LastFM", "LastFm"

    # Build embedded Pods project as dependency
    cd "Pods" do
      xcodebuild "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=../build"
    end

    # Build main project
    xcodebuild "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    prefix.install 'build/Release/Radiant Player.app'
  end

  def caveats; <<-EOS
    Radiant Player.app was installed in:
    #{prefix}
    To symlink into ~/Applications, you can do:
      brew linkapps
    or
      sudo ln -s #{prefix}/Radiant Player.app /Applications
    EOS
  end
end
