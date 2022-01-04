// SETS POSITON ABOVE A SURFACE

// USAGE EXAMPLE
/*
	private _object = myObject;
	private _position = [1,2,3];
		// WHERE '3' IS THE OFFSET ABOVE THE SURFACE
	[_object, _position] call PREFIX_fnc_setPosAGLS;
*/

// ISSUES
/*
	- MAY OR MAY NOT WORK
*/

if (false) exitWith {};

params ["_obj", "_pos"];

private _offset = _pos select 2;

if (isNil "_offset") then {
	_offset = 0
};

_pos set [2, worldSize];
_obj setPosASL _pos;

_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
_obj setPosASL _pos;