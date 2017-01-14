package Traveller::Common;

use Traveller::Names;
use strict;
use Exporter;
use warnings;

use MyCoreFunctions;

use Traveller::Scores;

# Specify shared names here
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
$VERSION = 1.00;
@ISA = qw(Exporter);

# @EXPORT - Everything automatically exported
@EXPORT = qw(@CoreAbilities PrintScores
			 PrintTable PrintSkills GetCascadeSkill Pause GenScores $AUTO_GENERATION
			 ProcessSkill @CascadeSkills $PRINT_HISTORY
			 @SkillGroupLists %CascadeIndex @GunCombat @Vehicle @BladeCombat
			 @SpaceVehicle @Groundcraft @Watercraft @Aircraft @Book1Guns @Book4Guns @Services
			 DetermineService ResolveTerm ResolveSkills
			 Enlist Survived CommissionReceived Promoted Reenlist
			 Benefit_Rolls AgeCheck ShowSkillTables Get_AST_Skill
			 ResolveAging ServiceSkills
			 GetRank GetTerms Commissioned Drafted
			 Commission Promote NewTerm GetCharID
			 GetStat PlusStat MinusStat Dead StatCode StillServing
			 GetSkill GetService Add2Resume Kill SaveScores newCharacter PrintCharacter 
			 PrintMusterTables MusterOut
			 );

# @EXPORT_OK - Items available for export
@EXPORT_OK = ();

# %EXPORT_TAGS - Build sets of exported names
%EXPORT_TAGS = ();

# exported package globals go here
# not used in this case

# Commond Data - Variable, Lists & Data Structures (Hashes)

our $AUTO_GENERATION=1;	# Automatic Generation by Default

our $PRINT_HISTORY=0;

our @Services = ("Navy","Marines","Army","Scouts","Merchants","Other");

our @CascadeSkills = ("Gun Combat","Vehicle","Blade Combat","Watercraft","Aircraft",
					 "Groundcraft","SpaceVehicle","Space");

my %Ranks = (
			Navy => 	{
						0 => "",
						1 => "Ensign",
						2 => "Lieutenant",
						3 => "Lt Cmdr",
						4 => "Commander",
						5 => "Captain",
						6 => "Admiral"
						},
			Marines =>	{
						0 => "",
						1 => "Lieutenant",
						2 => "Captain",
						3 => "Force Cmdr",
						4 => "Lt Colonel",
						5 => "Colonel",
						6 => "Brigadier"
						},
			Army => 	{
						0 => "",
						1 => "Lieutenant",
						2 => "Captain",
						3 => "Major",
						4 => "Lt Colonel",
						5 => "Colonel",
						6 => "General"
						},
			Scouts => 	{
						0 => ""
						},
			Other => 	{
						0 => ""
						},
			Merchants => {
						0 => "",
						1 => "4th Officer",
						2 => "3rd Officer",
						3 => "2nd Officer",
						4 => "1st Officer",
						5 => "Captain",
						6 => "Commodore"
						}
			);
					 
# NOTE Further define @Gunnery and @Space

our %CascadeIndex;

our @Space = ();

our @Book1Guns = ("Body Pistol","Automatic Pistol","Revolver","Carbine","Rifle","Laser Carbine",
				  "Laser Rifle","Automatic Rifle","Submachine Gun","Shotgun");

our @Book4Guns = ("Carbine","Shotgun","Rifle","Handgun","Combat Rifleman","Pistol",
				 "Submachinegun", "Laser Weapons","Zero-G Weapons","High Energy Weapons","Auto Weapons");

our @GunCombat = @Book1Guns;

our @Vehicle = ("Aircraft","Watercraft","Groundcraft","Space Vehicle");

our @BladeCombat = ("Dagger","Blade","Foil","Cutlass","Sword","Broadsword","Spear",
					"Halberd","Pike","Cudgel","Bayonet");

our @SpaceVehicle = ("Ship's Boat","Vacc Suit");

our @Groundcraft = ("Wheeled","Tracked","Grav");

our @Watercraft = ("Large Watercraft","Hovercraft","Small Watercraft","Submersible");

our @Aircraft = ("Propeller Aircraft","Jet Aircraft","Helicopter","Lighter-than-Air Craft");

our @SkillGroupLists = (\@GunCombat,\@Vehicle,\@BladeCombat,\@Watercraft,\@Aircraft,
						\@Groundcraft,\@SpaceVehicle,\@Space);

our @CoreAbilities = ("STR","DEX","END","INT","EDU","SOC");

our @PersonalData = ("Date Created","First Name","Last Name","UPP","Noble Title","Military Rank",
				   "Birthdate","Age Modifiers","Birthworld");

our @ServiceHistory = ("Service","Branch","Discharge World","Terms Served","Final Rank","Retired",
					   "Retirement Party","Special Assignments","Awards","Decorations","Equipment",
					   "Primary Skill","Secondary Skill","Additional Skills","Preferred Weapon",
					   "Preferred Pistol","Preferred Blade","Travellers' Member");

our @PsionicsData = ("Date of Test","PSR","Trained","Date Completed","Talents and Levels");

