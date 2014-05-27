require 'formula'

class SimpleMtpfs < Formula
  homepage 'http://github.com/phatina/simple-mtpfs'
  url 'https://github.com/phatina/simple-mtpfs/archive/simple-mtpfs-0.2.tar.gz'
  sha1 '0fa3e2d950aeb633c741af8ae2b3ec0f6efdda71'
  head 'https://github.com/phatina/simple-mtpfs.git', :branch => 'master'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'libusb'
  depends_on 'libmtp'
  depends_on 'osxfuse'

  def install
    # osxfuse compatible with 2.7.3
    #inreplace "configure.ac", "[fuse >= 2.8]", "[fuse >= 2.7.3]"

    # correct fuse headers location
    inreplace "src/simple-mtpfs-fuse.h", "fuse/fuse", "fuse"
    inreplace "src/simple-mtpfs-fuse.cpp", "fuse/fuse_opt", "fuse_opt"

    # OSX fdatasync() check is wrong: http://public.kitware.com/Bug/view.php?id=10044
    #inreplace "configure.ac", "AC_CHECK_FUNCS([fdatasync])\n", ""
    #inreplace "configure.ac", "AC_CHECK_FUNCS([fdatasync])", "test `uname -s` == \"Darwin\" || AC_CHECK_FUNCS([fdatasync])"

    system "autoreconf", "-i", "--force"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # provide also short alias
    bin.install_symlink "simple-mtpfs" => "mtpfs"
  end
end
