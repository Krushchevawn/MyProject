


function ENTITY:GetZoneName ( )
	local lifeAlertZone;
	local pPos = self:GetPos();
	
	for k, v in pairs(GAMEMODE.LifeAlert) do
		local minVec = Vector(math.Min(v[2].x, v[3].x), math.Min(v[2].y, v[3].y), math.Min(v[2].z, v[3].z));
		local maxVec = Vector(math.Max(v[2].x, v[3].x), math.Max(v[2].y, v[3].y), math.Max(v[2].z, v[3].z));
		
		if (pPos.x >= minVec.x && pPos.y >= minVec.y && pPos.z >= minVec.z && pPos.x <= maxVec.x && pPos.y <= maxVec.y && pPos.z <= maxVec.z) then
			lifeAlertZone = v[1];
			break;
		end
	end
	
	if (!lifeAlertZone) then Msg("Life alert zone not found for '" .. tostring(pPos) .. "'.\n"); end
	
	return lifeAlertZone;
end

function PLAYER:BroadcastLifeAlert ( )
	local lifeAlertZone = self:GetZoneName();
	
	if (!lifeAlertZone or self:Team() != TEAM_CITIZEN ) then return; end
		
	GAMEMODE:PlayerSay(self, "/911 [Life Alert] An accident has occured at " .. lifeAlertZone .. ".", true, false);
end

