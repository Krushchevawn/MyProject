VEHICLE 				= {};

VEHICLE.ID 				= '%';

VEHICLE.Name 			= "Road Services Truck";
VEHICLE.Make 			= "";
VEHICLE.Model 			= "";

VEHICLE.Script 			= "towtruck";

VEHICLE.Cost 			= 0;
VEHICLE.PaintJobCost 	= 0;

VEHICLE.FuelTankSize = 100
VEHICLE.FuelPerMile = 1

VEHICLE.CustomBodyGroup = nil;

VEHICLE.PaintJobs = {
						{model = 'models/sickness/towtruckdr.mdl', skin = '0', name = '', color = Color(0, 0, 0, 255)},
					};
					
//17.9076 29.9254 63.8625

VEHICLE.PassengerSeats 	=	{
								{ Vector( 17, -10, 30 ), Angle(0, 0, 0) },
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-75.2014, 37.7570, 3.5399),
								Vector(75.2014, 37.7570, 3.5399),
							};
							
VEHICLE.DefaultIceFriction = .5;
							
VEHICLE.PlayerReposition_Pos = nil;
VEHICLE.PlayerReposition_Ang = nil;

VEHICLE.ViewAdjustments_FirstPerson = nil;
VEHICLE.ViewAdjustments_ThirdPerson = nil;

VEHICLE.RequiredClass 	= TEAM_ROADSERVICE;

VEHICLE.PaintText = "Tow Truck";

VEHICLE.HornNoise 			= 	"perp2.5/firetruck_horn.mp3";
VEHICLE.HeadlightPositions = {
{Vector(-36, 107, 35), Angle(5, 0, 0)},
{Vector(36, 107, 35), Angle(5, 0, 0)},
};



VEHICLE.TaillightPositions = {
{Vector(-38, -125, 30), Angle(5, -180, 0)},
{Vector(38, -125, 30), Angle(5, -180, 0)},
};

VEHICLE.Exhaust = { 
									{Vector(-41.6607, -39.0256, 12.1740), Angle(0, -80, 80)},
						}

VEHICLE.RevvingSound		= nil;
VEHICLE.SpinoutSound		= nil;

VEHICLE.SirenNoise = Sound("perp2.5/siren_long.mp3");
VEHICLE.SirenNoise_DurMod = 10
VEHICLE.SirenNoise_Alt = nil
VEHICLE.SirenColors = 	{
							{Color(180, 150, 0, 255), Vector(35, -10, 90)},
							{Color(220, 250, 0, 255), Vector(-35, -10, 90)},
						};

GM:RegisterVehicle(VEHICLE);