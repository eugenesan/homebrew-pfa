require 'formula'

class MegaSdk < Formula
  homepage 'http://mega.co.nz'
  url 'https://github.com/meganz/sdk2/archive/92d2fc2e4e.zip'
  version '2.0.0'
  sha1 'aa566b8e1774325c8a4c04808b1eea36d65a0427'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'sqlite3'
  depends_on 'cryptopp'
  depends_on 'readline'
  depends_on 'freeimage'
  depends_on 'c-ares'
  depends_on 'doxygen'
  depends_on 'curl' => [:build, 'with-ares']

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "./configure", "--prefix=#{prefix}", "--enable-examples"
    system "make", "doc", "install"
    bin.install "examples/.libs/megacli"
    bin.install "examples/.libs/megasync"
    doc.install "README.md"
    doc.install "doc/api/html"
  end

  def caveats; <<-EOS
    Disclamer:
    You must accept Mega SDK usage agreement before using this software:
    1. Register at http://www.mega.co.nz.
    2. Visit https://mega.co.nz/#sdk, read and accept the agreement.
       Note, agreement will be shown only once and it's tuff!
       In short YOU ARE responsible for all content processed by your instance of this application.
       Including 3rParty/Indirect damages/claims!
    3. Each MEGA client application needs a valid key to access the API.
       Please use a separate key for each of your applications.
       To do so visit https://mega.co.nz/#sdk or/and https://github.com/meganz/sdk2

    You must accept all above, otherwise, uninstall now!!!
    EOS
  end
end
