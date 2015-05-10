#!perl6

use v6;

use lib 'lib';

use Test;

use Sys::Lastlog;

my $uid = $*USER.Numeric;
my $logname = $*USER.Str;

ok my $obj = Sys::Lastlog.new, "create a Sys::Lastlog object";

isa-ok $obj, Sys::Lastlog, "and it's the right sort of thing";

my $ret;

lives-ok { $ret = $obj.getlluid($uid) }, "getlluid()";

ok $ret.defined, "it's defined";

isa-ok $ret, Sys::Lastlog::Entry, "and that returns the right thing";

lives-ok { $ret = $obj.getllnam($logname) }, "getllnam()";

ok $ret.defined, "it's defined";

isa-ok $ret, Sys::Lastlog::Entry, "and that returns the right thing";



done();
