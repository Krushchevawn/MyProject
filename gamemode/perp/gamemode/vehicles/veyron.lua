


VEHICLE 				= {};

VEHICLE.ID 				= 'N';
VEHICLE.FID				= '50';

VEHICLE.Name 			= "Veyron";
VEHICLE.Make 			= "Bugatti";
VEHICLE.Model 			= "Bugatti Veyron";

VEHICLE.Script 			= "veyron";

VEHICLE.Cost 			= 2200000;
VEHICLE.PaintJobCost 	= 20000;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = nil;

VEHICLE.DynamicPaint = true
VEHICLE.PaintJobs = {
									{model = 'models/tdmcars/bugattiveyron.mdl', skin = '0', name = 'White', color = Color(255, 255, 255, 255)},
									{model = 'models/tdmcars/bugattiveyron.mdl', skin = '3', name = 'Red', color = Color(255, 0, 0, 255)},
									{model = 'models/tdmcars/bugattiveyron.mdl', skin = '2', name = 'Blue', color = Color(0, 52, 113, 255)},
									{model = 'models/tdmcars/bugattiveyron.mdl', skin = '2', name = 'Green', color = Color(0, 150, 0, 255)},
									{model = 'models/tdmcars/bugattiveyron.mdl', skin = '2', name = 'Black', color = Color(0, 0, 0, 255)},
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(17, -20, 10), Angle(0, 0, 20)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-72, -0.0606, 0.8727),
								Vector(72, -0.0606, 0.8727),
							};
							
VEHICLE.DefaultIceFriction = .5;
							
VEHICLE.PlayerReposition_Pos = nil//Vector(-15, 0, 8);
VEHICLE.PlayerReposition_Ang = nil//Angle(10, 90, 00);

VEHICLE.ViewAdjustments_FirstPerson = nil//Vector(-18, -223, -42);
VEHICLE.ViewAdjustments_ThirdPerson = nil//Vector(0, 0, 30);

VEHICLE.RequiredClass 	= nil;

VEHICLE.PaintText = "Of course! A Bugatti Veyron? Damn.";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(-23.4668, 82.5958, 28.8113), 	Angle(20, 0, 0)},
									{Vector(23.4668, 82.5958, 28.8113), 	Angle(20, 0, 0)},
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(24.5292, -93.8136, 34.5), 	Angle(20, -180, 0)},
									{Vector(-24.5292, -93.8136, 34.5), 	Angle(20, -180, 0)},
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};
VEHICLE.Exhaust = { 
									{Vector(-11.2079, -91.6297, 14.7579), Angle(0, 0, 80)},
									{Vector(11.2079, -91.6297, 14.7579), Angle(0, 0, 80)},
						}								
VEHICLE.RevvingSound		= "vehicles/enzo/turbo.mp3";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);