


VEHICLE 				= {};

VEHICLE.ID 				= 'S';
VEHICLE.FID				= '56';

VEHICLE.Name 			= "2006 Shelby";
VEHICLE.Make 			= "Ford";
VEHICLE.Model 			= "Mustang Shelby";

VEHICLE.Script 			= "gt500";

VEHICLE.Cost 			= 100000;
VEHICLE.PaintJobCost 	= 7500;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = 511;

VEHICLE.DynamicPaint = true
VEHICLE.PaintJobs = {
									{model = 'models/tdmcars/gt500.mdl', skin = '0', name = 'White', color = Color(255, 255, 255, 255)},
									{model = 'models/tdmcars/gt500.mdl', skin = '2', name = 'Black', color = Color(0, 0, 0, 255)},
									{model = 'models/tdmcars/gt500.mdl', skin = '7', name = 'Red', color = Color(255, 0, 0, 255)}, 
									{model = 'models/tdmcars/gt500.mdl', skin = '8', name = 'Blue', color = Color(0, 60, 255, 255)}, 
									{model = 'models/tdmcars/gt500.mdl', skin = '6', name = 'Orange', color = Color(255, 160, 0, 255)}, 
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(23, -5.5, 15), Angle(0, 0, 13)},
								{Vector(23, 40, 15), Angle(0, 0, 13)},
								{Vector(-23, 40, 15), Angle(0, 0, 13)},
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

VEHICLE.PaintText = "A true American Beauty! Lets get her some color.";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(33, 91.5, 33), 	Angle(20, 0, 0)};
									{Vector(-33, 91.5, 33), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(22.2, -106.6, 42.5), 	Angle(20, -180, 0)};
									{Vector(-22.2, -106.6, 42.5), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};

VEHICLE.Exhaust = { 
									{Vector(-27.9944, -109.9088, 16.4451), Angle(0, 0, 80)},
									{Vector(27.9944, -109.9088, 16.4451), Angle(0, 0, 80)},
						}
						
VEHICLE.RevvingSound		= "vehicles/shelby/shelby_rev_short_loop1.wav";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);