


VEHICLE 				= {};

VEHICLE.ID 				= 'f';
VEHICLE.FID				= '6';

VEHICLE.Name 			= "Speedo";
VEHICLE.Make 			= "Vapid ST";
VEHICLE.Model 			= "Speedo";

VEHICLE.Script 			= "speedo";

VEHICLE.Cost 			= 65000;
VEHICLE.PaintJobCost 	= 4500;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = nil;

VEHICLE.PaintJobs = {
						{model = 'models/sickness/speedodr.mdl', skin = '0', name = 'Black', color = Color(0, 0, 0, 255)},
						{model = 'models/sickness/speedodr.mdl', skin = '1', name = 'White', color = Color(255, 250, 250, 255)},
						{model = 'models/sickness/speedodr.mdl', skin = '2', name = 'Red', color = Color(205, 51, 51, 255)},
						{model = 'models/sickness/speedodr.mdl', skin = '3', name = 'Pale Green', color = Color(152, 251, 152, 255)},
						{model = 'models/sickness/speedodr.mdl', skin = '4', name = 'Dodger Blue', color = Color(24, 116, 205, 255)},
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(23, -28, 29), Angle(0, 0, 0)},
								{Vector(24, 60, 30), Angle(0, 0, 0)},
								{Vector(-22, 60, 30), Angle(0, 0, 0)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-93.6075, 48.9518, 4.2876),
								Vector(93.6075, 48.9518, 4.2876),
								Vector(-93.6075, 18.9518, 4.2876),
								Vector(93.6075, 18.9518, 4.2876),
							};
							
VEHICLE.DefaultIceFriction = .2;
							
VEHICLE.PlayerReposition_Pos = nil;
VEHICLE.PlayerReposition_Ang = nil;

VEHICLE.ViewAdjustments_FirstPerson = nil;
VEHICLE.ViewAdjustments_ThirdPerson = nil;

VEHICLE.RequiredClass 	= nil;

VEHICLE.PaintText = "A ped- Speedo, don't go out taking my kids now!";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(38.7723, 102.7135, 49.6355), 	Angle(20, 0, 0)};
									{Vector(-38.7723, 102.7135, 49.6355), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(-21.2796, -76.8145, 30.8403), 	Angle(20, -180, 0)};
									{Vector(21.2796, -76.8145, 30.8403), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};
								
VEHICLE.Exhaust = { 
									{Vector(-35.2914, -95.3106, 13.8939), Angle(0, -45, 80)},
						}			
						
VEHICLE.RevvingSound		= "vehicles/enzo/turbo.mp3";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);