fnc_getRandomPos = {
	params ["_poscountend", "_distancebetween"];
 
	_poscountstart = 0;
	_allpos = [];
	_worldSize = if (isNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize")) then {
		getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
	} else {
		10000;
	};
 
	_worldCenter = [_worldSize / 2, _worldSize / 2, 0];
	
	while {_poscountstart >= 0 && _poscountstart < _poscountend} do {
		_pos = [_worldCenter, 1, (_worldSize/2), 10, 0, 1, 0] call BIS_fnc_findSafePos;
		if (count _allpos == 0) then {
			_allpos pushback _pos;
			_poscountstart = _poscountstart +1;
		} else {
			if ((count(_allpos select {(_x distance _pos) < _distancebetween})) isEqualTo 0) then {
				_allpos pushback _pos;
				_poscountstart = _poscountstart +1;
			};
		};
	};

	_allpos
};