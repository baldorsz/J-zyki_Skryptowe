#!/usr/bin/perl

# Bartosz Narożniak
# 41458
# 31B
# Zadanie na ocenę 5

$length = @ARGV;
if($length > 4) {
    die "Too much arguments!";
}
$i = 0;
$lFlag = 0;
$LFlag = 0;
$dirFlag = 0;

for($i; $i<$length; $i++) {
    if($ARGV[$i]eq"-l") {
        $lFlag = 1;
    }
    elsif($ARGV[$i]eq"-L") {
        $LFlag = 1;
    }
    else {
        $isDir = index($ARGV[$i], '/');
        if($isDir != -1) {
            $dirFlag = 1;
            $ownDir = $ARGV[$i];
        }
    }
}

if($dirFlag) {
    opendir($dir, $ownDir), '.' or die "Couldnt open $ownDir directory: $!";
    while (readdir($dir)) {
        if($lFlag) {
            @info = stat($_);
            print sprintf("%-30s\t", substr($_, 0, 30));
            print sprintf("%10d\t", $info[7]);
            @time = localtime($info[10]);
            print sprintf("%d-%02d-%02d %02d:%02d:%02d", $time[5]+1900, $time[4], $time[3], $time[2], $time[1], $time[0]) . "\t";
            $mode = $info[2] & 07777;
            (-d $_) ? print "d" : print "-";
            for ($j=0; $i < 3; $i++) {
                (($mode) & (256 >> $j*3)) ? print "r" : print "-";
                (($mode) & (128 >> $j*3)) ? print "w" : print "-";
                (($mode) & (64 >> $j*3)) ? print "x" : print "-";
            }
        } else {
        print "$_";
        }
        if($LFlag) {
            print "\t".getpwuid($Info[4]);
        }
        print "\n";
    }
    closedir $dir;
} else {
    opendir my $handle, '.' or die "Couldnt open current directory: $!";
    while (readdir $handle) {
        if($lFlag) {
            @info = stat($_);
            print sprintf("%-30s\t", substr($_, 0, 30));
            print sprintf("%10d\t", $info[7]);
            @time = localtime($info[10]);
            print sprintf("%d-%02d-%02d %02d:%02d:%02d", $time[5]+1900, $time[4], $time[3], $time[2], $time[1], $time[0]) . "\t";
            $mode = $info[2] & 07777;
            (-d $_) ? print "d" : print "-";
            for ($j=0; $i < 3; $i++) {
                (($mode) & (256 >> $j*3)) ? print "r" : print "-";
                (($mode) & (128 >> $j*3)) ? print "w" : print "-";
                (($mode) & (64 >> $j*3)) ? print "x" : print "-";
            }
        }
        else {
            print $_;
        }
        if($LFlag) {
            @ownerInfo = stat($_);
            print "\t".getpwuid($ownerInfo[4]);
        }
        print "\n";
    }
    closedir $handle;
}