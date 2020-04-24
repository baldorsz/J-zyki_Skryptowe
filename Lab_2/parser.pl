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

$sumaMin = 0;
$counter = 0;
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
            $counter+=1;
        }
    }
    elsif($line =~ /DTEND.+:(\d+)T(\d{2})(\d{2})/gm)
    {
        if(defined($1))
        {
            @lastEnd = ($2, $3);
            $end = $2*60+$3;
            $start = $lastStart[0]*60+$lastStart[1];
            $sumaMin += $end - $start;
            $lastMin = $end - $start;
            push @endDates, "$1:T$2:$3";
        }
    }
    elsif($line =~ /SUMMARY:(.+) - (?:.+)Grupa: (.+),/gm)
    {
        if(defined($1))
        {
            push @toCSV, $line;
        }
        if(defined($1))
        {
            @TypeAndDegree = $2 =~ /(S|N)(\d)/gm;
            $Form = $2 =~ /_(W|L)/gm;
            $subjects{$1}+=int(($lastMin/45));
            if(!defined($TypeAndDegree[0]))
            {
                $StudyType{"other"}+=int(($lastMin/45));
                $StudyType{$Form}+=int(($lastMin/45));
            }
            else {
                $StudyType{$TypeAndDegree[0]} += int(($lastMin/45));
                $StudyType{$TypeAndDegree[1]} += int(($lastMin/45));
                $StudyType{$Form} += int(($lastMin/45));
            }
        }
    }
}

for $type (keys %StudyType)
{
    print "\n$type: $StudyType{$type}";
}
print "\n";

print "Łączna liczba godzin lekcyjnych: " . int(($sumaMin/45));
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

# open $fh, '>', 'plan.csv';

# print {$fh} '"Data","Od","Do","Przedmiot","Grupa","Sala"';
# print {$fh} "\n";

# for ($i=0; $i < scalar(@toCSV); $i++)
# {

# }


