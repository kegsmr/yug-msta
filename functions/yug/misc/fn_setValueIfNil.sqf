// SETS A VARIABLE VALUE IF IT DOES NOT YET EXIST

// USAGE EXAMPLE
/*
	private _namespace = missionNamespace;
	private _name = "variableName";
	private _value = 0;
	private _public = true;
	[_namespace, _name, _value, _public] call YUG_fnc_setValueIfNil;
*/

if (false) exitWith {};

private _namespace = _this select 0;
private _name = _this select 1;
private _value = _this select 2;
private _public = _this select 3;

if (isNil "_public") then {
	_public = false;
};

if (isNil _name) then {
	_namespace setVariable [_name, _value, _public];
};