my %PST = (
			"Navy" => {
						"Enlist" 		=>  8,
						"DM1_Attr" 		=> "INT",
						"DM1_Stat" 		=>  8,
						"DM2_Attr" 		=> "EDU",
						"DM2_Stat" 		=>  9,
			
						"Survival"		=>  5,
						"Surv_DM2_Attr"	=> "INT",
						"Surv_DM2_Stat"	=>  7,
						
						"Commmission"	=> 10,
						"Comm_DM2_Attr"	=> "SOC",
						"Comm_DM2_Stat"	=>	9,
						
						"Promotion"		=>  8,
						"Prom_DM2_Attr"	=> "EDU",
						"Prom_DM2_Stat"	=>	8,
						
						"Reenlist"		=>	6
					  },
					  
			"Marines" => {
						"Enlist" 		=>  9,
						"DM1_Attr" 		=> "INT",
						"DM1_Stat" 		=>  8,
						"DM2_Attr" 		=> "STR",
						"DM2_Stat" 		=>  8,
			
						"Survival"		=>  6,
						"Surv_DM2_Attr"	=> "END",
						"Surv_DM2_Stat"	=>  8,
						
						"Commmission"	=>  9,
						"Comm_DM2_Attr"	=> "EDU",
						"Comm_DM2_Stat"	=>	7,
						
						"Promotion"		=>  9,
						"Prom_DM2_Attr"	=> "SOC",
						"Prom_DM2_Stat"	=>	8,
						
						"Reenlist"		=>	6
					  },					  
					  
			"Army" => {
						"Enlist" 		=>  5,
						"DM1_Attr" 		=> "DEX",
						"DM1_Stat" 		=>  6,
						"DM2_Attr" 		=> "END",
						"DM2_Stat" 		=>  5,
			
						"Survival"		=>  5,
						"Surv_DM2_Attr"	=> "EDU",
						"Surv_DM2_Stat"	=>  6,
						
						"Commmission"	=> 5,
						"Comm_DM2_Attr"	=> "EDU",
						"Comm_DM2_Stat"	=>	7,
						
						"Promotion"		=>  6,
						"Prom_DM2_Attr"	=> "EDU",
						"Prom_DM2_Stat"	=>	7,
						
						"Reenlist"		=>	7
					  },					 
					  
			"Scouts" => {
						"Enlist" 		=>  7,
						"DM1_Attr" 		=> "INT",
						"DM1_Stat" 		=>  6,
						"DM2_Attr" 		=> "STR",
						"DM2_Stat" 		=>  8,
			
						"Survival"		=>  7,
						"Surv_DM2_Attr"	=> "END",
						"Surv_DM2_Stat"	=>  9,
						
						"Commmission"	=>  0,
						"Comm_DM2_Attr"	=> "N/A",
						"Comm_DM2_Stat"	=>	0,
						
						"Promotion"		=>  0,
						"Prom_DM2_Attr"	=> "N/A",
						"Prom_DM2_Stat"	=>	0,
						
						"Reenlist"		=>	3
					  },

			"Merchants" => {
						"Enlist" 		=>  7,
						"DM1_Attr" 		=> "STR",
						"DM1_Stat" 		=>  7,
						"DM2_Attr" 		=> "INT",
						"DM2_Stat" 		=>  6,
			
						"Survival"		=>  5,
						"Surv_DM2_Attr"	=> "INT",
						"Surv_DM2_Stat"	=>  7,
						
						"Commmission"	=>  4,
						"Comm_DM2_Attr"	=> "INT",
						"Comm_DM2_Stat"	=>	6,
						
						"Promotion"		=> 10,
						"Prom_DM2_Attr"	=> "INT",
						"Prom_DM2_Stat"	=>	9,
						
						"Reenlist"		=>	3
					  },
					  
			"Other" => {
						"Enlist" 		=>  3,
						"DM1_Attr" 		=> "N/A",
						"DM1_Stat" 		=>  0,
						"DM2_Attr" 		=> "N/A",
						"DM2_Stat" 		=>  0,
			
						"Survival"		=>  5,
						"Surv_DM2_Attr"	=> "INT",
						"Surv_DM2_Stat"	=>  9,
						
						"Commmission"	=>  0,
						"Comm_DM2_Attr"	=> "N/A",
						"Comm_DM2_Stat"	=>	0,
						
						"Promotion"		=>  0,
						"Prom_DM2_Attr"	=> "N/A",
						"Prom_DM2_Stat"	=>	0,
						
						"Reenlist"		=>	5
					  },
			);

