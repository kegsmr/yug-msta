// DEALS WITH EVACUATION MISSION

if (false) exitWith {};

YUG_evacuated_civs = 0;

private _marker = "msta";
private _position = getMarkerPos _marker;
private _radius = 250;


// RUNS ONCE

if (missionNamespace getVariable ["YUG_evacuation_started", false] == false) then {

	missionNamespace setVariable ["YUG_evacuation_started", true, true];

	YUG_msta_civs = [];

	private _objects = nearestObjects [_position, ["Man", "car", "tank", "turret"], _radius];
	private _side = civilian;
	{
		if (side _x == _side) then {
			YUG_msta_civs append [_x];
		};
	} forEach _objects;

};


// KILLED MISSING EVACUATED REMAINING

YUG_killed_civs = {!alive _x} count YUG_msta_civs;
YUG_missing_civs = {_x distance2D _position > 500 && alive _x} count YUG_msta_civs;
YUG_remaining_civs = {_x distance2D _position <= 500 && alive _x} count YUG_msta_civs;

if (["un_civs"] call BIS_fnc_taskExists) then {
	[
		"un_civs",
		[
			str YUG_killed_civs + " killed, " + str YUG_missing_civs + " missing, " + str YUG_evacuated_civs + " evacuated, " + str YUG_remaining_civs + " remaining.",
			("un_civs" call BIS_fnc_taskDescription) select 1,
			("un_civs" call BIS_fnc_taskDescription) select 2
		]
	] call BIS_fnc_taskSetDescription;
};


// LOOPING THROUGH CIVS

if (isServer) then {

	{

		private _unit = _x;
		private _vehicles = ["CUP_I_Mi17_UN", "CUP_I_UAZ_Unarmed_UN", "CUP_C_Ikarus_Chernarus", "LOP_UN_Ural"];

		if (alive _unit && (_unit distance2D (getMarkerPos "msta")) <= 500) then {

			private _position = position _unit;
			private _radius = 50;
			private _objects = nearestObjects [_position, _vehicles, _radius];

			{
				private _object = _x;
				if (!isNull (driver _object)) then {
					if (side (driver _object) == independent) then {
						private _group = group _unit;
						_group addVehicle _object;
						[_unit] orderGetIn true;
						_unit enableAI "ALL";
					}
				}
			} forEach _objects;

		};

		if (vehicle _unit != _unit) then {
			if (isNull (driver (vehicle _unit)) || ((driver (vehicle _unit)) == _unit && typeOf (vehicle _unit) in _vehicles)) then {
				private _vehicle = vehicle _unit;
				[_unit] orderGetIn false;
				(group _unit) leaveVehicle _vehicle;
			};
		};

	} forEach YUG_msta_civs;

};