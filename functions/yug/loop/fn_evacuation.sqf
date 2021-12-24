// DEALS WITH EVACUATION MISSION

YUG_evacuated_civs = 0;

private _marker = "msta";
private _position = getMarkerPos _marker;
private _radius = 250;

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