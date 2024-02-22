enableSaving [false, false];
enableSentences false;
enableRadio false;

[] call compile preprocessFileLineNumbers "init\fnc\fnc_getRandomPos.sqf";

if (isDedicated) then {
	[] execVM "init\dedicated.sqf";
};

if (isServer && !isDedicated) then {
	[] execVM "init\local.sqf";
};

if (!isDedicated) then {
	[] execVM "init\server.sqf";
};