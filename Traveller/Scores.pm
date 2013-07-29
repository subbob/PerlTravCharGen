package Scores;

use MyCoreFunctions;
use Traveller::Common;

# Methods
#	new Scores (Basic6)
#		- Basic roll of 6 x 2D6, assigned in order rolled		# @Options is 1
#	new Scores (PointBuy Points)
#		- Start with base template, use point buy system		# @Options is 2
#	new Scores (Roll X Drop)
#		- Roll 2D6 X times, Keep 6 highest in order rolled		# @Options is 3
#	new Scores (Roll X Drop Assign)
#		- Roll 2D6 X times, Keep 6 highest, Assign to stats		# @Options is 4

my %scores;

sub new
{
	my ($class,@Options) = @_;
	
	my $self =	{};	
	
	if (@Options == 1)
	{ # Basic6
		foreach (@CoreAbilities)
		{
			$self->{$_} = RollDice(2,6);
		}		
	}
	elsif (@Options == 2)
	{ # PointBuy Points
	}
	elsif (@Options == 3)
	{ # Roll X Drop
	}
	elsif (@Options == 4)
	{ # Roll X Drop Assign
	}
	else
	{ # Only reach this if called improperly
		die "Very bad thing in new Scores!\n";
	}
	
	return $self;
}

sub CreateCharacterScores
{
	my ($NumRolls) = @_;

	my @NewScores = GenScores($NumRolls);

	{
		my $ctr = 0;
		foreach (@CoreAbilities)
		{
			$scores{$_} = $NewScores[$ctr++];
		}
	}
}

sub GenScores
{
	my ($Rolls) = @_;
	my @TempScores = ();


	for (my $ctr=0; $ctr<$Rolls; $ctr++)
	{
		$TempScores[$ctr] = RollDice(2,6);
	}

	my @DebugScores = @TempScores;
	my @SortedScores = sort {$b <=> $a} @TempScores;

	@SortedScores = @SortedScores[0..5];

	my $MinKept = Min(@SortedScores);

	my @KeepScores = ();

	for (my $ctr=0; $ctr<@TempScores; $ctr++)
	{
		if ($TempScores[$ctr] >= $MinKept)
		{
			push @KeepScores,$TempScores[$ctr];
		}
	}

	while (@KeepScores > 6)
	{
		my @NewScores = ();
		my $Removed = 0;
		foreach my $value (@KeepScores)
		{
			if($value == $MinKept && !$Removed)
			{
				$Removed = 1;
			}
			else
			{
				push @NewScores,$value;
			}
		}
		@KeepScores = @NewScores;
	}

	return (@KeepScores);
}



1