my %AcquiredSkillTables = (
		PDT => {
			Navy => {
				"1" => "+1 STR",
				"2" => "+1 DEX",
				"3" => "+1 END",
				"4" => "+1 INT",
				"5" => "+1 EDU",
				"6" => "+1 SOC"
				},
			Marines => {
				"1" => "+1 STR",
				"2" => "+1 DEX",
				"3" => "+1 END",
				"4" => "Gambling",
				"5" => "Brawling",
				"6" => "Blade Combat"
				},
			Army => {
				"1" => "+1 STR",
				"2" => "+1 DEX",
				"3" => "+1 END",
				"4" => "Gambling",
				"5" => "+1 EDU",
				"6" => "Brawling"
				},
			Scouts => {
				"1" => "+1 STR",
				"2" => "+1 DEX",
				"3" => "+1 END",
				"4" => "+1 INT",
				"5" => "+1 EDU",
				"6" => "Gun Combat"
				},
			Merchants => {
				"1" => "+1 STR",
				"2" => "+1 DEX",
				"3" => "+1 END",
				"4" => "+1 STR",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
			Other => {
				"1" => "+1 STR",
				"2" => "+1 DEX",
				"3" => "+1 END",
				"4" => "Blade Combat",
				"5" => "Brawling",
				"6" => "-1 SOC"
				},
		},
		SST => {
			Navy => {
				"1" => "Ship's Boat",
				"2" => "Vacc Suit",
				"3" => "Fwd Obs",
				"4" => "Gunnery",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
			Marines => {
				"1" => "Vehicle",
				"2" => "Vacc Suit",
				"3" => "Blade Combat",
				"4" => "Gun Combat",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
			Army => {
				"1" => "Vehicle",
				"2" => "Air/Raft",
				"3" => "Gun Combat",
				"4" => "Fwd Obs",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
			Scouts => {
				"1" => "Vehicle",
				"2" => "Vacc Suit",
				"3" => "Mechanical",
				"4" => "Navigation",
				"5" => "Electronic",
				"6" => "Jack-o-T"
				},
			Merchants => {
				"1" => "Vehicle",
				"2" => "Vacc Suit",
				"3" => "Jack-o-T",
				"4" => "Steward",
				"5" => "Electronic",
				"6" => "Gun Combat"
				},
			Other => {
				"1" => "Vehicle",
				"2" => "Gambling",
				"3" => "Brawling",
				"4" => "Bribery",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
		},
		AET => {
			Navy => {
				"1" => "Vacc Suit",
				"2" => "Mechanical",
				"3" => "Electronic",
				"4" => "Engineering",
				"5" => "Gunnery",
				"6" => "Jack-o-T"
				},
			Marines => {
				"1" => "Vehicle",
				"2" => "Mechanical",
				"3" => "Electronic",
				"4" => "Tactics",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
			Army => {
				"1" => "Vehicle",
				"2" => "Mechanical",
				"3" => "Electronic",
				"4" => "Tactics",
				"5" => "Blade Combat",
				"6" => "Gun Combat"
				},
			Scouts => {
				"1" => "Vehicle",
				"2" => "Mechanical",
				"3" => "Electronic",
				"4" => "Jack-o-T",
				"5" => "Gunnery",
				"6" => "Medical"
				},
			Merchants => {
				"1" => "Streetwise",
				"2" => "Mechanical",
				"3" => "Electronic",
				"4" => "Navigation",
				"5" => "Gunnery",
				"6" => "Medical"
				},
			Other => {
				"1" => "Streetwise",
				"2" => "Mechanical",
				"3" => "Electronic",
				"4" => "Gambling",
				"5" => "Brawling",
				"6" => "Forgery"
				},
		},
		AET2 => {
			Navy => {
				"1" => "Medical",
				"2" => "Navigation",
				"3" => "Engineering",
				"4" => "Computer",
				"5" => "Pilot",
				"6" => "Admin"
				},
			Marines => {
				"1" => "Medical",
				"2" => "Tactics",
				"3" => "Tactics",
				"4" => "Computer",
				"5" => "Leader",
				"6" => "Admin"
				},
			Army => {
				"1" => "Medical",
				"2" => "Tactics",
				"3" => "Tactics",
				"4" => "Computer",
				"5" => "Leader",
				"6" => "Admin"
				},
			Scouts => {
				"1" => "Medical",
				"2" => "Navigation",
				"3" => "Engineering",
				"4" => "Computer",
				"5" => "Pilot",
				"6" => "Jack-o-T"
				},
			Merchants => {
				"1" => "Medical",
				"2" => "Navigation",
				"3" => "Engineering",
				"4" => "Computer",
				"5" => "Pilot",
				"6" => "Admin"
				},
			Other => {
				"1" => "Medical",
				"2" => "Forgery",
				"3" => "Electronic",
				"4" => "Computer",
				"5" => "Streetwise",
				"6" => "Jack-o-T"
				},
		},
	);			

my %MusterTable = (
          'Table 1' => {
						 'Name'  => "Material Benefits",
                         'Other' => {
                                      '6' => '- -',
                                      '4' => 'Gun',
                                      '1' => 'Low Psg',
                                      '3' => '+1 EDU',
                                      '7' => '- -',
                                      '2' => '+1 INT',
                                      '5' => 'High Psg'
                                    },
                         'Merchants' => {
                                          '6' => 'Low Psg',
                                          '4' => 'Gun',
                                          '1' => 'Low Psg',
                                          '3' => '+1 EDU',
                                          '7' => 'Merchant',
                                          '2' => '+1 INT',
                                          '5' => 'Blade'
                                        },
                         'Scouts' => {
                                       '6' => 'Scout',
                                       '4' => 'Blade',
                                       '1' => 'Low Psg',
                                       '3' => '+2 EDU',
                                       '7' => '- -',
                                       '2' => '+2 INT',
                                       '5' => 'Gun'
                                     },
                         'Army' => {
                                     '6' => 'Mid Psg',
                                     '4' => 'Gun',
                                     '1' => 'Low Psg',
                                     '3' => '+2 EDU',
                                     '7' => '+1 SOC',
                                     '2' => '+1 INT',
                                     '5' => 'High Psg'
                                   },
                         'Marines' => {
                                        '6' => 'High Psg',
                                        '4' => 'Blade',
                                        '1' => 'Low Psg',
                                        '3' => '+1 EDU',
                                        '7' => '+2 SOC',
                                        '2' => '+2 INT',
                                        '5' => 'Travellers Aid Society'
                                      },
                         'Navy' => {
                                     '6' => 'High Psg',
                                     '4' => 'Blade',
                                     '1' => 'Low Psg',
                                     '3' => '+2 EDU',
                                     '7' => '+2 SOC',
                                     '2' => '+1 INT',
                                     '5' => 'Travellers Aid Society'
                                   }
                       },
          'Table 2' => {
						 'Name'  => "Cash Allowances",		  
                         'Other' => {
                                      '6' => '50000',
                                      '4' => '10000',
                                      '1' => '1000',
                                      '3' => '10000',
                                      '7' => '100000',
                                      '2' => '5000',
                                      '5' => '10000'
                                    },
                         'Merchants' => {
                                          '6' => '40000',
                                          '4' => '20000',
                                          '1' => '1000',
                                          '3' => '10000',
                                          '7' => '40000',
                                          '2' => '5000',
                                          '5' => '20000'
                                        },
                         'Scouts' => {
                                       '6' => '50000',
                                       '4' => '30000',
                                       '1' => '20000',
                                       '3' => '30000',
                                       '7' => '50000',
                                       '2' => '20000',
                                       '5' => '50000'
                                     },
                         'Army' => {
                                     '6' => '20000',
                                     '4' => '10000',
                                     '1' => '2000',
                                     '3' => '10000',
                                     '7' => '30000',
                                     '2' => '5000',
                                     '5' => '10000'
                                   },
                         'Marines' => {
                                        '6' => '30000',
                                        '4' => '10000',
                                        '1' => '2000',
                                        '3' => '5000',
                                        '7' => '40000',
                                        '2' => '5000',
                                        '5' => '20000'
                                      },
                         'Navy' => {
                                     '6' => '50000',
                                     '4' => '10000',
                                     '1' => '1000',
                                     '3' => '5000',
                                     '7' => '50000',
                                     '2' => '5000',
                                     '5' => '20000'
                                   }
                       }
        );

sub MusterRolls
{
	my ($Hero) = @_;
	
	my $Rolls = GetTerms($Hero);
	my $Rank = GetRank ($Hero);

	if ($Rank > 4)
	{
		$Rolls += 2;		# Rank 5 or 6 or higher is allowed three extra rolls
	}
	if ($Rank > 2)
	{
		$Rolls += 2;		# Rank 3 or 4 is allowed two extra rolls
	}
	elsif ($Rank > 0)
	{
		$Rolls++;			# Rank 1 or 2 is allowed one extra roll
	}

	return $Rolls;
}

sub CalculateRetirementPay
{
	my ($Hero) = @_;
	$Hero->{RetirementPay} = 0;
	if ((GetService($Hero) ne "Scouts") && (GetService($Hero) ne "Other"))
	{
		if ($Hero->{Terms} > 4)
		{
			$Hero->{RetirementPay} = 4000 + ($Hero->{Terms} - 5) * 2000;
			Add2Resume($Hero,"Earned $Hero->{RetirementPay} annual retirement pay");
		}
	}
}

sub MusterOut
{
	my ($Hero) = @_;
	my $Table;
	my $Service = GetService($Hero);
	my $DM;
	my $ShipReceived = 0;
	my $TAS = 0;
	my $GunReceived = "";
	my $BladeReceived = "";
	if ($Hero->{Retired})
	{
		Add2Resume($Hero,"Retired");
	}
	CalculateRetirementPay($Hero);
	Add2Resume($Hero,"Mustered Out");
	for (my $Roll=1; $Roll <= MusterRolls($Hero); $Roll++)
	{
		$DM = 0;
		if (!$AUTO_GENERATION)
		{ # Figure this out later
			# Show tables, pick Benefits or Cash
		}
		
		my @Tables = ("Table 1","Table 2");
		$Table = Pick(@Tables);
		
		if ($Hero->{MusterOut}{CashRolls} > 2)
		{
			$Table = "Table 1";
		}
		if ($Hero->{Rank} > 4 && $Table eq "Table 1")
		{
			$DM = 1;
		}
		if (defined($Hero->{Skills}{Gambling}))
		{
			if (($Hero->{Skills}{Gambling} > 0) && $Table eq "Table 2")
			{
				$DM = 1;
			}
		}
		my $DieRoll = RollDice(1,6) + $DM;
		
		my $Result = $MusterTable{$Table}{$Service}{$DieRoll};
		
		if ($Table eq "Table 1")
		{
			if ($Result =~ /^(\+1\s)(\w{3})/)		# +1 Attribute
			{
				PlusStat($Hero,$2);
			}		
			elsif ($Result =~ /^(\+2\s)(\w{3})/)	# +2 Attribute
			{
				PlusStat($Hero,$2);
				PlusStat($Hero,$2);
			}		
			elsif ($Result eq "Merchant")
			{
				if ($ShipReceived)
				{
					$Hero->{Debt} -= 25;  # Owe 25% less for each add'l result
				}
				else
				{
					$Hero->{Ship} = "Ship - Free Trader (Type A)";
					$Hero->{Debt} = 100;
					$Hero->{Equipment}{'Ship - Free Trader (Type A)'} = 1;					
					$ShipReceived = 1;
				}
			}
			elsif ($Result eq "Scout")
			{
				if ($ShipReceived)
				{
					$Result .= " (wasted)";
				}
				else
				{
					$Hero->{Ship} = "Scout/Courier (Type S)";
					$Hero->{Equipment}{'Scout/Courier (Type S)'} = 1;
					$ShipReceived = 1;
				}
			}
			elsif ($Result eq "Gun")
			{
				if ($GunReceived)
				{
					GainSkill($Hero,$GunReceived);
					$Result .= ": +1 $GunReceived";
				}
				else
				{	
					$GunReceived = Pick(@Book1Guns);
					$Result .= ": $GunReceived";
					$Hero->{Equipment}{$GunReceived} = 1;
				}
			}
			elsif ($Result eq "Blade")
			{
				if ($BladeReceived)
				{
					GainSkill($Hero,$BladeReceived);
					$Result .= ": +1 $BladeReceived";
				}
				else
				{	
					$BladeReceived = Pick(@BladeCombat);
					$Result .= ": $BladeReceived";
					$Hero->{Equipment}{$BladeReceived} = 1;
				}
			}
			elsif ($Result eq "Travellers Aid Society")
			{
				if (!(defined($Hero->{TAS})))
				{
					$Hero->{TAS} = 1;
				}
				else
				{
					$Result .= " (wasted)";
				}
			}
			else
			{
				$Hero->{Tickets}{$Result}++;		# Should only be tickets
			}
			
			$Hero->{MusterOut}{BenefitRolls}++;
		}
		else
		{
			$Hero->{Cash} += $Result;
			$Hero->{MusterOut}{CashRolls}++;			
		}
		$Hero->{MusterOut}{"Roll ".$Roll} = $Result;		
		Add2Resume($Hero,"  $Result");
	}
	
}

sub GetCharID
{
	my ($Hero) = @_;
	return $Hero->{CharID};
}

sub PrintMusterTables
{
	my ($Hero) = @_;
	my $Service = GetService($Hero);
	my $Align;
	
	foreach my $Table ("Table 1", "Table 2")
	{
		print "\n$Table, ",$MusterTable{$Table}{Name},", $Service\n\n";
		if ($Table eq "Table 1")
		{
			$Align="RIGHT";
		}
		else
		{
			$Align="LEFT";
		}
		for (my $Result=1; $Result < 8; $Result++)
		{
			print "$Result  ";
			PrintField (6,$MusterTable{$Table}{$Service}{$Result},"\n",$Align);
		}
	}

}		

sub PrintAllMusteringTables
{
	foreach my $Table ("Table 1", "Table 2")
	{
		print "$Table, ",$MusterTable{$Table}{Name},"\n\t";
		foreach my $Service (@Services)
		{
			print "$Service\t";
		}
		print "\n";
		
		for (my $Result=1; $Result < 8; $Result++)
		{
			print "$Result\t";
			foreach my $Service (@Services)
			{
				print "$MusterTable{$Table}{$Service}{$Result}\t";
			}
			print "\n";
		}
	}
}
	
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
	return $_Hero->{Service}{Service};
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
	$_Hero->{SkillsGained} = 1; 			# Gain 1 for each term
	if ($CurTerm == 1)
	{
		$_Hero->{SkillsGained}++;		# Extra skill for 1st term
	}
	$_Hero->{TotalSkills} += $_Hero->{SkillsGained};
	
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

sub Dead 
{
	my ($_Hero) = @_;
	return $_Hero->{Died};
}

sub Promote
{
	my ($_Hero) = @_;
	$_Hero->{Rank}++;
	$_Hero->{SkillsGained}++;	
	$_Hero->{TotalSkills}++;
	$_Hero->{RankTitle} = $Ranks{$_Hero->{Service}{Service}}{$_Hero->{Rank}};
	Add2Resume ($_Hero,"Promoted to Rank $_Hero->{Rank} ($_Hero->{RankTitle})");
	RankSkills($_Hero);
}

sub Add2Resume
{
	my ($_Hero,$Event) = @_;
	my $TermID = "Term".$_Hero->{Term};	
	push @{$_Hero->{$TermID}}, $Event;	
}

sub Commission
{
	my ($_Hero) = @_;
	$_Hero->{Commissioned} = 1;
	Add2Resume ($_Hero,"Commissioned");	
	Promote($_Hero);
}

sub ResolveSkills
{
	my ($_Hero) = @_;
	for (my $ctr=0; $ctr < $_Hero->{SkillsGained}; $ctr++)
	{
		RollSkill($_Hero);
	}
}

sub PlusStat 
{
	my ($_Hero,$_Attribute) = @_;
	
	if ($_Hero->{Scores}{$_Attribute} < 15)
	{
		return $_Hero->{Scores}{$_Attribute}++;
	}
}

sub MinusStat 
{
	my ($_Hero,$_Attribute) = @_;
	if ($_Hero->{Scores}{$_Attribute} == 1)
	{
		Add2Resume ($_Hero,"$_Attribute reduced to 0.");
		if (RollDice(2,6) >= 8)
		{
			$_Hero->{Wounded}++;
			Add2Resume ($_Hero,"Passed saving throw. Wounded, $_Attribute restored to 1");
			return $_Hero->{Scores}{$_Attribute};			
		}
		else
		{
			$_Hero->{Died} = 1;
			Add2Resume ($_Hero,"Failed saving throw. Died due to stat loss");
			return $_Hero->{Scores}{$_Attribute}--;	
		}
	}
	else
	{
		return $_Hero->{Scores}{$_Attribute}--;
	}
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

sub GainSkill
{
	my ($Hero,$Skill) = @_;
	$Hero->{Skills}{$Skill}++;
}

sub newCharacter
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
		
	#chomp(my $_DC = `DATE T`);
  (my $Second, my $Minute, my $Hour, my $Day, my $Month, my $Year, my $WeekDay, my $DayOfYear, my $IsDST) = localtime(time);
  
  my $realmonth = $Month+1;
  my $realday = $Day;

  my $stram;
  if ($Hour > 11 )
  {
    $stram = "pm";
  }
  else
  {
    $stram = "am";
  }

  if ($Hour == 0)
  {
    $Hour = $Hour + 12;
  }
  if ($Hour > 12)
  {
    $Hour = $Hour - 12;
    $Hour = '0' . $Hour;
  }
  if ($Minute < 10)
  {
  	$Minute = "0" . $Minute;
  }
  if ($Second < 10)
  {
  	$Second = "0" . $Second;
  }

  if ($Day < 10)
  {
  	$realday = "0" . $realday;
  }

  if ($realmonth < 10)
  {
  	$realmonth = "0". $realmonth;
  }

  my $realyear = $Year + 1900;
  
  my @days = qw/Mon Tue Wed Thur Fri Sat Sun/;
  
  my $realweekday = $days[$WeekDay];

  
  my $_DC = $realweekday . ' ' . $realday . '/' . $realmonth . '/' . $realyear;


	my $_DateID = substr ($_DC,4,2) . substr ($_DC,7,2) . substr ($_DC,10,4);
	
	#print "$_DC\n $_DateID\n";
	#exit 0;
	
	#chomp(my $_TC = `time /T`);
	my $_TC = $Hour . ':' . $Minute . ' ' . $stram;
	
	my $_TimeID = substr($_TC,0,2).substr($_TC,3,2);	
	
	my $_RandomID = int(rand(10000));

	my $_CharID = $_DateID.$_TimeID.$_RandomID;

	my $self =	{
				CharID		=> $_CharID,
				DateCreated => $_DC,
				TimeCreated => $_TC,
				Name 			=>	{
									Title =>	"",
									First =>	$fname,
									Last  =>	$lname
									},
				MusterOut 		=> {
									CashRolls => 0,
									BenefitRolls => 0
									},
				Term0			=> ["Term 0 Events"],
				Skills 			=> {},
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
				Term			=> 0,		# Current Term
				Rank			=> 0,		# Rank (1-6, Book 1 Rank)
				RankTitle		=> "",		# No initial title
				ForcedOut		=> 0,		# 1 = Forced out (failed to reenlist)
				TotalSkills		=> 0,		# Total Skill Rolls
				ForcedService	=> 0,		# Mandatory reenlistment (Rolled a 12)			
				Cash			=> 0		# Cash on hand
				};
			
	return $self;
}

sub StatCode
{
	my ($Value) = @_;
	my @StatArray = qw(0 1 2 3 4 5 6 7 8 9 A B C D E F);
	return $StatArray[$Value];
}

sub StillServing
{
	my ($Hero) = @_;
	return (!$Hero->{Died} && !$Hero->{ForcedOut} && !$Hero->{Retired});
}

sub RankSkills
{
	my ($Hero) = @_;
	
	my $Service = $Hero->{Service}{Service};
	my $RankTitle = $Hero->{RankTitle};
	
	if ($Service eq "Marines" && $RankTitle eq "Lieutenant")
	{
		GainSkill($Hero,"Revolver");
		Add2Resume($Hero,"Gained service rank skill: Revolver");
	}
	elsif  ($Service eq "Army" && $RankTitle eq "Lieutenant")
	{
		GainSkill($Hero,"Submachinegun");
		Add2Resume($Hero,"RankSkills: Gained service rank skill: Submachinegun");
	}
	elsif  ($Service eq "Merchants" && $RankTitle eq "1st Officer")	
	{
		GainSkill($Hero,"Pilot");
		Add2Resume($Hero,"Gained service rank skill: Pilot");
	}
	elsif  ($Service eq "Navy")	
	{
		if ($RankTitle eq "Captain")
		{
			PlusStat($Hero,"SOC");
			Add2Resume($Hero,"Gained service rank bonus: +1 SOC");
		}
		elsif ($RankTitle eq "Admiral")
		{
			PlusStat($Hero,"SOC");
			Add2Resume($Hero,"Gained service rank bonus: +1 SOC");
		}
	}
}

sub ServiceSkills
{
	my ($Hero) = @_;
	
	my $Service = $Hero->{Service}{Service};
	
	if ($Service eq "Marines")
	{
		GainSkill($Hero,"Cutlass");
		Add2Resume($Hero,"Gained service skill: Cutlass");
	}
	elsif  ($Service eq "Army")
	{
		GainSkill($Hero,"Rifle");
		Add2Resume($Hero,"ServiceSkills: Gained service skill: Rifle");
	}
	elsif  ($Service eq "Scouts")	
	{
		GainSkill($Hero,"Pilot");
		Add2Resume($Hero,"Gained service skill: Pilot");
	}
}

sub ResolveTerm # $Hero
{
	my ($Hero) = @_;
	NewTerm($Hero);

	# Determine Survival
	if (!Survived($Hero))
	{ # Character Died
		Kill($Hero);
	}
	else
	{
		# Check Commissioning
		
		if (!Commissioned($Hero))
		{
			if (CommissionReceived($Hero))
			{
				Commission($Hero);
			}
		}
		# Check for Promotion
		
		if (Commissioned($Hero))
		{
			if (Promoted($Hero))
			{
				Promote($Hero);
			}
		}
		
		# Determine Skills
		
		ResolveSkills($Hero);
		
		# Determine Aging Effects
		
		ResolveAging($Hero);

		# Attempt to Reenlist
		
		Reenlist($Hero);
	}
}

sub DetermineService # $Hero
{
	my ($Hero) = @_;
	my $Service;

	if ($AUTO_GENERATION)
	{
		$Service = Pick(@Services);
	}
	else
	{
		$Service = $Services[MenuChoice("Select your desired branch of service: ","Branches of Service",@Services)];
	}

	$Hero->{Service} = { Desired => $Service,
						 Service => ""
						};
						
	if (!Enlist($Hero,$Service))
	{
		$Hero->{Drafted} = 1;
		$Service = Pick(@Services);
	}
	else
	{
		$Hero->{Drafted} = 0;
	}
	
	$Hero->{Service}{Service} = $Service;
}

# GetCascadeSkill
#	Input: List of skills
#	Output: Skill to train

sub GetCascadeSkill
{
	my ($Hero,@SkillList) = @_;
	my $SwitchThreshold = 3;
	my $RandomSkill = "";
	if (my $TrainedSkill=AnyTrained(@SkillList))
	{ # Have a skill in that set
		if ($Hero->{Skills}{$TrainedSkill}<$SwitchThreshold)
		{ # continue training same skill unless already at threshold
			$RandomSkill = $TrainedSkill;
		}
		else
		{ # pick a random skill from that group
			$RandomSkill = $SkillList[int(rand(@SkillList))];
		}
	}
	else
	{ # pick a random skill
		$RandomSkill = $SkillList[int(rand(@SkillList))];
	}
	return ($RandomSkill);
}

sub PrintScores	# CharacterRef
{
	my ($_Hero) = @_;
	
	foreach (@CoreAbilities)
	{
		print "\t$_: ".$_Hero->{Scores}{$_}."\n";
	}
}

sub PrintSkills	# CharacterRef
{
	my ($_Hero) = @_;
	
	my %Skills = %{$_Hero->{Skills}};
	my @Keys = sort keys %Skills;
	foreach (@Keys)
	{
		print "\t".$_.": ".$Skills{$_}."\n";
	}
}

sub PrintTable
{
	my (@Table) = @_;
	my $Columns = 6;
	my $Rows = @Table / 6;

	for (my $CurRow=0; $CurRow < $Rows; $CurRow++)
	{
		if (!$CurRow)
		{
			PrintField (" ",5,"");
		}
		else
		{
			PrintField ($CurRow,5,"");
		}

		for (my $CurCol=0; $CurCol<$Columns; $CurCol++)
		{
			PrintField ($Table[$CurCol*$Rows+$CurRow],20,"");
		}
		print "\n";
	}
}



sub RemoveElement
{
	my ($ItemNum,@List) = @_;
	if ($ItemNum == 0)
	{
		@List = @List[1..$#List];
	}
	elsif ($ItemNum == $#List)
	{
		@List = @List[0..$#List-1];
	}
	else
	{
		@List = @List[0..$ItemNum-1,$ItemNum+1..$#List];
	}
	return (@List);
}

sub Max
{
	my (@List) = @_;
	my $Max = 0;
	foreach my $value (@List)
	{
		if ($value > $Max)
		{
			$Max = $value;
		}
	}
	return ($Max);
}

sub Min
{
	my (@List) = @_;
	my $Min = 99999;
	foreach my $value (@List)
	{
		if ($value < $Min)
		{
			$Min = $value;
		}
	}
	return ($Min);
}

sub Average
{
	my (@List) = @_;
	my $total = 0;
	foreach my $value (@List)
	{
		$total += $value;
	}
	return ($total/@List);
}

sub AnyTrained # CharacterRef, SkillList
{
	my ($_Hero,@list) = @_;
	
	my %skills = %{$_Hero->{Skills}};
	
	foreach my $skill (@list)
	{
		if (defined($_Hero->{Skills}{$skill}))
		{
			return ($skill);
		}
	}
	return (0);
}

sub ProcessSkill # CharacterRef, Skill
{
	# Gained Skill, \%skills, \%scores
	my ($_Hero,$SkillGained) = @_;

	
	# my $scores = $_Hero->{Scores};
	# my $skills = $_Hero->{Skills};
	
	if ($SkillGained =~ /^(\+\d\s)(\w{3})/)		# +1 Attribute
	{
		# Debug("Function: Process_Skill","+1 Stat - Before \$2:",$2,"is ",$scores->{$2});
		# $scores->{$2}++;
		# Debug("Function: Process_Skill","+1 Stat - After \$2:",$2,"is ",$scores->{$2});
		# $skills->{$SkillGained}++;  # Increment "+1 Stat" for career tracking

		PlusStat($_Hero,$2);
		Add2Resume($_Hero,"Stat Mod: $SkillGained");
	}
	elsif ($SkillGained =~ /^(\-\d\s)(\w{3})/)	# -1 Attribute
	{
		# Debug("Function: Process_Skill","+1 Stat - Before \$2:",$2,"is ",$scores->{$2});
		# $scores->{$1}--;
		# Debug("Function: Process_Skill","+1 Stat - After \$2:",$2,"is ",$scores->{$2});
		# $skills->{$SkillGained}--;	# Increment "-1 Stat" for career tracking

		MinusStat($_Hero,$2);
		Add2Resume($_Hero,"Stat Mod: $SkillGained");		
	}
	elsif (InList($SkillGained,@CascadeSkills))		# Cascading (Group) Skill
	{
		# Replace with call to GetCascadeSkill later
		# for now determine randomly
		# Debug("Function: Process_Skill","\$SkillGained:",$SkillGained);
		my $SkillListPtr = $CascadeIndex{$SkillGained};

		my @SkillGroup = @{$SkillListPtr};

		my $RandomSkill = Pick(@SkillGroup);

		GainSkill($_Hero,$RandomSkill);
		Add2Resume($_Hero,$RandomSkill);		
	}
	else
	{
		GainSkill($_Hero,$SkillGained);
		Add2Resume($_Hero,$SkillGained);		
	}

 }

 for (my $ctr=0; $ctr < @CascadeSkills; $ctr++)
{
	# e.g CascadeIndex["Gun Combat"] = \@GunCombat
	$CascadeIndex{$CascadeSkills[$ctr]} = $SkillGroupLists[$ctr];
}

sub PrintField
{
	my ($size,$token,$char,$pad) = @_;

	my $StrLen = length($token);
	my $HalfWidth =  int(($size - $StrLen) / 2);
	my $FitsRight = 1;
	if ( ($StrLen + $HalfWidth * 2) != $size)
	{
		$FitsRight = 0;
	}
	if (!defined($pad))		# Default to Center
	{
		$pad = "CENTER";
	}
	if ($pad eq "CENTER")
	{
		print " " x $HalfWidth;
		print $token;
		print " " x $HalfWidth;
		if (!$FitsRight)
		{
			print " ";
		}
	}
	elsif ($pad eq "RIGHT")
	{
		print $token;
		print " " x $HalfWidth;
		print " " x $HalfWidth;	
		if (!$FitsRight)
		{
			print " ";
		}		
	}
	elsif ($pad eq "LEFT")
	{
		print " " x $HalfWidth;
		print " " x $HalfWidth;	
		if (!$FitsRight)
		{
			print " ";
		}		
		print $token;
	}
	else
	{
		die "PrintField Error\n";
	}
	print $char;
}

sub ShowSkillTables # ($Service)
{
	my ($Service) = @_;

	print "$Service\n\n";
	
	PrintField (8,"Roll","");
	PrintField (15,"PDT","");
	PrintField (15,"SST","");
	PrintField (15,"AET","");
	PrintField (15,"AET2 (EDU 8+)","\n\n");

	for (my $ctr=1; $ctr < 7; $ctr++)
	{
		PrintField (8,$ctr,"");
		PrintField (15,$AcquiredSkillTables{PDT}{$Service}{$ctr},"");
		PrintField (15,$AcquiredSkillTables{SST}{$Service}{$ctr},"");
		PrintField (15,$AcquiredSkillTables{AET}{$Service}{$ctr},"");
		PrintField (15,$AcquiredSkillTables{AET2}{$Service}{$ctr},"\n");
	}
}

sub Get_AST_Skill
{
	my ($Hero) = @_;
	
	my $Service = $Hero->{Service}{Service};
	my $EDU_Attr = GetStat($Hero,"EDU");
	
	if (!$AUTO_GENERATION)
	{
		print "\nCurrent Skills\n\n";
		PrintSkills($Hero);
		print "\n";
		ShowSkillTables($Service);
	}
	
	my @Menu = ("PDT","SST","AET");
	
	if ($EDU_Attr >= 8)
	{
		@Menu = (@Menu,"AET2");
	}
	elsif (!$AUTO_GENERATION)
	{
		print "\nEDU only ",GetStat($Hero,"EDU")," so AET2 column not available\n";
	}
	
	my $TableChoice;
	my $Table;
	

	if ($AUTO_GENERATION)
	{
		$Table = Pick(@Menu);
	}
	else
	{
		$TableChoice = MenuChoice("Choose the skill table to roll against: ","Skill Table",@Menu);
		$Table = $Menu[$TableChoice];
	}
	
	my $Skill_Gained = Roll_AST_Skill($Service,$Table,RollDice(1,6));

	
	return ($Skill_Gained);
	
}

sub Roll_AST_Skill
{
	my ($Service,$Table,$Roll) = @_;
	my $_Skill = $AcquiredSkillTables{$Table}{$Service}{$Roll};

	return ($_Skill);
}

sub PrintPST
{
	for my $family ( keys %PST ) {
		print "$family:\n";
		for my $role ( keys %{ $PST{$family} } ) {
			 print "\t$role=$PST{$family}{$role}\n";
		}
		print "\n";
	}
}

sub RollSkill
{
	my ($Hero) = @_;
	my $NewSkill = Get_AST_Skill($Hero);

	ProcessSkill($Hero,$NewSkill);
}

my @PST_Keys = ("Enlist","DM1_Attr","DM1_Stat","DM2_Attr","DM2_Stat","Survival","Surv_DM2_Attr",
			 "Surv_DM2_Stat","Commmission","Comm_DM2_Attr","Comm_DM2_Stat","Promotion",
			 "Prom_DM2_Attr","Prom_DM2_Stat","Reenlist");

sub Enlist	# $Hero, $DesiredService
{
	my ($Hero,$DesiredService) = @_;
	
	my $DM = 0;

	if ($DesiredService ne "Other")
	{
		my $CheckAttr = $PST{$DesiredService}{DM1_Attr};
		my $CheckStat = $PST{$DesiredService}{DM1_Stat};
		my $Attr = GetStat($Hero,$CheckAttr);


		
		if ($Attr >= $CheckStat)
		{
			$DM++;
		}

		$CheckAttr = $PST{$DesiredService}{DM2_Attr};
		$CheckStat = $PST{$DesiredService}{DM2_Stat};
		$Attr = GetStat($Hero,$CheckAttr);		

		
		if ($Attr >= $CheckStat)
		{
			$DM += 2;
		}
	
	}
	my $TargetNumber = $PST{$DesiredService}{Enlist};
	my $RolledNumber = RollDice(2,6) + $DM;

	
	if ($RolledNumber >= $TargetNumber) 
	{
		return (1);
	}
	else
	{
		return (0);
	}
}			 

sub Reenlist	# $Hero
{
	my ($Hero) = @_;
	
	my $DesiredService = GetService($Hero);

	
	my $DM = 0;
	my $TargetNumber = $PST{$DesiredService}{Reenlist};
	my $RolledNumber = RollDice(2,6) + $DM;

	$Hero->{ForcedService} = 0;		# Reset ForcedService flag
	if ($RolledNumber == 12)
	{
		$Hero->{ForcedService} = 1;
		Add2Resume($Hero,"Mandatory reenlistment");
	}
	elsif ($Hero->{Terms} >= 7)
	{
		$Hero->{Retired} = 1;		# Unable to serve past Term 7
		Add2Resume($Hero,"Retired at end of term");
	}
	elsif ($RolledNumber >= $TargetNumber) 
	{
		Add2Resume($Hero,"Successfully reenlisted");
	}
	else
	{
		$Hero->{ForcedOut} = 1;
		Add2Resume($Hero,"Failed to reenlist");
	}
}			 


sub Survived	# $Hero
{
	my ($Hero) = @_;
	
	my $DesiredService = GetService($Hero);
	
	my $DM = 0;



	my $CheckAttr = $PST{$DesiredService}{Surv_DM2_Attr};
	my $CheckStat = $PST{$DesiredService}{Surv_DM2_Stat};
	my $Attr = GetStat($Hero,$CheckAttr);			
	
	if ($Attr >= $CheckStat)
	{
		$DM += 2;
	}

	my $TargetNumber = $PST{$DesiredService}{Survival};
	my $RolledNumber = RollDice(2,6) + $DM;

	if ($RolledNumber >= $TargetNumber) 
	{
		return (1);
	}
	else
	{
		return (0);
	}
}
			 
sub CommissionReceived	# $Hero
{
	my ($Hero) = @_;

	my $DesiredService = GetService($Hero);
	
	my $DM = 0;

	if (!($DesiredService eq "Scouts") && !($DesiredService eq "Other"))
	{
		my $CheckAttr = $PST{$DesiredService}{Comm_DM2_Attr};
		my $CheckStat = $PST{$DesiredService}{Comm_DM2_Stat};
		my $Attr = GetStat($Hero,$CheckAttr);	
		
		if ($Attr >= $CheckStat)
		{
			$DM += 2;
		}
		my $TargetNumber = $PST{$DesiredService}{Commmission};
		my $RolledNumber = RollDice(2,6) + $DM;

		if ($RolledNumber >= $TargetNumber) 
		{
			return (1);
		}
		else
		{
			return (0);
		}
	}
	else
	{
		return (0);  # return 0 if Scouts or Other
	}
}			 
	
sub Promoted	# $Hero
{
	my ($Hero) = @_;
	
	my $DesiredService = GetService($Hero);	
	
	my $DM = 0;

	if (!($DesiredService eq "Scouts") && !($DesiredService eq "Other") && $Hero->{Rank} < 6)
	{
		my $CheckAttr = $PST{$DesiredService}{Prom_DM2_Attr};
		my $CheckStat = $PST{$DesiredService}{Prom_DM2_Stat};
		my $Attr = GetStat($Hero,$CheckAttr);	

		if ($Attr >= $CheckStat)	
		{
			$DM += 2;
		}
		my $TargetNumber = $PST{$DesiredService}{Promotion};
		my $RolledNumber = RollDice(2,6) + $DM;

		if ($RolledNumber >= $TargetNumber) 
		{
			return (1);
		}
		else
		{
			return (0);
		}
	}
	else
	{
		return (0);  # return 0 if Scouts or Other or already Rank 6
	}
}		

sub BenefitRolls # ($Terms, $Rank)
{
	my ($Terms,$Rank) = @_;
	
	return ($Terms + int($Rank/2));
}

sub ResolveAging # $Hero
{
	my ($Hero) = @_;
	
	if ($Hero->{Terms} >= 4)
	{
		foreach my $_Attr (@CoreAbilities)
		{
			my $_Terms = GetTerms($Hero);
			if (my $AgeMod = AgeCheck($_Terms,$_Attr))
			{
				Add2Resume($Hero,$AgeMod." $_Attr due to aging");
				while ($AgeMod < 0)
				{
					MinusStat($Hero,$_Attr);
					$AgeMod++;
				}
			}
		}
	}
}

sub AgeCheck # ($Terms, $Stat)
{
	my ($Terms,$Stat) = @_;
	
	my $StatBase = 2;
	my $Reduction = 0;

	# Assign StatBase and Reduction with DEX as the assumed stat
	if ($Terms < 8)
	{
		$StatBase = 7;
		$Reduction = -1;
	}
	elsif ($Terms < 12)
	{
		$StatBase = 8;
		$Reduction = -1;
	}
	else
	{
		$StatBase = 9;
		$Reduction = -2;
	}

	# Handle the exceptions

	if ($Stat eq "STR")
			{
				if ($Terms < 12)
				{
					$StatBase++;
				}
			}
		elsif ($Stat eq "END")
			{
				if ($Terms < 12)
				{
					$StatBase++;
				}
			}
		elsif ($Stat eq "EDU")
			{ # Never affected by aging
				$Reduction = 0;
				$StatBase = 2;
			}
		elsif ($Stat eq "SOC")
			{ # Never affected by aging
				$Reduction = 0;
				$StatBase = 2;
			}
		elsif ($Stat eq "INT")
			{ # No affect before age 66 (Term 12)
				if ($Terms < 12)
				{
					$StatBase = 2; 	# Automatic Success
					$Reduction = 0;	# No deduction				
				}
				else
				{
					$Reduction++;
				}
			}


	
	if (RollDice(2,6) >= $StatBase)
	{
		return (0);
	}
	else
	{
		return ($Reduction);
	}
}

sub PrintEquipment
{
	my ($Hero) = @_;
	
	print "\n\tCash: \$";
	print $Hero->{Cash};
	print "\n";
	
	if (defined($Hero->{Equipment}))
	{
		my %Equipment = %{$Hero->{Equipment}};
		print "\n\tEquipment\n\n";
		while (my ($key,$value) = each (%Equipment))
		{
			print "\t\t$key: $value\n";
		}
		print "\n";
	}
}

sub PrintCharacter # $Hero
{
	# system "cls";
	my ($Hero) = @_;

	print "\t";
	if ($Hero->{Rank})
	{
		print "$Hero->{RankTitle} ";
	}
	print "$Hero->{Name}{First} $Hero->{Name}{Last} ($Hero->{Gender}) $Hero->{Age} years old\n";
	print "\n";
	print "\tCreated $Hero->{DateCreated}at $Hero->{TimeCreated}\n";
	print "\n";

	if ($Hero->{Drafted})
	{
		print "\tFailed to enlist in the $Hero->{Service}{Desired}\n";
		print "\tDrafted into the $Hero->{Service}{Service}\n";
	}
	else
	{
		print "\tEnlisted in the $Hero->{Service}{Service}\n";	
	}
	print "\n";
	foreach my $_Attr (@CoreAbilities)
	{
		print "\t$_Attr: ",StatCode($Hero->{OriginalScores}{$_Attr}),"  ->  ",StatCode($Hero->{Scores}{$_Attr}),"\n";
	}

	print "\n\tServed $Hero->{Terms} terms in the $Hero->{Service}{Service}";
	
	if (GetRank($Hero) > 0)
	{
		print ", Rank: $Hero->{RankTitle} ($Hero->{Rank})";
	}
	
	print "\n";
	
	print "\n\tStatus: ";
	
	if (Dead($Hero))
	{
		print "DEAD\n";
	}
	elsif ($Hero->{Retired})
	{
		if ($Hero->{ForcedOut})
		{
			print "Forced Retirement"
		}
		else
		{
			print "Retired";
		}
		if ($Hero->{RetirementPay} > 0)
		{
			print " (\$$Hero->{RetirementPay} annually)";
		}
		print "\n";
	}
	elsif ($Hero->{ForcedOut})
	{
		print "Forced Out\n";
	}
	else
	{
		print "Duh! What? Unknown status!\n";
	}
	print "\n\tSkills\n\n";
	
	PrintSkills($Hero);

	PrintEquipment($Hero);
	
	if ($PRINT_HISTORY)
	{
		PrintHistory($Hero);
	}
}

sub PrintHistory
{
	my ($Hero) = @_;
	
	print "\n\tHistory\n";

	for (my $_Term=0; $_Term <= $Hero->{Terms}; $_Term++)
	{ # Print results of each term
		my @_Events = @{$Hero->{"Term".$_Term}};
		foreach (@_Events)
		{
			my $Event = $_;
			if ($_ =~ /Term . Events/)
			{
				print "\n\t$_\n";
			}
			else
			{
				print "\t\t$Event\n";
			}
		}
	}	
}

# Must return true value at end of package

1