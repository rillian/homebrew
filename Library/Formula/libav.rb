require "formula"

class Libav < Formula
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-11.1.tar.xz"
  sha1 "4cd3337c6c67481b7165c9c618f1fcf6998942ce"

  head "git://git.libav.org/libav.git"

  bottle do
    sha1 "450f32ac0b9be44d70e7cad574ed5937ef040050" => :yosemite
    sha1 "ddd3dea8eea023d750b1e9644460b4d0dd12e311" => :mavericks
    sha1 "169b1f483e117f253196956876c03092ddaba01e" => :mountain_lion
  end

  option "without-faac", "Disable AAC encoder via faac"
  option "without-lame", "Disable MP3 encoder via libmp3lame"
  option "without-x264", "Disable H.264 encoder via x264"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder via xvid"

  option "with-opencore-amr", "Enable AMR-NB de/encoding and AMR-WB decoding " +
    "via libopencore-amrnb and libopencore-amrwb"
  option "with-openjpeg", "Enable JPEG 2000 de/encoding via OpenJPEG"
  option "with-openssl", "Enable SSL support"
  option "with-rtmpdump", "Enable RTMP protocol support"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-sdl", "Enable avplay"
  option "with-speex", "Enable Speex de/encoding via libspeex"
  option "with-theora", "Enable Theora encoding via libtheora"
  option "with-libvorbis", "Enable Vorbis encoding via libvorbis"
  option "with-libvo-aacenc", "Enable VisualOn AAC encoder"
  option "with-libvpx", "Enable VP8 de/encoding via libvpx"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion

  depends_on "faac" => :recommended
  depends_on "lame" => :recommended
  depends_on "x264" => :recommended
  depends_on "xvid" => :recommended

  depends_on "freetype" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "frei0r" => :optional
  depends_on "gnutls" => :optional
  depends_on "libvo-aacenc" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openjpeg" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sdl" => :optional
  depends_on "speex" => :optional
  depends_on "theora" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-shared",
      "--prefix=#{prefix}",
      "--enable-gpl",
      "--enable-nonfree",
      "--enable-version3",
      "--enable-vda",
      "--cc=#{ENV.cc}",
      "--host-cflags=#{ENV.cflags}",
      "--host-ldflags=#{ENV.ldflags}"
    ]

    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-gnutls" if build.with? "gnutls"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libopencore-amrnb" if build.with? "opencore-amr"
    args << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libopenjpeg" if build.with? "openjpeg"
    args << "--enable-libopus" if build.with? "opus"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvo-aacenc" if build.with? "libvo-aacenc"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args

    system "make"

    bin.install "avconv", "avprobe"
    man1.install "doc/avconv.1", "doc/avprobe.1"
    if build.with? "sdl"
      bin.install "avplay"
      man1.install "doc/avplay.1"
    end
  end

  test do
    system "#{bin}/avconv -h"
  end
end
