


VEHICLE 				= {};

VEHICLE.ID 				= 'L';
VEHICLE.FID				= '58';

VEHICLE.Name 			= "Cayenne";
VEHICLE.Make 			= "Porsche";
VEHICLE.Model 			= "Cayenne";

VEHICLE.Script 			= "cayenne";

VEHICLE.Cost 			= 120000;
VEHICLE.PaintJobCost 	= 7500;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = 511;

VEHICLE.DynamicPaint = true
VEHICLE.PaintJobs = {
									{model = 'models/tdmcars/cayenne.mdl', skin = '0', name = 'White', color = Color(255, 255, 255, 255)},
									{model = 'models/tdmcars/cayenne.mdl', skin = '1', name = 'Black', color = Color(0, 0, 0, 255)},
									{model = 'models/tdmcars/cayenne.mdl', skin = '6', name = 'Gray', color = Color(75, 75, 75, 255)},
									{model = 'models/tdmcars/cayenne.mdl', skin = '7', name = 'Red', color = Color(255, 0, 0, 255)}, 
									{model = 'models/tdmcars/cayenne.mdl', skin = '3', name = 'Blue', color = Color(0, 60, 255, 255)}, 
									{model = 'models/tdmcars/cayenne.mdl', skin = '5', name = 'Pink', color = Color(255, 192, 203, 255)}, 
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(22.6, 7, 34.7, 28.5), Angle(0, 0, 6)},
								{Vector(22.6, 46.2199, 28.5), Angle(0, 0, 10)},
								{Vector(-22.6, 46.2199, 28.5), Angle(0, 0, 10)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-79.2231, -13.6429, 4.9321),
								Vector(79.2231, -13.6429, 4.9321),
							};
							
VEHICLE.DefaultIceFriction = .5;
							
VEHICLE.PlayerReposition_Pos = nil;
VEHICLE.PlayerReposition_Ang = nil;

VEHICLE.ViewAdjustments_FirstPerson = nil;
VEHICLE.ViewAdjustments_ThirdPerson = nil;

VEHICLE.RequiredClass 	= nil;

VEHICLE.PaintText = "<Whistles> Nice porsche! I'll paint this!";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(-37.8, 94.4, 46.5), 	Angle(20, 0, 0)};
									{Vector(37.8, 94.4, 46.5), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(-37.9, -111.6, 47), 	Angle(20, -180, 0)};
									{Vector(37.9, -111.6, 47), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};
VEHICLE.Exhaust = { 
									{Vector(-31.9077, -114.6675, 22.6654), Angle(0, 0, 80)},
									{Vector(31.9077, -114.6675, 22.6654), Angle(0, 0, 80)},
						}
								
VEHICLE.RevvingSound		= "vehicles/shelby/shelby_rev_short_loop1.wav";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);