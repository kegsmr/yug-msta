// DETERMINES WHETHER A UNIT IS ARMED OR NOT, UNITS WITH GUNS HOLSTERED COUNT AS UNARMED UNLESS THEIR SIDE IS EXEMPT

// USAGE EXAMPLE
/*
	private _unit = myUnit;
	private _isArmed = _unit call PREFIX_fnc_isArmed;

	// RETURNS BOOLEAN
*/

// SETTINGS
private _safeWeapons = [];
	// WEAPON TYPES THAT ARE NOT CONSIDERED WEAPONS
private _armedSides = [east, west, independent];
	// SIDES THAT ARE ALWAYS CONSIDERED ARMED
//

if (false) exitWith {};

params ["_unit"];

private _condition = false;
if ((((weaponstate _unit) select 0 == "") || ((weaponstate _unit) select 0 in _safeWeapons)) && !(side _unit in _armedSides)) then {
	_condition = false;
} else {
	_condition = true;
};

_condition