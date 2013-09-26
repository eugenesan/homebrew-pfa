require 'formula'

class Nxcomp < Formula
  homepage 'http://www.nomachine.com/sources.php'
  url 'http://code.x2go.org/releases/source/nx-libs/nx-libs-3.5.0.21-lite.tar.gz'
  sha1 'f8d6860aab3b3b852e5e6bbe747723605408e25c'
  version '3.5.0.21-lite'

  depends_on :automake
  depends_on :x11
  depends_on :libpng
  depends_on 'jpeg'

  # Adapt for OSX
  def patches; DATA end

  def install
    # Build lib
    cd "nxcomp" do
      # Configure
      system "autoreconf", "--force", "--install"
      system "./configure", "--prefix=#{prefix}"

      # Actual build
      system "make", "install"
    end

    # Build binary
    cd "nxproxy" do
      # Link with lib
      ENV.append 'LDFLAGS', "-L#{lib}/nx"

      # Configure
      system "autoreconf", "--force", "--install"
      system "./configure", "--prefix=#{prefix}"

      # Actual build
      system "make", "install"
    end
  end
end

__END__
--- a/nxcomp/Makefile.in
+++ b/nxcomp/Makefile.in
@@ -91,9 +91,9 @@
 LIBRARY = Xcomp
 
 LIBNAME    = lib$(LIBRARY)
-LIBFULL    = lib$(LIBRARY).so.$(VERSION)
-LIBLOAD    = lib$(LIBRARY).so.$(LIBVERSION)
-LIBSHARED  = lib$(LIBRARY).so
+LIBFULL    = lib$(LIBRARY)$(VERSION).dylib
+LIBLOAD    = lib$(LIBRARY)$(LIBVERSION).dylib
+LIBSHARED  = lib$(LIBRARY).dylib
 LIBARCHIVE = lib$(LIBRARY).a
 
 LIBCYGSHARED  = cyg$(LIBRARY).dll
@@ -231,7 +231,11 @@
 CXXOBJ = $(CXXSRC:.cpp=.o)
 
 $(LIBFULL):	 $(CXXOBJ) $(COBJ)
-		 $(CXX) -o $@ $(LDFLAGS) $(CXXOBJ) $(COBJ) $(LIBS)
+		 $(CXX) -o $@ \
+			 -install_name $(libdir)/nx/$@ \
+			 -compatibility_version $(LIBVERSION) \
+			 -current_version $(LIBVERSION) \
+			 $(LDFLAGS) $(CXXOBJ) $(COBJ) $(LIBS)
 
 $(LIBLOAD):	 $(LIBFULL)
 		 rm -f $(LIBLOAD)
@@ -277,9 +281,9 @@
 	./mkinstalldirs $(DESTDIR)${libdir}/nx
 	./mkinstalldirs $(DESTDIR)${includedir}/nx
 	$(INSTALL_DATA) $(LIBFULL)              $(DESTDIR)${libdir}/nx
-	$(INSTALL_LINK) libXcomp.so.3           $(DESTDIR)${libdir}/nx
-	$(INSTALL_LINK) libXcomp.so             $(DESTDIR)${libdir}/nx
-	$(INSTALL_DATA) libXcomp.a              $(DESTDIR)${libdir}/nx
+	$(INSTALL_LINK) $(LIBLOAD)              $(DESTDIR)${libdir}/nx
+	$(INSTALL_LINK) $(LIBSHARED)            $(DESTDIR)${libdir}/nx
+	$(INSTALL_DATA) $(LIBARCHIVE)           $(DESTDIR)${libdir}/nx
 	$(INSTALL_DATA) NX*.h                   $(DESTDIR)${includedir}/nx
 	$(INSTALL_DATA) MD5.h                   $(DESTDIR)${includedir}/nx
 	echo "Running ldconfig tool, this may take a while..." && ldconfig || true
@@ -292,9 +296,9 @@
 
 uninstall.lib:
 	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBFULL)
-	$(RM_FILE) $(DESTDIR)${libdir}/nx/libXcomp.so.3
-	$(RM_FILE) $(DESTDIR)${libdir}/nx/libXcomp.so
-	$(RM_FILE) $(DESTDIR)${libdir}/nx/libXcomp.a
+	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBLOAD)
+	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBSHARED)
+	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBARCHIVE)
 	$(RM_FILE) $(DESTDIR)${includedir}/nx/NXalert.h
 	$(RM_FILE) $(DESTDIR)${includedir}/nx/NX.h
 	$(RM_FILE) $(DESTDIR)${includedir}/nx/NXmitshm.h
--- a/nxcomp/configure.in
+++ b/nxcomp/configure.in
@@ -187,7 +187,7 @@
 dnl the options -G -h.
 
 if test "$DARWIN" = yes; then
-  LDFLAGS="$LDFLAGS -bundle"
+  LDFLAGS="$LDFLAGS -dynamiclib"
 elif test "$SUN" = yes; then
   LDFLAGS="$LDFLAGS -G -h \$(LIBLOAD)"
 else
--- a/nxproxy/Makefile.in
+++ b/nxproxy/Makefile.in
@@ -15,11 +15,11 @@
            -Wall -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes \
            -Wmissing-declarations -Wnested-externs
 
-CXXINCLUDES = -I. -I../nxcomp
+CXXINCLUDES = -I. -I@prefix@/include/nx
 
 CC         = @CC@
 CCFLAGS    = $(CXXFLAGS)
-CCINCLUDES = -I. -I../nxcomp
+CCINCLUDES = -I. -I@prefix@/include/nx
 CCDEFINES  =
 
 LDFLAGS = @LDFLAGS@
--- a/nxproxy/configure.in
+++ b/nxproxy/configure.in
@@ -161,7 +161,7 @@
 if test "$CYGWIN32" = yes; then
     LIBS="$LIBS -L../nxcomp -lXcomp -lstdc++ -Wl,-e,_mainCRTStartup -ljpeg -lpng -lz"
 else
-    LIBS="$LIBS -L../nxcomp -lXcomp"
+    LIBS="$LIBS -lXcomp"
 fi
 
 dnl Find makedepend somewhere.
