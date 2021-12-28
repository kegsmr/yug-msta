// DEALS WITH EVACUATION MISSION

if (false) exitWith {};

if (isNil "YUG_evacuated_civs") then {
	YUG_evacuated_civs = 0;
};

private _marker = "msta";
private _position = getMarkerPos _marker;
private _radius = 250;

YUG_fnc_evacuated = {

	private _unit = _this;

	private _index = YUG_msta_civs find _unit;
	YUG_msta_civs deleteAt _index;

	YUG_evacuated_civs = YUG_evacuated_civs + 1;

	independent addScoreSide 1;

	[_unit] spawn YUG_fnc_deleteObjects;

	unassignVehicle _unit;

};


// RUNS ONCE

if (missionNamespace getVariable ["YUG_evacuation_started", false] == false) then {

	missionNamespace setVariable ["YUG_evacuation_started", true, true];

	YUG_msta_civs = [];

	private _objects = nearestObjects [_position, ["LOP_CHR_Civ_Random"], _radius];
	private _side = civilian;
	{
		
		private _unit = _x;

		if (side _unit == _side) then {

			YUG_msta_civs append [_unit];

			if (isServer) then {
				private _trigger = createTrigger ["EmptyDetector", getMarkerPos "refugee_marker", false];
				_trigger setTriggerStatements [str _unit + " in thisList", str _unit + " spawn YUG_fnc_evacuated;", ""];
				_trigger setTriggerActivation ["ANY", "PRESENT", false];
				_trigger setTriggerArea [50, 50, 0, false, -1];
			};

		};

	} forEach _objects;

};


// KILLED MISSING EVACUATED REMAINING

YUG_killed_civs = {!alive _x} count YUG_msta_civs;
YUG_missing_civs = {_x distance2D _position > 500 && alive _x} count YUG_msta_civs;
YUG_remaining_civs = {_x distance2D _position <= 500 && alive _x} count YUG_msta_civs;

{
	if ([_x] call BIS_fnc_taskExists) then {
		[
			_x,
			[
				str YUG_killed_civs + " killed, " + str YUG_missing_civs + " missing, " + str YUG_evacuated_civs + " evacuated, " + str YUG_remaining_civs + " remaining.",
				(_x call BIS_fnc_taskDescription) select 1,
				(_x call BIS_fnc_taskDescription) select 2
			]
		] call BIS_fnc_taskSetDescription;
	};
} forEach ["un_civs", "serb_civs"];


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

		if (!isNull (assignedVehicle _unit)) then {
			private _vehicle = assignedVehicle _unit;
			if (isNull (driver _vehicle) || ((driver _vehicle) == _unit && typeOf _vehicle in _vehicles) || !alive _vehicle || _unit distance _vehicle > 50) then {
				private _group = group _unit;
				[_unit] orderGetIn false;
				_group leaveVehicle _vehicle;
			};
		};

	} forEach YUG_msta_civs;

};