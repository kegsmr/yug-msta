// ENDS CIVILIAN AIRLIFT

if (!isServer) exitWith {};

private _leader = leader un_squad;

waitUntil {vehicle _leader != un_heli};

if (isPlayer _leader) then {
	[_leader, "startCivilianAirlift"] call YUG_fnc_addCommMenuItem;
} else {
	[] spawn YUG_fnc_startCivilianAirlift;
	[_leader, "endCivilianAirlift"] call YUG_fnc_addCommMenuItem;
}