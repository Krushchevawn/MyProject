


VEHICLE 				= {};

VEHICLE.ID 				= 'M';
VEHICLE.FID				= '57';

VEHICLE.Name 			= "Mercedes SL65 AMG";
VEHICLE.Make 			= "Mercedes";
VEHICLE.Model 			= "SL65 AMG";

VEHICLE.Script 			= "sl65amg";

VEHICLE.Cost 			= 950000;
VEHICLE.PaintJobCost 	= 10000;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = 511;

VEHICLE.DynamicPaint = true
VEHICLE.PaintJobs = {
									{model = 'models/tdmcars/sl65amg.mdl', skin = '0', name = 'White', color = Color(255, 255, 255, 255)},
									{model = 'models/tdmcars/sl65amg.mdl', skin = '1', name = 'Black', color = Color(0, 0, 0, 255)},
									{model = 'models/tdmcars/sl65amg.mdl', skin = '6', name = 'Gray', color = Color(75, 75, 75, 255)},
									{model = 'models/tdmcars/sl65amg.mdl', skin = '7', name = 'Red', color = Color(255, 0, 0, 255)}, 
									{model = 'models/tdmcars/sl65amg.mdl', skin = '3', name = 'Blue', color = Color(0, 60, 255, 255)},
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(17.5, 13, 7), Angle(0, 0, 6)},
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

VEHICLE.PaintText = "<Whistles> DDAAYYYUMMMM NICE CAR! I'll paint it for your rich ass...";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(-33.1, 82.3, 27.5), 	Angle(20, 0, 0)};
									{Vector(33.1, 82.3, 27.5), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(-29.5, -95.9, 35.3), 	Angle(20, -180, 0)};
									{Vector(29.5, -95.9, 35.3), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};

VEHICLE.Exhaust = { 
									{Vector(-23.8866, -98.1881, 13.3131), Angle(0, 0, 80)},
									{Vector(23.8866, -98.1881, 13.3131), Angle(0, 0, 80)},
						}
						
VEHICLE.RevvingSound		= "vehicles/shelby/shelby_rev_short_loop1.wav";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);