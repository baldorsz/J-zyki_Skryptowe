#!/usr/bin/perl

# Bartosz Narożniak
# 41458
# 31B
# Zadanie na ocenę 5

$isFile = 0;

$fileUsers;
if ($ARGV[0] ne '')
{
    print "Plik z użytkownikami: $ARGV[0] \n";
    $fileUsers = $ARGV[0];

    if (not -e $fileUsers) {
    print "Podany plik z użytkownikami nie istnieje nie istnieje\n";
    }
    else
    {
        open $plik2, $fileUsers;
        $isFile = 1;
    }
}

start:
print "Podaj nazwę pliku html: ";
$file = <STDIN>;
chop($file);

unless(-e $file) {
    print "Podany plik nie istnieje\n";
    goto start;
}

open $plik, $file;


@UserID;
@UserInfo;
%findUsers;


while (defined($line=<$plik>))
{
    if (@catch1 = $line =~ />(WIPING.+?)<\/a>/gm)
    {
        @UserID = @catch1;
    }

    if (@catch = $line =~ /<tr class=(?:'|")problemrow(?:'|")>.*?<a href=(?:'|").+?users\/(.+?)(?:'|")>(.*?)<\/a>(.+?<\/td><\/tr>)/gm)
    {
        @UserInfo = @catch;
    }
}

for($i = 0; $i <scalar(@UserInfo); $i+=3)
{
    my @UINFO = $UserInfo[$i+2] =~ /(?:.+?>(?=[^ ])(.{1,5})<)/gm;
    foreach $UI(@UINFO)
    {
        $UI =~ s/\./,/;
        $UI =~ s/-/0,0/;
        $UI =~ "\"$UI\",";
    }
    $findUsers{$UserInfo[$i]} = "\"$UserInfo[$i+1]\",\"$UserInfo[$i]\",\"" . join('","',@UINFO) . "\"\n";
}

print '"Nazwa użytkownika","Nazwa konta",';

foreach $t(@UserID)
{
    print "\"$t\",";
}

print '"SOL","Wynik"' . "\n";

if($isFile eq 1)
{
    while(defined($line2=<$plik2>))
    {
        $line2 =~ s/\n//;
        if (exists($findUsers{$line2}))
        {
            print $findUsers{$line2};
        }
        else
        {
            print "Nie znaleziono użytkownika $line2\n";
        }
    }
    close ($plik2);
}
else
{
    foreach $b(keys %findUsers)
    {
        print $findUsers{$b};
    }
}

close $plik;