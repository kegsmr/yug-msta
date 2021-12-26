// DETERMINES SPAWN POSITION

if (false) exitWith {};

{

	private _marker = _x select 0;
	private _leader = _x select 1;

	if (missionNamespace getVariable [_marker + "_start", 0] isEqualTo 0) then {
		missionNamespace setVariable [_marker + "_start", getMarkerPos _marker, true];
	};

	if ((alive _leader) && (vehicle _leader == _leader) && (lifeState _leader in ["HEALTHY", "INJURED"])) then {
		_marker setMarkerPos (position _leader);
		_marker setMarkerText "Squad Leader";
	} else {
		_marker setMarkerPos (missionNamespace getVariable (_marker + "_start"));
		_marker setMarkerText "HQ";
	};

} foreach [["respawn_east", leader serb_squad], ["respawn_guerilla", leader un_squad]];