// SENDS TROOPS BACK TO THE VILLAGE TO DEFEND

if (!isServer) exitWith {};


// BOSNIAN PATROLS

{
	private _module = _x;
	_module setPos (getMarkerPos "msta");
} forEach entities "CBA_ModulePatrol";


// BOSNIAN HOUSE SQUAD

bosnian_house_squad addWaypoint [(getMarkerPos "msta"), 10];

{
	_x enableAi "ALL";
} forEach units bosnian_house_squad;


// UN

private _group = createGroup independent;

{
	private _unit = _x;
	if ((side _unit == independent) && (isDamageAllowed _unit)) then {
		[_unit] joinSilent _group;
		_unit enableAI "ALL";
	};
} forEach allUnits - playableUnits;

_group setGroupId ["Charlie 1-1"];

_group setCombatMode "AWARE";
_group addWaypoint [getMarkerPos "msta", 10];

// make charlie 1-1 join un_squad when both pilots are also in squad