GM.LifeAlert = 	{
					// Tunnels
					{"the City-Junction Tunnel", Vector(-5764.0313, -3486.4773, 70.9047), Vector(-6243.9688, -1408.4537, 318.8611)},
					{"the Hospitol-Junction Tunnel", Vector(-5219.3721, 614.9688, 318.8607), Vector(-4740.0313, 4114.8452, 64.5190)},
					{"the Industrial-Junction Tunnel", Vector(-203.1712, 614.9688, 319.0378), Vector(275.9688, 2879.3359, 66.5753)},
					{"the Outlands-Junction Tunnel", Vector(-1206.9688, -1406.9120, 319.2815), Vector(-727.0313, -4766.9912, 65.5102)},
					{"the Forest-Suburbs Tunnel", Vector(11809.8516, 5496.2520, 319.9688), Vector(12287.9688, 11258.9121, 65.9705)},
					{"the Hospitol-Suburbs Tunnel", Vector(-7429.4316, 10397.0313, 441.0585), Vector(-7939.9688, 10174.7441, 186.5152)},
					
					
					// City
					{"The Apartments", Vector(-10289.200195313, -9475.9443359375, -22.094026565552), Vector(-10845.213867188, -10343.647460938, 594.03564453125)},
					{"The Amber Room", Vector(-10289.865234375, -11077.399414063, 252.68455505371), Vector(-10730.173828125, -10340.83984375, 6.9577145576477)},
					{"The Skyscraper", Vector(-5522.0034, -8927.2266, 76.4222), Vector(-3625.9761, -9667.9365, 1864.1808)},
					{"The City Gas Station", Vector(-7972.2719726563, -5773.4350585938, 288.03125), Vector(-6328.5185546875, -6796.4150390625, -3.814564704895)},
					{"Burger King", Vector(-7142.0424804688, -5106.20703125, 368.20227050781), Vector(-7984.7504882813, -3760.4382324219, -28.513628005981)},
					{"The Tides Hotel", Vector(-5728.082031, -5165.652344, 86.945206), Vector(-3406.577637, -4109.761230, 329.761963)},
					{"The Shops", Vector(-3984.868652, -5127.438965, 199.970703), Vector(-3418.947021, -6918.365723, 323.821686)},
					{"The Fire Department", Vector(-3401.020752, -6940.677246, 314.737244), Vector(-3901.799316, -8598.751953, 208.903671)},
					{"The Bank", Vector(-7874.0317382813, -7965.62890625, 292.35754394531), Vector(-6426.1313476563, -7432.943359375, -34.106967926025)},
					{"The Nexus", Vector(-6346.0361328125, -8626.6884765625, 1.9766192436218), Vector(-7787.96875, -9722.3095703125, 4188.03125)},
					{"The General Store", Vector(-6959.735840, -10610.853516, 85.408897), Vector(-6462.360352, -9854.923828, 198.415985)},
					{"Izzie's Palace", Vector(-6686.904296875, -12797.375, -33.232597351074), Vector(-7589.5288085938, -14759.987304688, 481.73526000977)},
					{"The Park", Vector(-8555.524414, -11669.785156, 86.547623), Vector(-9559.138672, -8627.092773, 288.921631)},
					{"The Clothes Shop", Vector(-5432.330566, -5779.384766, 413.572510), Vector(-4855.898926, -6448.226074, 82.509483)},
					{"The Small Shop", Vector(-5068.813477, -7308.738281, 316.863708), Vector(-5432.423828, -6943.076172, 78.874893)},
					{"The Large Shop", Vector(-5427.433105, -7318.101563, 366.088806), Vector(-5097.693848, -7933.461426, 69.349411)},
					{"The Garage", Vector(-3589.5810546875, -10733.919921875, 205.95501708984), Vector(-5629.109375, -9957.005859375, -3.0391120910645)},
					{"The Main Road", Vector(-5677.385742, -12522.188477, 75.174866), Vector(-6245.665039, 617.997681, 358.966095)},
					{"The City Roads", Vector(-3913.248291, -8644.352539, 217.954132), Vector(-10151.435547, -7995.349609, 82.548882)},
					{"The City Roads", Vector(-3913.248291, -8644.352539, 217.954132), Vector(-7992.995117, -8013.298340, 283.369537)},
					{"The City Roads", Vector(-10259.232422, -12512.140625, 79.708038), Vector(-5679.489258, -11697.204102, 303.194641)},
					{"The City Roads", Vector(-3914.333740, -8641.652344, 210.518295), Vector(-4836.678223, -5125.257813, 458.733643)},
					{"The City Roads", Vector(-4007.418213, -5122.106445, 200.110733), Vector(-8350.138672, -5756.516113, 310.937805)},
					{"The Police Department", Vector(-7770.935059, -10634.707031, 2.742554), Vector(-6369.769531, -8889.467773, -431.816345)},
					{"The Police Department", Vector(-7792.899414, -8542.392578, 274.080231), Vector(-8111.017090, -10652.275391, -179.522827)},
					
					{"Main Street", Vector(-5719.0313, -3490.3699, 72.6370), Vector(-6344.6328, -11496.9688, 463.7588)},
					{"the City Slums", Vector(-7355.7373, -7957.0313, 318.0265), Vector(-9497.5488, -11509.0313, 73.5651)},
					{"the City", Vector(-3135.0129, -5119.9688, 3000), Vector(-9497.5488, -11509.0313, -2500)},
					{"the City", Vector(-8080.12890625, -12702.796875, 1023.3862915039), Vector(-11262.268554688, -7821.5732421875, -18.930393218994)},
					
					// Exchange
					{"the Junction Warehouse", Vector(-1825.3981, -361.7719, 288.7318), Vector(-4188.9131, 615.0000, 64.4348)},
					{"the Junction", Vector(-6563.0044, -1408.4941, 667.5457), Vector(553.4925, 608.2149, 50)},
					
					// Hospitol
					{"the Hospitol", Vector(-8301.739258, 8300.989258, 430.847687), Vector(-11404.297852, 10006.354492, 79.853905)},
					{"the Hospitol Road", Vector(-3984.3652, 4122.3711, 666.3014), Vector(-12109.5820, 10231.8096, 60.0661)},
					
					// Industrial Zone
					{"the MTL Complex", Vector(-3584.2277832031, 9155.0419921875, 789.73101806641), Vector(-428.931640625, 2692.7922363281, -100.97137451172)},
					{"the Power Plant", Vector(2869.1091, 4607.0313, 701.2580), Vector(4263.1411, 3595.0313, 64.4830)},
					
					// Sickness Road Area
					{"the Old Inn", Vector(-591.2158, -6685.8267, 188.9688), Vector(-1622.9688, -6014.3623, 62.3013)},
					{"Sickness Road", Vector(-1753.6481, -4742.0313, 674.7412), Vector(8396.9775, -6708.9014, 60)},
					{"Forest Road", Vector(8414.3809, -6691.6226, 664.1188), Vector(6539.4580, 5468.7783, 60)},
					{"Forest Road", Vector(12548.8789, 3604.0818, 667.7830), Vector(6539.4580, 5468.7783, 60)},
					
					// Lake Area
					{"Lake House #1", Vector(-5704.2461, 12495.9688, 362.6231), Vector(-6088.0313, 13134.4287, 188.8057)},
					{"Lake House #2", Vector(-6273.5640, 14439.9688, 363.3763), Vector(-5889.9688, 15076.9268, 187.7479)},
					{"the Lake Neighborhood", Vector(-9582.9971, 10386.2295, 669.8423), Vector(1046.5725, 15262.5264, 60.3583)},

					//Suburbs
					{"Suburbs House #1", Vector(2986.9567871094, 10481.541015625, 402.93566894531), Vector(1398.1433105469, 12109.145507813, -52.877326965332)},
					{"Suburbs House #2", Vector(5560.884765625, 10435.5859375, 405.6481628418), Vector(3845.2705078125, 11738.953125, -27.468559265137)},
					{"Suburbs House #3", Vector(4482.4877929688, 12973.955078125, -60.461616516113), Vector(5791.912109375, 15110.65625, 251.2472076416)},
					{"Suburbs House #4", Vector(3802.2060546875, 12956.916015625, -96.190246582031), Vector(1350.6076660156, 15082.322265625, 334.10098266602)},
					{"Suburbs House #5", Vector(-3311.9968, 12255.0469, 313.4655), Vector(-3696.0313, 11743.8613, 181.2888)},
					{"Suburbs House #6", Vector(-4271.9688, 11743.7852, 316.2161), Vector(-4656.0313, 12254.5029, 186.7185)},
					{"the Suburbs", Vector(5750.8315, 10226.8926, -172.5671), Vector(1084.8986816406, 15239.750976563, 372.10040283203)},
					
					//Generic
					{"The Country Houses", Vector(6787.2471, 2315.2063, -122.7637), Vector(10854.4180, 5289.4697, 959.4724)},
					{"The Industrial Zone", Vector(-3658.8322753906, 2823.9289550781, 772.08166503906), Vector(5323.9252929688, 8870.3896484375, -26.607526779175)},
					{"The City", Vector(-3169.6335, -13399.3379, 1282.4857), Vector(-8486.7959, -3486.7041, -1099.1985)},
					{"Outside of the City", Vector(-7243.830078, -2693.680664, -19.372360), Vector(13248.6055, 15513.6807, 1048.6317)},
					
				};
