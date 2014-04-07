require "formula"

class RadiantPlayer < Formula
  homepage "https://github.com/kbhomes/google-music-mac"
  url "https://github.com/kbhomes/google-music-mac/archive/v1.1.2.tar.gz"
  sha1 "bc8da0beb26907319c6667338c6093f3d646951f"

  depends_on :xcode

  def install
    # Fix CasE SeNsItIvItY!
    File.rename "google-music-mac/LastFMService.h", "google-music-mac/LastFmService.h"
    File.rename "google-music-mac/LastFMService.m", "google-music-mac/LastFmService.m"

    # Build embedded Pods project as dependency
    cd "Pods" do
      xcodebuild "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=../build"
    end

    # Build main project
    xcodebuild "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    bin.install 'build/Release/Radiant Player.app'
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
