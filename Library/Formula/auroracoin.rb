require "formula"

class Auroracoin < Formula
  homepage "http://www.auroracoin.org"
  url "https://github.com/baldurodinsson/auroracoin-project.git", :commit => "2af4a12f2e4beffb5321eb8089e14a7ab065df9d"
  version "1.2"
  head "https://github.com/baldurodinsson/auroracoin-project.git", :branch => "master"

  option "without-upnp", "Enable uPNP port forwarding"
  option "without-qrc", "Enable QR codes"

  depends_on "automake"
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "miniupnpc" if not build.include? "without-upnp"
  depends_on "openssl"
  depends_on "pkg-config"
  depends_on "protobuf"
  depends_on "qt"
  depends_on "qrencode" if not build.include? "without-qrc"

  def install
    system "qmake", "USE_IPV6=1", "USE_UPNP=1", "USE_QRCODE=1", "PREFIX=#{prefix}"
    system "make"
    prefix.install "AuroraCoin-Qt.app"

    cd "src" do
    system "make", "-f", "makefile.osx", "USE_IPV6=1", "USE_UPNP=1", "USE_QRCODE=1"
    bin.install "AuroraCoind"
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>PathState</key>
          <dict>
            <key>~/Library/Application Support/Auroracoin/auroracoind.pid</key>
            <false/>
          </dict>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/auroracoindd</string>
          <string>-daemon</string>
        </array>
      </dict>
    </plist>
    EOS
  end
end
