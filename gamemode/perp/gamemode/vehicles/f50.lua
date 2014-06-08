///////////////////////////////
// This material may not be  //
//   reproduced, displayed,  //
//  modified or distributed  //
// without the express prior //
// written permission of the //
//   the copyright holder.   //
///////////////////////////////


VEHICLE 				= {}; 

VEHICLE.ID 				= 'G'; 
VEHICLE.FID				= '37';

VEHICLE.Name 			= "F50"; 
VEHICLE.Make 			= "Ferrari";
VEHICLE.Model 			= "Ferrari F50"; 

VEHICLE.Script 			= "f50"; 

VEHICLE.Cost 			= 1200000; 
VEHICLE.PaintJobCost 	= 15000;

VEHICLE.DF				= true; 

VEHICLE.CustomBodyGroup = nil; 

VEHICLE.PaintJobs = {
									{model = 'models/sickness/f50.mdl', skin = '0', name = 'Red', color = Color(255, 0, 0, 0)},
									{model = 'models/sickness/f50.mdl', skin = '1', name = 'Metallic Grey', color = Color(196, 196, 196)},
									{model = 'models/sickness/f50.mdl', skin = '2', name = 'Black', color = Color(0, 0, 0)},
									{model = 'models/sickness/f50.mdl', skin = '4', name = 'Yellow', color = Color(255, 255, 0)},									
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector( 22, -12, 11 ), Angle(0, 0, 0)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(-89.9778, -0.0606, 0.8727), 
								Vector(89.9778, -0.0606, 0.8727), 
							};
							
VEHICLE.DefaultIceFriction = .5; 
							
VEHICLE.PlayerReposition_Pos = nil; 
VEHICLE.PlayerReposition_Ang = nil; 

VEHICLE.ViewAdjustments_FirstPerson = nil; 
VEHICLE.ViewAdjustments_ThirdPerson = nil; 

VEHICLE.RequiredClass 	= nil; 

VEHICLE.PaintText = "Wow! I haven't painted one of these in years. What a beauty."; 

VEHICLE.HornNoise 			= 	NORMAL_HORNS; 
VEHICLE.HeadlightPositions 	= 	{
									{Vector(-34.4694, 104.9349, 29.8615), 	Angle(20, 0, 0)}; 
									{Vector(34.4694, 104.9349, 29.8615), 	Angle(20, 0, 0)}; 
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(-33.9710, -102.0066, 37.3170), 	Angle(20, -180, 0)}; 
									{Vector(33.9710, -102.0066, 37.3170), 	Angle(20, -180, 0)}; 
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)}; 
									{Vector(0, -35, 5)}; 
								};
				
VEHICLE.Exhaust = { 
									{Vector(38.2869, -103.2668, 19.8222), Angle(0, 0, 0)},
									{Vector(-38.2869, -103.2668, 19.8222), Angle(0, 0, 0)},
						}				
VEHICLE.RevvingSound		= "vehicles/caterham/rev_short_loop.wav"; 
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";  

GM:RegisterVehicle(VEHICLE); 