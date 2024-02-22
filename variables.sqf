PP_Vehicle = 0;
PP_Player = 0;
PP_OutOfBounds = 0;
PP_EarPlugs = false;
PP_AirVehicles = ["B_Heli_Light_01_armed_F", "I_Heli_light_03_F"];
PP_WantedVehicle = 0;

fnc_serviceVehicle = {
	private ["_dist"];
	if ((isTouchingGround PP_Vehicle) && (isTouchingGround PP_Player) && (!isNull PP_Vehicle)) then {
		_dist = PP_Vehicle distance PP_Player;
		if (_dist <= 4) then {
			player playMoveNow "AinvPknlMstpSnonWnonDnon_medicUp3";
			PP_Vehicle setFuel 1; 
			PP_Vehicle setDamage 0; 
			PP_Vehicle setVehicleAmmo 1; 
		} else {
			hint "You're too far away from your vehicle!";
		};
	} else {
		hint "You have to be landed and out of your vehicle in order service it!";
	};
};

fnc_spawnPlayer = {
	PP_Player = player;
	removeAllActions player;
	player addAction ["<t color='#CC00CC'>Service Vehicle</t>", fnc_serviceVehicle];
	_spawn = ["marker_area", (getMarkerSize "marker_area")] call BIS_fnc_randomPosTrigger;
	player setPos _spawn;
	PP_Vehicle = createVehicle [PP_AirVehicles select PP_WantedVehicle, position player, [], 0, "FLY"]; 
	player moveInDriver PP_Vehicle;
	PP_Vehicle setCollisionLight false;
	
	clearWeaponCargoGlobal PP_Vehicle;
	clearMagazineCargoGlobal PP_Vehicle;
	clearItemCargoGlobal PP_Vehicle;
	
	titleCut ["", "BLACK FADED", 999]; 
	[] Spawn { 
		sleep 0.5;
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [2];
		"dynamicBlur" ppEffectCommit 0;
		"dynamicBlur" ppEffectAdjust [0.0];
		"dynamicBlur" ppEffectCommit 5;
		titleCut ["", "BLACK IN", 2]; 
	};
};

fnc_onKilled = {
	if (!isNull PP_Vehicle) then {
		deleteVehicle PP_Vehicle;
		PP_Vehicle = nil;
	};
	
	hideBody PP_Player;
	deleteVehicle (_this select 0);
	
	titleCut ["", "BLACK", 999]; 
	[] Spawn { 
		"dynamicBlur" ppEffectEnable true;    
		"dynamicBlur" ppEffectAdjust [2];    
		"dynamicBlur" ppEffectCommit 0;      
		"dynamicBlur" ppEffectAdjust [0.0];   
		"dynamicBlur" ppEffectCommit 5;   
		titleCut ["", "BLACK OUT", 2]; 
	};
};

fnc_isInMarker = {
	private ["_pos", "_mark", "_inside", "_shape", "_loc"];
	_pos = _this select 0; 
	_mark = _this select 1;
	_inside = false;
	_shape = markerShape _mark;
	if (!(_shape == "ICON")) then {
		_loc = createLocation (["dummyloc____1", markerPos _mark] + (markerSize _mark));
		
		if (_shape == "RECTANGLE") then { 
			_loc setRectangular true 
		};
		
		_loc setDirection (markerDir _mark);
		
		if (_pos in _loc) then { 
			_inside = true 
		};
		
		deleteLocation _loc;
	};
	_inside
};

fnc_handleEarplugs = {
	if (PP_EarPlugs) then {
		1 fadeSound 0.07;
		hint "Earplugs inserted!";
	} else {
		1 fadeSound 1;
		hint "Earplugs removed!";
	};
};

fnc_keyDownHandler = { 
	private ["_name", "_keyCode"];
	_name = _this select 0;
	_keyCode = _this select 1;
		
	if (_keyCode == 59 || _keyCode == 61 || _keyCode == 210) then {
		PP_EarPlugs = !PP_EarPlugs;
		call fnc_handleEarplugs;
	};
	
	if (_keyCode == 41) then {
		if (PP_WantedVehicle == 0) then {
			PP_WantedVehicle = 1;
			hint "The next time you spawn you'll be in a WY-55 Hellcat (Armed)";
		} else {
			hint "The next time you spawn you'll be in a AH-9 Pawnee";
			PP_WantedVehicle = 0;
		};
	};
};