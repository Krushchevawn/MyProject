


local FireHydrants = {
						//City
						Vector(-5714.232421875, -7911.0551757813, 72), 
						Vector(-7039.1655273438, -7534.3193359375, 72), 
						Vector(-7295.431640625, -5735.9267578125, 72), 
						Vector(-7205.376953125, -4466.921875, 72), 
						Vector(-5712.08203125, -4332.5288085938, 72), 
						Vector(-4031.298584, -7286.184082, 197), 
						Vector(-5715.2578125, -9791.66015625, 72), 
						Vector(-7146.016113, -12496.34, 72),
						Vector(-10208.4561, -9596.4219, 72.0313),
						
						//Industrial
						Vector(745.758667, 4682.89, 67),
						Vector(4346.810059, 7755.700684, 67),
						Vector(4077.569336, 3520.820557, 67),
						
						//Car Dealer
						Vector(6034.479980, -5059.8603, 63.5),
						
						//Subs
						Vector(3203.5107, 12063.2949, 58.0313),
						
						//Hospitol
						Vector(-9310.6729, 8839.3154, 72.0313),
					};
					
					
local function SpawnHydrants ( )
	for k, v in pairs(FireHydrants) do
		Hydrant = ents.Create("prop_physics");
		Hydrant:SetModel("models/props/cs_assault/FireHydrant.mdl");
		Hydrant:SetPos(v);
		Hydrant:Spawn();
		Hydrant:GetPhysicsObject():EnableMotion(false);
	end;
end;
timer.Simple(1, function() SpawnHydrants() end)