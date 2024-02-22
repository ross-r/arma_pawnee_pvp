private ["_spawnPoints", "_marker"];

waitUntil {((!isNull player) && (player == player))};

[] call compile preprocessFileLineNumbers "variables.sqf";

player addEventHandler ["Killed", { call fnc_onKilled }];
player addEventHandler ["Respawn", { call fnc_spawnPlayer }];

waituntil {!(IsNull (findDisplay 46))}; 
(findDisplay 46) displayAddEventHandler ["KeyDown", { call fnc_keyDownHandler }];

if (alive player) then {
	_text = parseText format[
		"Welcome to Pawnee PvP!" + 
		"%2%2You can change your vehicle using the tilde key (~)" + 
		"%2Earplugs are bound to these keys: F1, F3, INS", 
		"<t size='1' color='#ff0000'>", "\n", "</t>"
	];
	titleText [str _text, "PLAIN"];
	
	call fnc_spawnPlayer;
	
	while {true} do {
		_isInsideArea = [position player, "marker_area"] call fnc_isInMarker;
		if (str _isInsideArea == "false") then {
			PP_OutOfBounds = PP_OutOfBounds  + 1;
			titleText [format ["!! RETURN TO THE AREA MARKED ON YOUR MAP !! (%1 / 6)", PP_OutOfBounds], "PLAIN"];
			if (PP_OutOfBounds > 6) then {
				titleText ["!! YOU'VE BEEN KILLED !!", "PLAIN"];
				forceRespawn player;
			};
		} else {
			PP_OutOfBounds = 0;
		};
		
		sleep 10;
	};
};