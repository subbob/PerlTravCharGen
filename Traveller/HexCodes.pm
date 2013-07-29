package Traveller::HexCodes;

use strict;
use Exporter;
use warnings;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
$VERSION = 1.00;
@ISA = qw(Exporter);
@EXPORT = qw(%HexCodes GetValue ValidHexCode);
@EXPORT_OK = ();
%EXPORT_TAGS = ( DEFAULT => [qw(%HexCodes GetValue ValidHexCode)] );

# exported package globals go here
our %HexCodes;

# initialize package globals

$HexCodes{"0"} = 0;
$HexCodes{"1"} = 1;
$HexCodes{"2"} = 2;
$HexCodes{"3"} = 3;
$HexCodes{"4"} = 4;
$HexCodes{"5"} = 5;
$HexCodes{"6"} = 6;
$HexCodes{"7"} = 7;
$HexCodes{"8"} = 8;
$HexCodes{"9"} = 9;
$HexCodes{"A"} = 10;
$HexCodes{"B"} = 11;
$HexCodes{"C"} = 12;
$HexCodes{"D"} = 13;
$HexCodes{"E"} = 14;
$HexCodes{"F"} = 15;

sub GetValue
{
	my ($Value) = @_;
	my @Letters = ("A","B","C","D","E","F");
	
	if (uc($Value) ~~ @Letters)
	{
		return ($HexCodes{uc($Value)});
	}
	else
	{
		return ($Value);
	}
}

sub ValidHexCode
{
	my ($CheckValue) = @_;
	my @HexValues = ("0","1","2","3","4","5","6","7","8","9","10","11",
					"12","13","14","15","A","B","C","D","E","F");
	
	if (!(uc($CheckValue) ~~ @HexValues))
	{
		return (0);
	}
	
	return (1);
}	

1