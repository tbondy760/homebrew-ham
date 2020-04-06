class Direwolf < Formula
  desc "Software modem and TNC for AX.25"
  homepage "https://github.com/wb2osz/direwolf"
  url "https://github.com/wb2osz/direwolf/archive/1.5.tar.gz"
  sha256 "2e263ea4fa75c342b620dee048436ac95486ea3f93599ad818e74dfd4aec8b48"
  version "1.5"
  option "with-initial-config", "Do initial configuration step, i.e. 'make install-conf'. Do for the first install only."

  depends_on "hamlib"
  depends_on "portaudio"

  def install
    inreplace "Makefile.macosx", "LDLIBS += -framework CoreAudio",
                                 "LDLIBS += $(EXTRA_LDLIBS) -framework CoreAudio"
    inreplace ["decode_aprs.c", "symbols.c"], "/usr/local", opt_prefix
    system "make -k all EXTRA_CFLAGS=-DUSE_HAMLIB EXTRA_LDLIBS=-lhamlib || true"

    bin.install %w[
      direwolf
      decode_aprs
      # Utilities related to APRStt gateway, UTM corrd, log file to GPX, ...
      tt2text 
      text2tt 
      ll2utm 
      utm2ll
      log2gpx 
      gen_packets
      aclients 
      ttcalc 
      kissutil
      cm108
      dwspeak.sh
      # APRS Telemetry Toolkit
      telem-ballon.pl
      telem-bits.pl
      telem-data91.pl
      telem-data.pl
      telem-eqns.pl
      telem-parm.pl
      telem-unit.pl
      telem-volts.pl
    ]

    if build.with? "initial-config"
      system "make", "install-conf"
    end
    
    pkgshare.install "tocalls.txt", "symbolsX.txt", "symbols-new.txt"
    man.install "man1"
    doc.install Dir["doc/*"]
  end
end
