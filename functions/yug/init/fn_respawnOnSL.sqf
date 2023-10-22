// MAKES PLAYABLE UNITS RESPAWN ON SL WHEN POSSIBLE

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_respawnOnSL;
*/

if (!isServer) exitWith {};

{
	
	private _unit = _x;
	
	_unit addMPEventHandler ["MPRespawn", {

		private _unit = _this select 0;
		private _group = group _unit;
		private _leader = leader _group;

		[_unit] allowGetIn true;

		if (lifeState _leader in ["HEALTHY", "INJURED"]) then {

			private _vehicle = vehicle _leader;

			if (_vehicle == _leader) then {

				private _position = position _leader;
				private _direction = direction _leader;
				private _distance = -3;
				private _stance = stance _leader;

				_position = [_position, _distance, _direction] call BIS_fnc_relPos;
				
				_unit setPos _position;
				_unit setDir _direction;

				if (_stance == "CROUCH") then {
					_unit playAction "PlayerCrouch";
				} else {
					if (_stance == "PRONE") then {
						_unit playAction "PlayerProne";
					};
				};

			} else {

				_unit moveInAny _vehicle;

			};

		};
	
	}];

} forEach playableUnits;


/*private _unit = _this select 0;
private _group = group _unit;
private _leader = leader _group;

if (lifeState _leader in ["HEALTHY", "INJURED"]) then {

	private _vehicle = vehicle _leader;

	if (_vehicle == _leader) then {
		private _position = position _leader;
		_unit setPos _position;
	} else {
		_unit moveInAny _vehicle;
	};

};*/

/* private _distanceToNearestEnemy = _leader distance (_leader findNearestEnemy _leader);*/
/*&& (_distanceToNearestEnemy > 10)*/

/*

// DETERMINES SPAWN POSITION

if (false) exitWith {};

private _objective = getMarkerPos "msta";
private _maxDistance = 1000;

{

	private _marker = _x select 0;
	private _leader = _x select 1;

	if (missionNamespace getVariable [_marker + "_start", 0] isEqualTo 0) then {
		missionNamespace setVariable [_marker + "_start", getMarkerPos _marker, true];
	};

	if ((alive _leader) && (vehicle _leader == _leader) && (lifeState _leader in ["HEALTHY", "INJURED"]) && (_leader distance2D _objective <= _maxDistance)) then {
		_marker setMarkerPos (position _leader);
		_marker setMarkerText "Squad Leader";
	} else {
		_marker setMarkerPos (missionNamespace getVariable (_marker + "_start"));
		_marker setMarkerText "HQ";
	};

} foreach [["respawn_east", leader serb_squad], ["respawn_guerilla", leader un_squad]];

*/