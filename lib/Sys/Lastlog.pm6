use v6;
use LibraryMake;
use NativeCall;

class Sys::Lastlog {

    use System::Passwd;

    class Entry is repr('CStruct') {
        has int $.time;
        has Str $.line;
        has Str $.host;

        method timestamp() returns DateTime {
            DateTime.new($!time // 0 );
        }

        method has-logged-in() returns Bool {
            $!time.defined && ($!time != 0);
        }
    }

    #| Class to represent return from list.  
    class UserEntry {
        has Sys::Lastlog::Entry $.entry;
        has System::Passwd::User $.user;

        method gist() {
            my Str $latest;

            if $!entry.has-logged-in {
                $latest = $!entry.timestamp.Str;
            }
            else {
                $latest = '**Never logged in**';
            }
            sprintf self.r-format, $!user.username, $!entry.line, $!entry.host, $latest;
        }

        method r-format() {
            "%-26s%-10s%-16s%-25s";
        }
    }


    sub library {
        my $so = get-vars('')<SO>;
        my $libname = "lastloghelper$so";
        my $base = "lib/Sys/Lastlog/$libname";
        for @*INC <-> $v {
            if $v ~~ Str {
                $v ~~ s/^.*\#//;
                if ($v ~ '/' ~ $libname).IO.r {
                    return $v ~ '/' ~ $libname;
                }
            }
            else {
                if my @files = ($v.files($base) || $v.files("blib/$base")) {
                    my $files = @files[0]<files>;
                    my $tmp = $files{$base} || $files{"blib/$base"};

                    $tmp.IO.copy($*SPEC.tmpdir ~ '/' ~ $libname);
                    return $*SPEC.tmpdir ~ '/' ~ $libname;
                }
            }
        }
        die "Unable to find library";
    }

    my sub p_getllent()    returns Entry is native(&library) { * }

    method getllent() returns Entry {
        p_getllent();
    }

    method r-format() {
        UserEntry.r-format;
    }

    method list() {
        my Int $i = 0;
        gather {
            loop {
                if self.getllent() -> $entry {
                    if get_user_by_uid($i++) -> $user {
                        take UserEntry.new( entry => $entry, user => $user);
                    }
                }
                else {
                    last;
                }
            }
        }
    }
    
    my sub p_getlluid(Int) returns Entry is native(&library) { * }

    method getlluid(Int $uid --> Entry) {
        p_getlluid($uid);
    }

    my sub p_getllnam(Str) returns Entry is native(&library) { * }

    method getllnam(Str $logname --> Entry) {
        p_getllnam($logname);
    }

    my sub p_setllent() is native(&library) { * }

    method setllent() {
        p_setllent();
    }
}
