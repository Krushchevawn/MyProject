/////////////////////////////////////////
// © 2011-2012 D3lux - D3lux-Gaming    //
//    All rights reserved    		   //
/////////////////////////////////////////
// This material may not be  		   //
//   reproduced, displayed,  		   //
//  modified or distributed  		   //
// without the express prior 		   //
// written permission of the 		   //
//   the copyright holder.  		   //
//		D3lux-Gaming.com   			   //
/////////////////////////////////////////


VEHICLE 				= {};

VEHICLE.ID 				= 'P';
VEHICLE.FID				= '43';

VEHICLE.Name 			= "Supra";
VEHICLE.Make 			= "Toyota";
VEHICLE.Model 			= "Supra";

VEHICLE.Script 			= "supra";

VEHICLE.Cost 			= 130000;
VEHICLE.PaintJobCost 	= 7500;

VEHICLE.DF				= true;

VEHICLE.CustomBodyGroup = nil;

VEHICLE.PaintJobs = {
						{model = 'models/supra.mdl', skin = '0', name = 'White /w Grey Hood', color = Color(150, 150, 150, 255)},
						{model = 'models/supra.mdl', skin = '1', name = 'White', color = Color(255, 255, 255, 255)},
						{model = 'models/supra.mdl', skin = '3', name = 'Black', color = Color(16, 17, 19, 255)},
						{model = 'models/supra.mdl', skin = '4', name = 'Red /w Black Hood', color = Color(225, 1, 1, 255)},
						{model = 'models/supra.mdl', skin = '5', name = 'Red', color = Color(225, 1, 1, 255)},
						{model = 'models/supra.mdl', skin = '6', name = 'Blue /w Grey Hood', color = Color(20, 20, 225, 255)},
						{model = 'models/supra.mdl', skin = '7', name = 'Orange', color = Color(255, 165, 0, 255)},
					};
					
VEHICLE.PassengerSeats 	=	{
								{Vector(21, 18, 10), Angle(0, 0, 0)},
							};
	
VEHICLE.ExitPoints 		=	{
								Vector(81.2183, 7.3703, 2.9262),
								Vector(-83.6722, 4.4156, 2.6407),
							};
							
VEHICLE.DefaultIceFriction = .2;
							
VEHICLE.PlayerReposition_Pos = nil;
VEHICLE.PlayerReposition_Ang = nil;

VEHICLE.ViewAdjustments_FirstPerson = nil;
VEHICLE.ViewAdjustments_ThirdPerson = nil;

VEHICLE.RequiredClass 	= nil;

VEHICLE.PaintText = "JESUS FUCKING CHRIST!! A SUPRA!! THE MOST AWESOME CAR EVER!! OMFG!! I WANNA PAINT IT YES!";

VEHICLE.HornNoise 			= 	NORMAL_HORNS;
VEHICLE.HeadlightPositions 	= 	{
									{Vector(24.0162, 90.6773, 29.7472), 	Angle(20, 0, 0)};
									{Vector(-24.0162, 90.6773, 29.7472), 	Angle(20, 0, 0)};
								};
VEHICLE.TaillightPositions 	= 	{
									{Vector(24.2034, -115.4885, 43.9218), 	Angle(20, -180, 0)};
									{Vector(-24.2034, -115.4885, 43.9218), 	Angle(20, -180, 0)};
								};
VEHICLE.UnderglowPositions  =	{
									{Vector(0, 35, 5)};
									{Vector(0, -35, 5)};
								};

VEHICLE.Exhaust = { 
									{Vector(-22.9475, -114.6391, 15.9427), Angle(0, 0, 80)},
									{Vector(22.9475, -114.6391, 15.9427), Angle(0, 0, 80)},
						}
						
VEHICLE.RevvingSound		= "vehicles/enzo/turbo.mp3";
VEHICLE.SpinoutSound		= "vehicles/golf/skid_highfriction.wav";

GM:RegisterVehicle(VEHICLE);