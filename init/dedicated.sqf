_spawnPoints = [20, 2000] call fnc_getRandomPos;  
_point = (([20, 2000] call fnc_getRandomPos) call BIS_fnc_selectRandom);

_marker = createMarker ["marker_area", _point];
_marker setMarkerShape "RECTANGLE";
_marker setMarkerSize [1000, 1000];
publicVariable "marker_area";
