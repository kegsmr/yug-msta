// DETERMINES WHETHER A UNIT IS ARMED OR NOT

if (false) exitWith {};

params ["_unit"];

private _safe_weapons = [];

private _condition = false;

if (((weaponstate _unit) select 0 == "") || ((weaponstate _unit) select 0 in _safe_weapons)) then {
	_condition = false;
} else {
	_condition = true;
};

_condition