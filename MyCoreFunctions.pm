package MyCoreFunctions;

use strict;
use Exporter;
use warnings;

# Specify shared names here
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
$VERSION = 1.00;
@ISA = qw(Exporter);

# @EXPORT - Everything automatically exported
@EXPORT = qw(Pick RollDice Pause Random RandomRange RollXDropY TitleCase
			 MenuChoice Ask $DEBUG Debug PrintHash InList);

# @EXPORT_OK - Items available for export
@EXPORT_OK = ();

# %EXPORT_TAGS - Build sets of exported names
%EXPORT_TAGS = ();

BEGIN 
{
	srand;
}

our $DEBUG;		# Global variable used for selective debugging

sub TitleCase
{
	# Assume single word for now, expand it later
	my ($text) = (@_);
	
	my $len = length ($text);

	my $text2 = uc(substr($text,0,1));

	for (my $i = 1; $i < $len; $i++)
	{
		$text2 .= lc(substr($text,$i,1));
	}
	
	return ($text2);
}

sub Debug
{
	if ($DEBUG)
	{
		print "\n** DEBUG ** @_\n\n";
	}
}

sub Pick
{
	my $item = $_[int(rand(@_))];
	return ($item);
}

sub Random
{
	my ($MaxNum) = @_;	# Generating number 0 to $MaxNum
	return (int(rand($MaxNum)));
}

sub RandomRange
{
	my ($Range) = @_;   # Generating number 1 to $Range
	return (int(rand($Range)+1));
}

sub Pause
{
	print "Press enter to continue...\n";
	chomp(my $scratch=<STDIN>);
}

sub RollDice
{
	if (@_ == 2)   # Quantity & Type
	{
		my ($Quantity,$DieType) = @_;
		my $temp = 0;
		for (my $ctr=0; $ctr<$Quantity; $ctr++)
		{
			$temp += RandomRange($DieType);
		}
		return ($temp);
	}
	elsif (@_ == 1)	# DieType, Default Quantity = 1
	{
		my ($DieType) = @_;
		return(RandomRange($DieType));
	}
	else # Assume just a D6 Roll
	{
		return(RandomRange(6));
	}
}

sub RollXDropY
{
	my $RollNum;
	my $DropNum=1;
	my $DieType=6;
	if (@_ == 3)	# Roll X, Drop Y, $DieType
	{
		($RollNum,$DropNum,$DieType) = @_;
	}
	elsif (@_ == 2)	# Roll X, Drop Y, Default $DieType is D6
	{
		($RollNum,$DropNum) = @_;
	}
	else	# Roll X, Drop 1, Default $DieType is D6
	{
		($RollNum) = @_;
	}
	
	my @TempRolls;
	for (my $ctr=0; $ctr<$RollNum; $ctr++)
	{
		$TempRolls[$ctr] = RandomRange($DieType);
	}

	print "Original List:\n";
	print "\t@TempRolls\n";
	
	@TempRolls = sort {$b <=> $a} @TempRolls;

	print "Sorted List:\n";
	print "\t@TempRolls\n";
	
	@TempRolls = @TempRolls[0..($#TempRolls-$DropNum)];

	print "Filtered List:\n";
	print "\t@TempRolls\n";

	my $total=0;
	for (my $ctr=0; $ctr<@TempRolls; $ctr++)
	{
		$total += $TempRolls[$ctr];
	}
	return ($total);
}

sub MenuChoice
{
	my ($UserPrompt,$Title,@MenuItems) = @_;

	my $ValidChoice = 0;
	
	do
	{
		print "\n";
		if ($Title)
		{
			print "\t   $Title\n\n";
		}
		my $NumItems = @MenuItems;
		for (my $ctr=0; $ctr<$NumItems; $ctr++)
		{
			print "\t";
			if  ( ($NumItems >= 10) && ($ctr < 10) )
			{
				print " ";
				print $ctr+1;
			}
			else
			{
				print $ctr+1;
			}
			print ") $MenuItems[$ctr]\n";
		}
		
		print "\n$UserPrompt> ";
		chomp(my $Choice=<STDIN>);
		
		if (!($Choice =~ m/^\d+$/))
		{
			print "\nInvalid Choice. Please enter a number.\n";		
		}
		elsif (($Choice > 0) && ($Choice <= $NumItems))
		{
				return ($Choice-1);
		}
		else
		{
			print "\nInvalid Choice. Please choose a number between 1 and $NumItems.\n";
		}

	} until ($ValidChoice);
}

sub InList # $Item,@List
{
	my ($Item,@List) = @_;
	my $TempValue = 0;
	foreach (@List)
	{
		if ($Item eq $_)
		{
			$TempValue = 1;
		}
	}

	return $TempValue;
}

sub Ask
{
	my ($prompt) = @_;
	my $ValidChoice = 0;
	do
	{
		print "$prompt (Y/N)? ";
		chomp(my $choice=<STDIN>);
		
		if (uc($choice) eq "Y")
		{
			return (1);
		}
		elsif (uc($choice) eq "N")
		{
			return (0);
		}
		else
		{
			print "\nInvalid answer. Please enter Y or N\n\n";
		}
	} until ($ValidChoice);
}

sub PrintHash
{
	my $CurLevel = 0;
	my $IndentString = " " x 24;
	if (@_ > 1)
	{
		$CurLevel = $_[1];
	}
	
	my %Current = %{$_[0]};
	
	while (my ($key,$value) = each (%Current))
	{
		print $IndentString x $CurLevel, "$key  -> ";
		
		my $RefType = ref($value);
		
		if (!$RefType)	# Not a reference, must be scalar
		{
			print "$value\n";
		}
		elsif ($RefType eq "ARRAY")
		{
			print "@{$value}\n";
		}

		elsif ($RefType eq "HASH")
		{
			print "\n";
			PrintHash($value,++$CurLevel);
			--$CurLevel;
		}
		else
		{
			print "\n\nERROR! What is $RefType?\n\n";
		}
	}
}


1