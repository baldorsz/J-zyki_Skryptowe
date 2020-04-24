#!/usr/bin/perl

start:
print "Podaj nazwę pliku: ";
$file = <STDIN>;
chop($file);

unless(-e $file) {
    print "Podany plik nie istnieje\n";
    goto start;
}

open $plik, $file;

@lastStart = (0,0);
@lastEnd = (0,0);

$sumaGodz = 0;
$lastMin;

@startDates;
@endDates;
@toCSV;

%subjects;
%StudyType;




while(defined($line=<$plik>))
{
    if($line =~ /DTSTART.+:(\d+)T(\d{2})(\d{2})/gm)
    {
        if(defined($1))
        {
            @lastStart = ($2, $3);
            push @startDates, "$1:T$2:$3";
        }
    }
    elsif($line =~ /DTEND.+:(\d+)T(\d{2})(\d{2})/gm)
    {
        if(defined($1))
        {
            @lastEnd = ($2, $3);
            $end = $2*60+$3;
            $start = $lastStart[0]*60+$lastStart[1];
            $lastMin = $end - $start;
            $sumaGodz += int(($lastMin/45));
            push @endDates, "$1:T$2:$3";
        }
    }
    elsif(@catch = $line =~ /SUMMARY:(.+) - (?:.+)Grupa: (.+),/gm)
    {
        if(defined($catch[1]))
        {
            chop ($line);
            push @toCSV, $line;
        }
        if(@catch)
        {
            @TypeAndDegree = $catch[1] =~ /(S|N)(\d)/gm; 
            @Form = $catch[1] =~ /_(W|L)(?:_?)/gm;
            $subjects{$catch[0]}+=int(($lastMin/45));
            if(!defined($TypeAndDegree[0]))
            {
                $StudyType{"other"}+=int(($lastMin/45));
                $StudyType{$Form[0]}+=int(($lastMin/45));
            }
            else {
                $StudyType{$TypeAndDegree[0]} +=  int(($lastMin/45));
                $StudyType{$TypeAndDegree[1]} += int(($lastMin/45));
                $StudyType{$Form[0]} += int(($lastMin/45));
            }
        }
    }
}

print "Łączna liczba godzin lekcyjnych: " . int(($sumaGodz));
print "\nLiczba godzin lekcyjnych dla niestacjonarnych: " . $StudyType{"N"};
print "\nLiczba godzin lekcyjnych dla stacjonarnych: " . $StudyType{"S"};
print "\nLiczba godzin lekcyjnych dla stopnia 1: " . $StudyType{"1"};
print "\nLiczba godzin lekcyjnych dla stopnia 2: " . $StudyType{"2"};
print "\nLiczba godzin lekcyjnych dla innych form zajęć (np.: bloki przedmiotowe): " . $StudyType{"other"};
print "\nLiczba godzin lekcyjnych dla laboratoriów: " . $StudyType{"L"};
print "\nLiczba godzin lekcyjnych dla wykładów: " . $StudyType{"W"};

print "\nLiczba godzin z podziałem na przedmioty:";
for $subject (keys %subjects)
{
    print "\n$subject: $subjects{$subject}";
}
print "\n";

open $fh, '>', 'plan.csv';

print {$fh} '"Data","Od","Do","Przedmiot","Semestr","Grupa","Sala"';
print {$fh} "\n";

for ($i=0; $i < scalar(@toCSV); $i++)
{
    @St = $startDates[$i] =~ /(\d{4})(\d{2})(\d{2}):T(\d{2}):(\d{2})/gm;
    $e1 = '"' . $St[0] . '.' . $St[1] . '.' . $St[2] . '",'; #data
    $e2 = '"' . $St[3] . ':' . $St[4] . '",'; #time
    @En = $endDates[$i] =~ /(\d{4})(\d{2})(\d{2}):T(\d{2}):(\d{2})/gm;
    $e3 = '"' . $En[3] . ':' . $En[4] . '",'; #time

    @info = $toCSV[$i] =~ /SUMMARY:(.+) - Nazwa sem\.: (.+), Nr sem.+Grupa: (.+), Sala: (.+)\s/gm;
    $e4 = '"' . $info[0] . '",';
    $e5 = '"' . $info[1] . '",';
    $e6 = '"' . $info[2] . '",';
    $e7 = '"' . $info[3] . '"' . "\n";
    print {$fh} $e1 . $e2 . $e3 . $e4 . $e5 . $e6 . $e7;
}

close $fh;

print "Zapisano do pliku!\n";

close $plik;


