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
		private _seconds = _time - (60 * _minutes);

		if (_minutes < 0) then {
			_minutes = 0;
		};

		if (_seconds < 0) then {
			_seconds = 0;
		};

		_seconds = str _seconds;

		if (count _seconds < 2) then {
			_seconds = "0" + _seconds;
		};

		(str _minutes + ":" + _seconds) remoteExec ["hintSilent", 0];

		sleep .1;

	};

	"" remoteExec ["hintSilent", 0];

	YUG_timerActive = false;

};

YUG_fnc_evacuation_helmets = {
	private _unit = _this select 0;
	private _headgear = headgear _unit;
	private _in = "";
	private _out = "";
	private _vehicleType = "";
	if (typeOf _unit == "LOP_UN_Infantry_Pilot") then {
		_in = "rhs_zsh7a_mike";
		_out = "LOP_H_6B27M_UN";
		_vehicleType = "CUP_I_Mi17_UN";
	} else {
		_in = "rhs_tsh4";
		_out = "";
		_vehicleType = "KOS_YUG_t72_grom";
	};
	if ((typeof vehicle _unit == _vehicleType) && (_headgear == _out)) then {
		_unit addHeadgear _in;
	} else {
		if (_headgear == _in) then {
			if (_out == "") then {
				removeHeadgear _unit;
			} else {
				_unit addHeadgear _out;
			};
		};
	};
};

YUG_fnc_evacuation_supportChopper = {
	private _vehicle = _this;
	private _units = crew _vehicle;
	_vehicle setVariable ["YUG_supportChopper", true, true];
	{
		private _unit = _x;
		[_unit, [missionNamespace, "YUG_loadout_unPilot"]] call BIS_fnc_loadInventory;
	} forEach _units;
};


if (missionNamespace getVariable ["YUG_evacuation_started", false] == false) then {

	missionNamespace setVariable ["YUG_evacuation_started", true, true];


	// CREATE LIST OF MSTA CIVS

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


	// CHANGE UN PILOT HELMETS ON EVENTS

	{
		private _unit = _x;
		if (typeOf _unit in ["LOP_UN_Infantry_Pilot", "O_Serbia_Crew_01"]) then {
			{
				private _name = _x;
				_unit addEventHandler [_name, {
					_this spawn YUG_fnc_evacuation_helmets;
				}];
			} forEach ["GetInMan", "GetOutMan", "Respawn"];
		};
	} forEach playableUnits;


	// ADD WAYPOINTS FOR SL's ON RESPAWN

	/*{
		private _unit = _x;
		if ((_unit == leader group _unit) && (!isPlayer _unit)) then {
			_unit addMPEventHandler ["MPRespawn", {
				_this spawn {
					private _unit = _this select 0;
					private _group = group _unit;
					if (_group == serb_tank_squad) then {


						// SERB TANK SQUAD

						waitUntil {alive serb_tank || !alive _unit};
						if (alive _unit) then {
							private _waypoint = _group addWaypoint [serb_tank, 0];
							_waypoint setWaypointType "GETIN";
							while {(vehicle _unit == _unit) && (alive _unit)} do {
								// _group setCurrentWaypoint _waypoint;
								sleep 10;
								if (!isPlayer _unit && _unit distance serb_tank < 50) then {
									_unit moveInCommander serb_tank;
									{
										if (!isPlayer _x) then {
											_x moveInAny serb_tank;
										};
									} forEach [serb_tankD, serb_tankG];
								}
							};
							if (alive _unit) then {
								private _waypoint = _group addWaypoint [getMarkerPos "msta", 0];
								// _group setCurrentWaypoint _waypoint;
							}
						}

					} else {
						if (_group != serb_tank_squad) then {


							// INFANTRY SQUADS

							private _waypoint = _group addWaypoint [position _unit, 0];
							_waypoint setWaypointType "GETIN NEAREST";
							// _group setCurrentWaypoint _waypoint;
							// _group addWaypoint [getMarkerPos "msta", 0];
							/*waitUntil {sleep 1; (vehicle _unit != _unit) || (!alive _unit)};
							if (alive _unit) then {
								waypoint = _group addWaypoint [getMarkerPos "msta", 0];
								_group setCurrentWaypoint _waypoint;
							}
							private _objects = nearestObjects [_unit, ["SRB_uaz_2", "O_ORepublikaSrpska_GAZ_66_01"], 500];
							if (count _objects > 0) then {
								private _object = _objects select 0;
								private _waypoint = _group addWaypoint [_object, 0];
								_waypoint setWaypointType "GETIN";
								_group setCurrentWaypoint _waypoint;
							};
							_group addWaypoint [getMarkerPos "msta", 0];
						};
					};


					// ALL UNITS

					if ((side _unit != independent) || (YUG_evacuated_civs < 30 || YUG_killed_civs < 21)) then {
						_group addWaypoint [getMarkerPos "msta", 1];
					};

				};
			}];
		};
	} forEach playableUnits;*/


	// TIMER SUBTRACTING EVENT HANDLERS

	YUG_peacekeepersKilled = 0;

	{
		private _unit = _x;
		_unit addMPEventHandler ["MPKilled", {
			private _unit = _this select 0;
			5 spawn YUG_fnc_subtractTime;
			if (side _unit == independent) then {
				YUG_peacekeepersKilled = YUG_peacekeepersKilled + 1;
			};
		}];
	} forEach units un_squad + YUG_msta_civs; 


};

