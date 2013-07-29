package Character;
use warnings;
use strict;

use Exporter;
use MyCoreFunctions;
use Traveller::Common;
use Traveller::Names;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

@ISA = qw(Exporter);

@EXPORT = qw(GetRank GetTerms Commissioned Drafted
			Commission Promote NewTerm
			GetStat PlusStat MinusStat
			GetSkill GetService Add2Resume Kill SaveScores);
			
# @EXPORT_OK - Items available for export
@EXPORT_OK = ();

# %EXPORT_TAGS - Build sets of exported names
%EXPORT_TAGS = ();

# All functions receive CharacterRef as 1st argument
sub GetRank
{
	my ($_Hero) = @_;
	return $_Hero->{Rank};
}

sub SaveScores	# $Hero
{
	my ($_Hero) = @_;
	
	foreach my $_Attr (@CoreAbilities)
	{
		$_Hero->{OriginalScores}{$_Attr} = $_Hero->{Scores}{$_Attr};
	}
	$_Hero->{ScoresSaved} = 1;
}
sub GetService
{
	my ($_Hero) = @_;
	return $_Hero->{Service};
}

sub GetTerms
{
	my ($_Hero) = @_;
	return $_Hero->{Terms};
}

sub NewTerm
{
	my ($_Hero) = @_;
	$_Hero->{Terms}++;
	$_Hero->{Age} += 4;
	my $CurTerm = $_Hero->{Terms};
	$_Hero->{Term} = $CurTerm;
	
	my $TermID = "Term".$_Hero->{Term};
	$_Hero->{$TermID} = ["Term $CurTerm Events"];
}

sub Commissioned
{
	my ($_Hero) = @_;
	return $_Hero->{Commissioned};
}

sub Drafted
{
	my ($_Hero) = @_;
	return $_Hero->{Drafted};
}

sub Promote
{
	my ($_Hero) = @_;
	Add2Resume ($_Hero,"Promoted");
	$_Hero->{Rank}++;
}

sub Add2Resume
{
	my ($_Hero,@Events) = @_;
	my $TermID = "Term".$_Hero->{Term};	
	push @{$_Hero->{$TermID}}, @Events;	
}

sub Commission
{
	my ($_Hero) = @_;
	$_Hero->{Rank}++;
	$_Hero->{Commissioned} = 1;
	Add2Resume ($_Hero,"Commissioned");	
}

sub PlusStat 
{
	my ($_Hero,$_Attribute) = @_;
	return $_Hero->{Scores}{$_Attribute}++;
}

sub MinusStat 
{
	my ($_Hero,$_Attribute) = @_;
	return $_Hero->{Scores}{$_Attribute}--;
}

sub GetStat
{
	my ($_Hero,$_Attribute) = @_;
	return $_Hero->{Scores}{$_Attribute};
}

sub Kill
{
	my ($_Hero) = @_;
	$_Hero->{Died} = 1;
	Add2Resume($_Hero,"Died");
}
sub GetSkill # CharacterRef, Skill
{
	my ($_Character,$_Skill) = @_;
	if (!defined($_Character->{Skills}{$_Skill}))
	{
		return 0;
	}
	
	return $_Character->{Skills}{$_Skill};
}

sub new
{
	my $class = shift;
	my $gender;
	my $fname;
	my $lname;
	my $gender_mode;
	my $name_mode;
	
	if (@_ == 0)
	{ # Generate random gender & random name
		$gender = RandomGender();
		$fname = RandomFirstName($gender);
		$lname = RandomLastName($gender);
		$name_mode = 1;
		$gender_mode = 1;
	}
	elsif (@_ == 1 && ( uc($_[0]) eq "MALE" || uc($_[0]) eq "FEMALE" ) )
	{ # Generate random name for specified gender
		($gender) = @_;
		$fname = RandomFirstName($gender);
		$lname = RandomLastName($gender);
		$name_mode = 1;
		$gender_mode = 0;
	}
	elsif (@_ == 2)
	{ # Use specified names, generate random gender
		$gender = RandomGender();
		($fname,$lname) = @_;
		$name_mode = 0;
		$gender_mode = 1;
	}
	elsif (@_ == 3)
	{ # Use specified gender and names
		($gender,$fname,$lname) = @_;
		$name_mode = 0;
		$gender_mode = 0;
	}
	else
	{
		die "Invalid arguments to new Character in Traveller::Character\n";
	}
		
	chomp(my $_DC = `date /T`);

	my $_DateID = substr ($_DC,4,2) . substr ($_DC,7,2) . substr ($_DC,10,4);
	
	chomp(my $_TC = `time /T`);
	
	my $_TimeID = substr($_TC,0,2).substr($_TC,3,2);	
	
	my $_RandomID = int(rand(10000));

	my $_CharID = $_DateID.$_TimeID.$_RandomID;

	my $self =	{
				CharID		=> $_CharID,
				DateCreated => $_DC,
				TimeCreated => $_TC,
				Name =>	{
						Title =>	"",
						First =>	$fname,
						Last  =>	$lname
						},
				RandomName		=> $name_mode,
				Gender			=> $gender,
				RandomGender	=> $gender_mode,
				Service			=> "",
				Age				=> 18,
				Commissioned	=> 0,
				Drafted			=> 0,		# 1 = Drafted
				Died			=> 0,		# 1 = Died during character generation
				Retired			=> 0,		# 1 = Retired from service
				Terms			=> 0,		# Number of terms served
				Rank			=> 0,		# Rank (1-6, Book 1 Rank)
				KickedOut		=> 0,		# 1 = Forced out (failed to reenlist)
				TotalSkills		=> 0,		# Total Skill Rolls
				ForcedService	=> 0,		# Mandatory reenlistment (Rolled a 12)			
				Cash			=> 0		# Cash on hand
				};
			
	return $self;
}


1