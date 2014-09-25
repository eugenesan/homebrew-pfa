require "formula"

class Uget < Formula
  homepage 'http://ugetdm.com'
  version '1.10.4'
  url "http://sourceforge.net/projects/urlget/files/uget%20%28stable%29/#{version}/uget-#{version}.tar.gz"
  sha1 'eced8dd7d8b9d33b67ada5798e31f4a5eff06da2'

  depends_on :x11
  depends_on 'gstreamer010'
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'curl' => [:build, 'with-openssl']
  depends_on 'gtk+3'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-notify', '--enable-appindicator=no'
    system 'make', 'install'
  end
end
