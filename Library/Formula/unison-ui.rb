require 'formula'

class UnisonUi < Formula
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  url "https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.3.tar.gz"
  sha256 "f40d3cfbe82078d79328b51acab3e5179f844135260c2f4710525b9b45b15483"

  depends_on :xcode
  depends_on 'objective-caml'

  conflicts_with 'unison', :because => 'both install an `unison` binary'

  def install
    # Adapt to recent changes in OSX and ocaml
    inreplace "uimacnew09/MyController.h", "#import <Cocoa/Cocoa.h>", "#import <Cocoa/Cocoa.h>\n#define IBAction void\n"
    inreplace "uimacnew09/ReconTableView.h", "#import <AppKit/AppKit.h>", "#import <AppKit/AppKit.h>\n#define IBAction void\n"
    inreplace "uimacnew09/uimacnew.xcodeproj/project.pbxproj",  "-lstr", "-lcamlstr"

    # Set some build env parameters
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options

    # UI build using IB3 (Interface builder 4) which is no more supported by Xcode 4+, but still builds.
    # To build with IB formula invoking embedded into source IB plugin which hardcode it self to user environment.
    # So if your build fails, remove ~/Library/Preferences/com.apple.InterfaceBuilder3.plist and re-try.
    system "open -a uimacnew09/BWToolkit.ibplugin&"

    # FixMe: In some rare cases make stalls at the end (bizzare)
    system "make UISTYLE=macnew09 all"
    system "make UISTYLE=text all"

    bin.install "unison"
    prefix.install "uimacnew09/build/Default/Unison.app"
  end

  def caveats; <<-EOS
      Unison.app was installed in:
      #{prefix}/Unison.app
      To symlink into ~/Applications, you can do:
      brew linkapps
      or
      sudo ln -s #{prefix}/Unison.app /Applications
  EOS
  end
end