publicVariable "YUG_msta_civs";


// ADD WAYPOINTS IF ALL ARE COMPLETED

{
	private _group = _x;
	if (_group call YUG_fnc_waypointsComplete) then {
		private _leader = leader _group;
		private _position = getMarkerPos "msta";
		if (_leader distance _position > 500) then {
			if (_group == un_squad) then {
				[_group, ["CUP_I_Mi17_UN", "CUP_I_M113A3_UN", "LOP_UN_Ural", "CUP_I_UAZ_Unarmed_UN"], 500] call YUG_fnc_findNearbyVehicle;
			};
			if (_group == serb_squad) then {
				[_group, ["O_ORepublikaSrpska_GAZ_66_01", "SRB_bm21", "SRB_ural"], 500] call YUG_fnc_findNearbyVehicle;
			};
			if (_group == serb_tank_squad) then {
				[_group, ["KOS_YUG_t72_grom", "SRB_bmp", "SRB_btr"], 2000] call YUG_fnc_findNearbyVehicle;
			};
		};
		_group addWaypoint [_position, 0];
	};
} forEach [un_squad, serb_squad, serb_tank_squad];


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

	if ((!isPlayer _unit) && ((_unit distance2D (getMarkerPos "msta")) > 1500) && ((_unit distance2D (getMarkerPos "respawn_guerilla")) > 100) && (vehicle _unit == _unit)) then {

		_unit spawn {

			private _unit = _this;

			private _trigger = createTrigger ["EmptyDetector", position _unit];
			_trigger setTriggerArea [500, 500, 0, false];
			_trigger setTriggerActivation ["ANYPLAYER", "NOT PRESENT", true];
			_trigger setTriggerStatements ["this", "", ""];

			sleep 5;

			if (triggerActivated _trigger) then {
				_unit setPos (getMarkerPos "logs_spawn");
			};

			deleteVehicle _trigger;

		};

	};

} forEach units un_squad;


// GET UN SL TO LEAVE CHOPPER WHEN LANDED AT MSTA

private _group = un_squad;
private _leader = leader _group;
if (vehicle _leader == un_heli && _leader distance (getMarkerPos "msta") < 500) then {
	sleep 30;
	if (vehicle _leader == un_heli && _leader distance (getMarkerPos "msta") < 500) then {
		private _waypoint = _group addWaypoint [position _leader, 0, currentWaypoint _group];
		_waypoint setWaypointType "GETOUT";
		_group setCurrentWaypoint _waypoint;
	};
};


