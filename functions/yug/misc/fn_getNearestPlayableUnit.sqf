// FINDS THE PLAYABLE UNIT CLOSEST TO THE OBJECT

// USAGE EXAMPLE
/*
	private _object = myObject;
	private _distance = _object call PREFIX_fnc_getNearestPlayableUnit;

	// RETURNS NEAREST PLAYABLE UNIT, RETURNS OBJNULL IF NONE IS FOUND
*/

if (false) exitWith {};

private _position = (
	if (typeName _this == "OBJECT") then {
		position _this
	} else {
		if (typeName (_this select 0) == "OBJECT") then {
			position (_this select 0)
		} else {
			_this
		}
	}
);

private _distance_1 = "None";
private _unit = objNull;

{

	private _distance_2 = _x distance _position;

	if (_distance_1 isEqualTo "None") then {
		_distance_1 = _distance_2;
	};

	if (_unit isEqualTo objNull) then {
		_unit = _x;
	};

	if (_distance_1 > _distance_2) then {
		_distance_1 = _distance_2;
		_unit = _x;
	};

} forEach playableUnits;

_unit