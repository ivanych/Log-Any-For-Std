#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Log::Any::Test;    # should appear before 'use Log::Any'!
use Log::Any qw($log);
use Log::Any::For::Std;

#---

plan tests => 4;

my $message = "привет";

# Capture STDERR
print STDERR $message;

# Capture WARN
warn $message;

# Capture DIE
# TODO hmmm... need to think

my $msgs = $log->msgs;

like( $msgs->[0]->{message}, "/$message/", "Capture STDERR (message)" );
is( $msgs->[0]->{level}, 'notice', "Capture STDERR (level)" );

like( $msgs->[1]->{message}, "/$message/", "Capture WARN (message)" );
is( $msgs->[1]->{level}, 'warning', "Capture WARN (level)" );
