require "formula"

class RadiantPlayer < Formula
  homepage "http://kbhomes.github.io/radiant-player-mac/"
  url "https://github.com/kbhomes/radiant-player-mac/archive/v1.2.1.tar.gz"
  sha1 "e1665a94a3b8892926591e53b8103e49e6d9bc8e"

  depends_on :xcode

  def install
    # Fix CasE SeNsItIvItY!
    inreplace "radiant-player-mac/LastFm/LastFmPopover.h", "LastFM", "LastFm"

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
