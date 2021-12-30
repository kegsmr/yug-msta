// MAKES PLAYABLE UNITS RESPAWN ON SL WHEN POSSIBLE

if (!isServer) exitWith {};

{
	
	private _unit = _x;
	
	_unit addEventHandler ["Respawn", {

		private _unit = _this select 0;
		private _group = group _unit;
		private _leader = leader _group;	
		
		// private _distanceToNearestEnemy = _leader distance (_leader findNearestEnemy _leader);

		if ((lifeState _leader in ["HEALTHY", "INJURED"]) /*&& (_distanceToNearestEnemy > 10)*/) then {

			private _vehicle = vehicle _leader;

			if (_vehicle == _leader) then {
				private _positon = position _leader;
				_unit setPos _position;
			} else {
				_unit moveInAny _vehicle;
			};

		};

	}];

} forEach playableUnits;


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