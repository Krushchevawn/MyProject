
VEHICLE 				= {};

VEHICLE.ID 				= 'R';
VEHICLE.FID				= '54';

VEHICLE.Name 			= "Audi";
VEHICLE.Make 			= "Audi R8";
VEHICLE.Model 			= "Audi";

VEHICLE.Script 			= "audir8v10";

VEHICLE.Cost 			= 250000;
VEHICLE.PaintJobCost 	= 7500;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = 511;

VEHICLE.DynamicPaint = true
VEHICLE.PaintJobs = {
									{model = 'models/tdmcars/audir8v10.mdl', skin = '0', name = 'White', color = Color(255, 255, 255, 255)},
									{model = 'models/tdmcars/audir8v10.mdl', skin = '3', name = 'Gray', color = Color(75, 75, 75, 255)},
									{model = 'models/tdmcars/audir8v10.mdl', skin = '1', name = 'Red', color = Color(255, 0, 0, 255)},
									{model = 'models/tdmcars/audir8v10.mdl', skin = '1', name = 'Green', color = Color(0, 150, 0, 255)},
									{model = 'models/tdmcars/audir8v10.mdl', skin = '1', name = 'Blue', color = Color(0, 0, 150, 255)},
					};
	
VEHICLE.PassengerSeats 	=	{
								{Vector(17.5, 3, 7), Angle(0, 0, 15)},
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

VEHICLE.PaintText = "<Whistles> Nice Audi. Yah, we can paint her.";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(-34.1, 80.3, 27.3), 	Angle(20, 0, 0)};
									{Vector(34.1, 80.3, 27.3), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(-29.1593, -90.6055, 38.7291), 	Angle(20, -180, 0)};
									{Vector(29.1593, -90.6055, 38.7291), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};
VEHICLE.Exhaust = { 
									{Vector(-31.3, -97.1, 16.9), Angle(0,0,80)},
									{Vector(31.3, -97.1, 16.9), Angle(0,0,90)}, 
						}
								
VEHICLE.RevvingSound		= "vehicles/shelby/shelby_rev_short_loop1.wav";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);