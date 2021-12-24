// FINDS THE PLAYER CLOSEST TO THE OBJECT

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
private _player = objNull;

{

	private _distance_2 = _x distance _position;

	if (_distance_1 isEqualTo "None") then {
		_distance_1 = _distance_2;
	};

	if (_player isEqualTo objNull) then {
		_player = _x;
	};

	if (_distance_1 > _distance_2) then {
		_distance_1 = _distance_2;
		_player = _x;
	};

} forEach playableUnits;

_player