


VEHICLE 				= {};

VEHICLE.ID 				= 'C';
VEHICLE.FID				= '33';

VEHICLE.Name 			= "Oracle";
VEHICLE.Make 			= "Ubermacht";
VEHICLE.Model 			= "Oracle XS";

VEHICLE.Script 			= "oracle";

VEHICLE.Cost 			= 160000;
VEHICLE.PaintJobCost 	= 7000;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = nil;

VEHICLE.PaintJobs = {
						{model = 'models/sickness/oracledr.mdl', skin = '0', name = 'Black', color = Color(0, 0, 0, 255)},
						{model = 'models/sickness/oracledr.mdl', skin = '1', name = 'White', color = Color(255, 250, 250, 255)},
						{model = 'models/sickness/oracledr.mdl', skin = '2', name = 'Red', color = Color(205, 51, 51, 255)},
						{model = 'models/sickness/oracledr.mdl', skin = '3', name = 'Green', color = Color(0, 100, 0, 255)},
						{model = 'models/sickness/oracledr.mdl', skin = '4', name = 'Dark Blue', color = Color(0, 0, 128, 255)},
						{model = 'models/sickness/oracledr.mdl', skin = '5', name = 'Blood Red', color = Color(142, 35, 35, 255)},
						{model = 'models/sickness/oracledr.mdl', skin = '6', name = 'Purple', color = Color(104, 34, 139, 255)},
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(16, 4, 13), Angle(0, 0, 10)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-72.3996, -6.1857, 1.8621),
								Vector(72.3996, -0.1439, 0.3239),
							};
							
VEHICLE.DefaultIceFriction = .5;
							
VEHICLE.PlayerReposition_Pos = Vector(-16, -15, 18);
VEHICLE.PlayerReposition_Ang = Angle(0, 90, 0);

VEHICLE.ViewAdjustments_FirstPerson = Vector(0, 0, 5);
VEHICLE.ViewAdjustments_ThirdPerson = nil;

VEHICLE.RequiredClass 	= nil;

VEHICLE.PaintText = "Of course! A great german car!";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(-31.4999, 98.5857, 31.4159), 	Angle(20, 0, 0)};
									{Vector(31.4999, 98.5857, 31.4159), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(18.6511, -92.8365, 31.6970), 	Angle(20, -180, 0)};
									{Vector(-18.6511, -92.8365, 31.6970), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};

VEHICLE.Exhaust = { 
									{Vector(25.8404, -101.9634, 16.0662), Angle(0, 0, 80)},
									{Vector(-25.8404, -101.9634, 16.0662), Angle(0, 0, 80)},
						}
						
VEHICLE.RevvingSound		= "vehicles/shelby/shelby_rev_short_loop1.wav";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);