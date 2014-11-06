require "formula"

class Bitcoin < Formula
  homepage 'http://bitcoin.org/'
  version '0.9.3'
  url "https://github.com/bitcoin/bitcoin/archive/v#{version}.tar.gz"
  head 'https://github.com/bitcoin/bitcoin.git', :branch => "master"
  sha1 'bbfb311c3e02b37aba71385d2d369450a88a601e'

  option 'without-upnp', 'Disable uPNP port forwarding'
  option 'without-qrc', 'Disable QR codes'
  option 'without-qt', 'Disable Qt GUI codes'

  depends_on 'automake'
  depends_on 'berkeley-db4'
  depends_on 'boost'
  depends_on 'miniupnpc' if not build.include? 'without-upnp'
  depends_on 'openssl'
  depends_on 'pkg-config'
  depends_on 'protobuf'
  depends_on 'qrencode' if not build.include? 'without-qrc'
  depends_on 'qt' if not build.include? 'without-qt'

  def install
    system './autogen.sh'
    system './configure', "--prefix=#{prefix}"
    system 'make'
    system 'strip src/bitcoin-cli'
    system 'strip src/bitcoind'
    bin.install 'src/bitcoin-cli'
    bin.install 'src/bitcoind'

    system 'make', 'appbundle'
    prefix.install 'Bitcoin-Qt.app'
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
            <key>~/Library/Application Support/Bitcoin/bitcoind.pid</key>
            <false/>
          </dict>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/bitcoind</string>
          <string>-daemon</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    You will need to setup your bitcoin.conf if you haven't already done so:

    echo -e "rpcuser=bitcoinrpc\\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > ~/Library/Application\\ Support/Bitcoin/bitcoin.conf
    chmod 600 ~/Library/Application\\ Support/Bitcoin/bitcoin.conf

    Use `bitcoind stop` to stop bitcoind if necessary! `brew services stop bitcoind` does not work!
    EOS
  end
end
