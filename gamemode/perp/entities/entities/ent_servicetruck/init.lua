AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

//lua_run GAMEMODE.SpawnVehicle(Entity(1), "%", {1, 1, 0})

function ENT:Initialize()
	self:SetModel("models/props_lab/powerbox02b.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetMass(2000)
	
	self:SetUseType(SIMPLE_USE)
	
	self.UpSound = CreateSound(self, "plats/crane/vertical_start.wav")
	self.DownSound = CreateSound(self, "plats/crane/vertical_start.wav")
	
	self.Pulley = ents.Create("prop_physics_multiplayer")
	self.Pulley:SetModel("models/props_c17/pulleywheels_small01.mdl")
	self.Pulley:SetPos(self.Vehicle:GetPos() + self.Vehicle:GetForward() * -137 + self.Vehicle:GetUp() * 120)
	self.Pulley:SetAngles(self.Vehicle:GetAngles())
	self.Pulley:Spawn()
	self.Pulley:GetPhysicsObject():SetMass(2000)
	self.Pulley.UnBurnable = true
	
	self.Beam = ents.Create("prop_physics_multiplayer")
	self.Beam:SetModel("models/props_junk/iBeam01a.mdl")
	self.Beam:SetPos(self.Vehicle:GetPos() + self.Vehicle:GetForward() * -50 + self.Vehicle:GetUp() * 70)
	self.Beam:SetAngles(self.Vehicle:GetAngles() + Angle(30, 90, 0))
	self.Beam:Spawn()
	self.Beam:GetPhysicsObject():SetMass(10)
	self.Beam.UnBurnable = true
	
	self.Pulley:DeleteOnRemove(self.Beam)
	self.Beam:SetParent(self.Pulley)
	constraint.Weld(self.Vehicle, self, 0, 0, 0, true)
	for i=1, 10 do
		constraint.Weld(self.Pulley, self.Vehicle, 0, 0, 0, true)
		constraint.Weld(self.Beam, self.Vehicle, 0, 0, 0, true)
	end
	self:DeleteOnRemove(self.Pulley)
	
	self.LastActivator = NULL
	self.Mode = "down"
	self.LastMode = "up"
	self.On = false
	self.UnBurnable = true
	
	self.RopeLength = 0
	self.CurrentRopeLength = 0
	self.NextRopeRefresh = CurTime()
	self.NextRopeRefresh2 = CurTime()
end

function ENT:SetVehicle(objEnt)
	self.Vehicle = objEnt
	
	objEnt:DeleteOnRemove(self)
end

function ENT:RemakeRope(iLength)
	if(not IsValid(self.Hook) or not IsValid(self.Pulley)) then return end
	
	constraint.RemoveConstraints(self.Hook, "Rope")
	constraint.RemoveConstraints(self.Pulley, "Rope")
	
	constraint.Rope(self.Pulley, self.Hook, 0, 0, Vector(0, 0, 0), Vector(0, 0, 22), 0, math.Clamp(iLength, 20, 400), 0, 2, "cable/cable2", false)
end

function ENT:Think()	
	if(self.On) then
		if(self.LastMode == "down") then
			self.RopeLength = math.Clamp(self.RopeLength + 10, 0, 400)
		elseif(self.LastMode == "up") then
			self.RopeLength = math.Clamp(self.RopeLength - 10, 0, 400)
		end
		
		if(self.RopeLength == 0) then
			if(IsValid(self.Hook)) then
				if(not self.Hook.Weld) then
					self.Hook:Remove()
					self.Hook = nil
					
					self:Use(self.LastActivator)
				end
			end
		end
		if(self.RopeLength == 400) then
			self:Use(self.LastActivator)
		end
	end
	
	if(self.NextRopeRefresh < CurTime()) then
		if(self.RopeLength != self.CurrentRopeLength) then
			self:RemakeRope(self.RopeLength)
			
			self.CurrentRopeLength = self.RopeLength
			
			self.NextRopeRefresh = CurTime() + 0.1
		end
	end
	
	if(self.NextRopeRefresh2 < CurTime()) then
		self:RemakeRope(self.RopeLength)

		self.NextRopeRefresh2 = CurTime() + 3
	end
	
	if(self.RopeLength > 10) then
		if(not IsValid(self.Hook)) then
			self.Hook = ents.Create("ent_servicetruck_hook")
			self.Hook:SetPos(self.Pulley:GetPos() + self.Pulley:GetRight() * -15 + self.Pulley:GetUp() * 25)
			self.Hook.Pulley = self.Pulley
			self.Hook.Vehicle = self.Vehicle
			self.Hook.Controller = self
			self.Hook.Beam = self.Beam
			self.Hook:Spawn()
			self.Hook:Activate()
			self:DeleteOnRemove(self.Hook)
			
			self:RemakeRope(self.RopeLength)
		end
	end
end

function ENT:Use(activator)
	if(not activator:IsPlayer()) then return end
	if(activator:GetPos():Distance(self:GetPos()) > 100) then return end
	if(activator:Team() != TEAM_ROADSERVICE) then return end
	
	self.LastActivator = activator
	
	if(self.Mode == "down") then
		self.DownSound:Play()
		self.DownSound:ChangePitch(120, 0)

		self.Mode = "stop"
		self.LastMode = "down"
		self.On = true
	elseif(self.Mode == "stop") then
		self.DownSound:Stop()
		self.UpSound:Stop()
		
		if(self.LastMode == "up") then
			self.Mode = "down"
		else
			self.Mode = "up"
		end
		
		self.LastActivator = NULL
		self.On = false
		self:EmitSound("plats/crane/vertical_stop.wav")
	elseif(self.Mode == "up") then
		self.UpSound:Play()
		self.UpSound:ChangePitch(80, 0)
		
		self.Mode = "stop"
		self.LastMode = "up"
		self.On = true
	end
end

function ENT:OnRemove()
	self.DownSound:Stop()
	self.UpSound:Stop()
end
