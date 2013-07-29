#!/usr/bin/perl

use warnings;
use strict;

use MyCoreFunctions;
use Traveller::Scores;
use Traveller::Common;

# use Time::HiRes;

# my $StartTime = Time::HiRes::time();

$AUTO_GENERATION = 0;				# Set to 1 for Automatic Generation

my $RANK_FILTER = 0;				# Minimum rank desired
my $SERVICE_FILTER = "ANY";			# Name of desired service
my $TERMS_FILTER = 0;				# Minimum number of terms
my $DEAD_FILTER = 1;				# Filter out characters that did not survive
my $FILTER_ON = 0;					# 1 = Filter Enabled
my $FILTER_FAILURES = 0;			# Counts number of failed characters
my $FILTER_LIMIT = 120000;			# Limits number of failed characters in Automatic Generation

$PRINT_HISTORY = 1;					# Sets level of detailed term history (1 = ON)

my $ReportValue = 2000;				# Report every [#] characters in Auto Mode
my $ShowStatus = 1;					# Report filter status in Auto Mode

if (@ARGV > 0)
{
	$AUTO_GENERATION = 1;
	$FILTER_ON = 1;
	$DEAD_FILTER = 1;
	for (my $ctr=0; $ctr < @ARGV; $ctr++)
	{
		if ($ARGV[$ctr] =~ /^RANK=(.+)$/i)
		{
			$RANK_FILTER = $1;
		}
		elsif ($ARGV[$ctr] =~ /^SERVICE=(.+)$/i)
		{
			$SERVICE_FILTER = uc($1);
		}
		elsif ($ARGV[$ctr] =~ /^TERMS=(.+)$/i)
		{
			$TERMS_FILTER = $1;
		}
		else
		{
			die "\n\n*** Invalid Argument: $ARGV[$ctr] ***\n\n";
		}
	}
}

sub FilterLimitReached
{
	if ($FILTER_FAILURES > $FILTER_LIMIT)
	{
		print "\n\n*** Filter Limit $FILTER_LIMIT exceeded! ***\n\n";
		return 1;
	}
	else
	{
		return 0;
	}
}

sub FilterCheck # $Hero
{
	my ($Hero) = @_;
	my $FilterResult = 1;		# Assume valid unless one or more filters fail
	
	if ($FILTER_ON)
	{
		if ($SERVICE_FILTER ne "ANY")
		{
			if (uc(GetService($Hero)) ne $SERVICE_FILTER)
			{
				$FilterResult = 0;
			}
		}
		
		if ($RANK_FILTER > 0)
		{
			if (GetRank($Hero) < $RANK_FILTER)
			{
				$FilterResult = 0;
			}
		}
		
		if ($TERMS_FILTER > 0)
		{
			if (GetTerms($Hero) < $TERMS_FILTER)
			{
				$FilterResult = 0;
			}
		}
		
		if ($DEAD_FILTER)
		{
			if (Dead($Hero))
			{
				$FilterResult = 0;
			}
		}
		else
		{
			if (Dead($Hero) && GetTerms($Hero) > 6)
			{
				$FilterResult = 1;
			}
		}
	}
	if (!$FilterResult)
	{
		$FILTER_FAILURES++;
		if (!($FILTER_FAILURES % $ReportValue) && $ShowStatus)
		{
			print STDERR "\n\t... $FILTER_FAILURES characters generated... \n\n";
		}
	}
	return ($FilterResult);
}

my $HTML_Mode = 0;
if ($HTML_Mode)
{
	print "Content-type:text/html\r\n\r\n";
	print '<html>';
	print '<head>';
	print '<title>Hello Word - First CGI Program</title>';
	print '</head>';
	print '<body>';
	print '<pre>';	
}


my $GenerateMode = 1;
my ${Hero} = {};

while ($GenerateMode)
{

	${Hero} = newCharacter();

	${Hero}->{Scores} = new Scores("Basic6");

	SaveScores($Hero);

	DetermineService($Hero);

	ServiceSkills($Hero);
	
	while (StillServing($Hero))
	{
		if (!Dead($Hero))
		{
			ResolveTerm($Hero);
		}
		if (!$AUTO_GENERATION)
		{
			print "Status at end of Term ",GetTerms($Hero),"\n\n";
			PrintCharacter ($Hero);
			print "\n";
		}
	}

	if (!$AUTO_GENERATION)
	{
		print "Final Status\n\n";
	}

	$GenerateMode = !FilterCheck($Hero) && !FilterLimitReached();
}

# my $EndTime = Time::HiRes::time();

# my $Duration = $EndTime - $StartTime;

if ($FILTER_FAILURES > 0)
{

	# print "\nGenerated $FILTER_FAILURES characters in ";
	# printf ("%.2f",$Duration);
	# print " seconds\n\n";
	# print "Average rate of ";
	# printf ("%.1f",1 /($Duration/$FILTER_FAILURES));
	# print " characters per second\n\n";
}

if (!Dead($Hero))
{
	MusterOut($Hero);
}

print "\n\n","=" x 40,"\n\n";

PrintCharacter($Hero);

my $filename = "TravChar - ".GetCharID($Hero).".txt";

open (CHARFILE,">",$filename);

select CHARFILE;

PrintCharacter($Hero);

select STDOUT;

close CHARFILE;

print "\n\n","=" x 40,"\n\n";

print "Your character was written to $filename\n\n";

# PrintMusterTables($Hero);



# print Dumper($Hero);

if ($HTML_Mode)
{
	print '</pre>';
	print '</body>';
	print '</html>';
}

1