// KILLED MISSING EVACUATED REMAINING

YUG_killed_civs = {!alive _x} count YUG_msta_civs;
YUG_missing_civs = {_x distance2D _position > 500 && alive _x} count YUG_msta_civs;
YUG_remaining_civs = {_x distance2D _position <= 500 && alive _x} count YUG_msta_civs;

{publicVariable _x;} forEach ["YUG_killed_civs", "YUG_missing_civs", "YUG_evacuated_civs", "YUG_remaining_civs"]; 

{
	private _task = _x;
	private _description = str YUG_killed_civs + " killed, " + str YUG_missing_civs + " missing, " + str YUG_evacuated_civs + " evacuated, " + str YUG_remaining_civs + " remaining.";
	[_task, _description] call YUG_fnc_setTaskDescription;
} forEach ["un_civs", "serb_civs"];

["un_kia", "Peacekeeper casualties look bad on TV. Keep them at a minimum." /*str YUG_peacekeepersKilled + " killed."*/] call YUG_fnc_setTaskDescription;


// PASS/FAIL CONDITIONS FOR TASKS

private _condition1 = YUG_evacuated_civs >= 30;
private _condition2 = YUG_killed_civs > 20;
if ((_condition1 || _condition2) && !(missionNamespace getVariable ["YUG_civTaskComplete", false])) then {
	if (_condition1) then {
		["serb_civs", "FAILED"] call BIS_fnc_taskSetState;
		["un_civs", "SUCCEEDED"] call BIS_fnc_taskSetState;
	} else {
		if (_condition2) then {
			["serb_civs", "SUCCEEDED"] call BIS_fnc_taskSetState;
			["un_civs", "FAILED"] call BIS_fnc_taskSetState;
		};
	};
	trg_rtb spawn YUG_fnc_activateTrigger;
	["un_defend", "CANCELED"] call BIS_fnc_taskSetState;
	missionNamespace setVariable ["YUG_civTaskComplete", true, true];
	private _leader = leader un_squad;
	if (_leader distance un_heli < 1000) then {
		private _waypoint = un_squad addWaypoint [un_heli, 0];
		_waypoint setWaypointType "GETIN";
	} else {
		private _waypoint = un_squad addWaypoint [position _leader, 0];
		_waypoint setWaypointType "GETIN NEAREST";
	};
	un_squad addWaypoint [getMarkerPos "refugee_marker", 0];
	private _units = [];
	if (!isPlayer _leader) then {
		_units append (units un_squad);
	} else {
		_units append [_leader];
	};
	{
		private _unit = _x;
		[_unit, "endMission"] call BIS_fnc_addCommMenuItem;
	} forEach _units;
};

if (YUG_peacekeepersKilled > 20) then {
	["un_kia", "FAILED"] call BIS_fnc_taskSetState;
};


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
				if (side (driver _object) == independent && !(_object getVariable ["YUG_supportChopper", false]) && ({alive _x && side _x == independent} count (crew _object) < 4)) then {
					private _group = group _unit;
					_group addVehicle _object;
					[_unit] orderGetIn true;
					_unit enableAI "ALL";
					if ((vehicle _unit == _unit) && (lifeState _unit in ["HEALTHY", "INJURED"]) && (speed _unit < 1) && (round (random [0,3,6]) == 3)) then {
						_unit switchMove "";
					};
				}
			}
		} forEach _objects;

	};

	if (!isNull (assignedVehicle _unit)) then {
		private _vehicle = assignedVehicle _unit;
		if ((isNull (driver _vehicle) /*&& !(_vehicle isKindOf "CUP_I_Mi17_UN")*/) || ((driver _vehicle) == _unit && typeOf _vehicle in _vehicles) || !alive _vehicle || _unit distance _vehicle > 500 || (_vehicle distance getMarkerPos "refugee_marker" < 150)) then {
			private _group = group _unit;
			[_unit] orderGetIn false;
			_group leaveVehicle _vehicle;
		};
	};

} forEach YUG_msta_civs;