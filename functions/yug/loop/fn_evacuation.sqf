// DEALS WITH EVACUATION MISSION

if (!isServer) exitWith {};

if (isNil "YUG_evacuated_civs") then {
	YUG_evacuated_civs = 0;
};

private _marker = "msta";
private _position = getMarkerPos _marker;
private _radius = 250;

YUG_fnc_evacuation_evacuated = {

	private _unit = _this;
	private _group = group _unit;
	private _vehicle = assignedVehicle _unit;

	private _index = YUG_msta_civs find _unit;
	YUG_msta_civs deleteAt _index;

	YUG_evacuated_civs = YUG_evacuated_civs + 1;

	independent addScoreSide 1;

	[_unit] spawn YUG_fnc_deleteObjects;

	[_unit] orderGetIn false;
	_group leaveVehicle _vehicle;

};

YUG_fnc_evacuation_timer = {

	while {triggerTimeoutCurrent trg_endMission != -1} do {

		private _time = ceil (triggerTimeoutCurrent trg_endMission);
		
		if (_time < 0) then {
			_time = 0;
		};
		
		private _minutes = floor (_time / 60);
		private _seconds = str (_time - (60 * _minutes));

		if (count _seconds < 2) then {
			_seconds = "0" + _seconds;
		};

		(str _minutes + ":" + _seconds) remoteExec ["hintSilent", 0];

		sleep .1;

	};

	"" remoteExec ["hintSilent", 0];

	YUG_timerActive = false;

};


// RUNS ONCE

if (missionNamespace getVariable ["YUG_evacuation_started", false] == false) then {

	missionNamespace setVariable ["YUG_evacuation_started", true, true];

	// east addScoreSide 30;

	YUG_msta_civs = [];

	private _objects = nearestObjects [_position, ["LOP_CHR_Civ_Random"], _radius];
	private _side = civilian;
	{
		
		private _unit = _x;

		if (side _unit == _side) then {

			YUG_msta_civs append [_unit];

			private _trigger = createTrigger ["EmptyDetector", getMarkerPos "refugee_marker", false];
			_trigger setTriggerStatements [str _unit + " in thisList", str _unit + " spawn YUG_fnc_evacuation_evacuated;", ""];
			_trigger setTriggerActivation ["ANY", "PRESENT", false];
			_trigger setTriggerArea [50, 50, 0, false, 20];

		};

	} forEach _objects;

};

publicVariable "YUG_msta_civs";


// STOP SERBS FROM LEAVING AREA WHEN CAPPING

if ((triggerTimeoutCurrent trg_endMission != -1) && !isPlayer kapetan) then {
	kapetan disableAI "PATH";
} else {
	if !(kapetan checkAIFeature "PATH") then {
		kapetan enableAI "PATH";
	};
};


// TELEPORT UN GUYS IF THEYRE TOO FAR AWAY

{

	private _unit = _x;

	if ((!isPlayer _unit) && ((_unit distance2D (getMarkerPos "msta")) > 1500) && ((_unit distance2D (getMarkerPos "respawn_guerilla")) > 500) && (vehicle _unit == _unit)) then {

		_unit spawn {

			private _unit = _this;

			private _trigger = createTrigger ["EmptyDetector", position _unit];
			_trigger setTriggerArea [500, 500, 0, false];
			_trigger setTriggerActivation ["ANYPLAYER", "NOT PRESENT", true];
			_trigger setTriggerStatements ["this", "", ""];

			sleep 5;

			if (triggerActivated _trigger) then {
				_unit setPos (getMarkerPos "castle_spawn");
			};

			deleteVehicle _trigger;

		};

	};

} forEach units un_squad;


// KILLED MISSING EVACUATED REMAINING

YUG_killed_civs = {!alive _x} count YUG_msta_civs;
YUG_missing_civs = {_x distance2D _position > 500 && alive _x} count YUG_msta_civs;
YUG_remaining_civs = {_x distance2D _position <= 500 && alive _x} count YUG_msta_civs;

{publicVariable _x;} forEach ["YUG_killed_civs", "YUG_missing_civs", "YUG_evacuated_civs", "YUG_remaining_civs"]; 

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


// END MISSION TRIGGER

if (YUG_killed_civs > 20 || YUG_evacuated_civs >= 30) then {
	trg_endMission setTriggerTimeout [60, 60, 60, true];
};

if (isNil "YUG_timerActive") then {
	YUG_timerActive = false;
};

if (!YUG_timerActive && (triggerTimeoutCurrent trg_endMission != -1)) then {
	YUG_timerActive = true;
	[] spawn YUG_fnc_evacuation_timer;
};


// LOOPING THROUGH CIVS

{

	private _unit = _x;
	private _vehicles = ["CUP_I_UAZ_Unarmed_UN", "CUP_C_Ikarus_Chernarus", "LOP_UN_Ural"];
	private _helis = ["CUP_I_Mi17_UN"];

	if (alive _unit && (_unit distance2D (getMarkerPos "msta")) <= 500) then {

		private _position = position _unit;
		private _radius = 50;
		private _objects = nearestObjects [_position, _vehicles, _radius];
		_objects append (nearestObjects [_position, _helis, _radius * 10]);

		{
			private _object = _x;
			if (!isNull (driver _object)) then {
				if (side (driver _object) == independent) then {
					private _group = group _unit;
					_group addVehicle _object;
					[_unit] orderGetIn true;
					_unit enableAI "ALL";
					/*if ((vehicle _unit != _unit) && (lifeState _unit in ["HEALTHY", "INJURED"])) then {
						_unit switchMove "";
					};*/
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