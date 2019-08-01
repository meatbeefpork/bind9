#!/usr/bin/env perl
#
# Copyright (C) Internet Systems Consortium, Inc. ("ISC")
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# See the COPYRIGHT file distributed with this work for additional
# information regarding copyright ownership.

use strict;
use warnings;

my $rev = '$Id: convertxsl.pl,v 1.14 2008/07/17 23:43:26 jinmei Exp $';
$rev =~ s/\$//g;
$rev =~ s/,v//g;
$rev =~ s/Id: //;

my $xsl = "unknown";
my $lines = '';

while (<>) {
    chomp;
    # pickout the id for comment.
    $xsl = $_ if (/<!-- .Id:.* -->/);
    # convert Id string to a form not recognisable by cvs.
    $_ =~ s/<!-- .Id:(.*). -->/<!-- \\045Id: $1\\045 -->/;
    s/[\ \t]+/ /g;
    s/\>\ \</\>\</g;
    s/\"/\\\"/g;
    s/^/\t\"/;
    s/[\ \t]+$//g;
    s/$/\\n\"/;
    if ($lines eq "") {
	    $lines .= $_;
    } else {
	    $lines .= "\n" . $_;
    }
}

$xsl =~ s/\$//g;
$xsl =~ s/<!-- Id: //;
$xsl =~ s/ -->.*//;
$xsl =~ s/,v//;

print "/*\n * Generated by $rev \n * From $xsl\n */\n";
print 'static char xslmsg[] =',"\n";
print $lines;

print ';', "\n";
