


VEHICLE 				= {};

VEHICLE.ID 				= 'O';
VEHICLE.FID				= '53';

VEHICLE.Name 			= "Pickup";
VEHICLE.Make 			= "GMC";
VEHICLE.Model 			= "Pickup";

VEHICLE.Script 			= "gmc";

VEHICLE.Cost 			= 95000;
VEHICLE.PaintJobCost 	= 6250;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = nil;

VEHICLE.PaintJobs = {
						{model = 'models/gmc-pickup.mdl', skin = '3', name = 'Red', color = Color(255, 0, 0, 255)},
						{model = 'models/gmc-pickup.mdl', skin = '1', name = 'Light Blue', color = Color(0, 191, 255, 255)},
						{model = 'models/gmc-pickup.mdl', skin = '2', name = 'Lime', color = Color(50, 205, 50, 255)},
						{model = 'models/gmc-pickup.mdl', skin = '4', name = 'Black', color = Color(0, 0, 0, 255)},
						{model = 'models/gmc-pickup.mdl', skin = '5', name = 'Brown', color = Color(139, 69, 19, 255)},
						{model = 'models/gmc-pickup.mdl', skin = '6', name = 'White', color = Color(255, 255, 255, 255)},
						{model = 'models/gmc-pickup.mdl', skin = '7', name = 'Orange', color = Color(255, 165, 0, 255)},
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(16, 2, 25), Angle(0, 0, 0)},
								{Vector(16, 40, 25), Angle(0, 180, 0)},
								{Vector(-16, 40, 25), Angle(0, 180, 0)},
								{Vector(26, 95, 25), Angle(0, 90, 0)},
								{Vector(-26, 95, 25), Angle(0, -90, 0)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-93.6075, 48.9518, 4.2876),
								Vector(93.6075, 48.9518, 4.2876),
								Vector(-93.6075, 80.9518, 4.2876),
								Vector(93.6075, 80.9518, 4.2876),
								Vector(-93.6075, 110.9518, 4.2876),
								Vector(93.6075, 110.9518, 4.2876),
							};
							
VEHICLE.DefaultIceFriction = .2;
							
VEHICLE.PlayerReposition_Pos = nil;
VEHICLE.PlayerReposition_Ang = nil;

VEHICLE.ViewAdjustments_FirstPerson = nil;
VEHICLE.ViewAdjustments_ThirdPerson = nil;

VEHICLE.RequiredClass 	= nil;

VEHICLE.PaintText = "Of course! A verry nice truck";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(35.7723, 100.7135, 35.6355), 	Angle(20, 0, 0)}; // x +forward +up
									{Vector(-35.7723, 100.7135, 35.6355), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(-35.2796, -140.8145, 40.8403), 	Angle(20, -180, 0)};
									{Vector(35.2796, -140.8145, 40.8403), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};

VEHICLE.Exhaust = { 
									{Vector(31.3415, -128.7013, 19.5376), Angle(0, 0, 80)},
						}
						
VEHICLE.RevvingSound		= "vehicles/enzo/turbo.mp3";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);