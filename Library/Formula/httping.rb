require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-1.5.5.tgz'
  sha1 '5317724ab757e3f1a9a4633936cedb6d57349796'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
