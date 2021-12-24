// DEALS WITH CIVILIAN BEHAVIOR

if (!isServer) exitWith {};
// if (!MALO_CFG_advanced_ai) exitWith {};

YUG_flee_limit = 100;

YUG_flee_count = 0;


// MAKES CIV FLEE TO NEAREST BUILDING

YUG_fnc_civs_flee = {

	params ["_civ"];

	if (_civ getVariable ["fleeing", false]) exitWith {};

	_civ setVariable ["fleeing", true, true];
	
	private _building_types = YUG_building_types;
	private _vehicle_types = YUG_civ_vehicles;
	private _search_radius = 500;
	private _civ_radius = 2000 /*MALO_simulation_distance*/;
	private _delay = random [0, 45, 60];
	
	private _fear = _civ getVariable ["fear", 1];
	private _random = _civ getVariable ["random", 0];

	if (_random <= _fear) then {

		if (!alive _civ) exitWith {};

		_civ switchMove "";
		
		switch (round(random 2)) do {
					
			case 0: {_civ switchMove "ApanPercMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
			case 1: {_civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
			case 2: {_civ playMoveNow "ApanPpneMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
			default {_civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
		
		};

		if (selectRandom [true, false]) then {

			private _objects = nearestObjects [_civ, _building_types, _search_radius];

			private _positions = [(getMarkerPos "refugee_marker")];
			{
				{_positions append [_x];} forEach (_x buildingPos -1);
			} forEach _objects;

			private _position = selectRandom _positions;

			_civ doMove _position;

		} else {

			private _objects = nearestObjects [_civ, ["CAR","TRUCK"], _search_radius];

			private _vehicles = [];
			{
				if ((isNull driver _x) && (typeof _x in _vehicle_types)) then {
					_vehicles append [_x];
				};
			} forEach _objects;

			if (count _vehicles > 0) then {
				private _vehicle = selectRandom _vehicles;
				(group _civ) addVehicle _vehicle;
				(group _civ) addWaypoint [(getMarkerPos "refugee_marker"), 0];
				[_civ] orderGetIn true;
			};
			
			_civ doMove (getMarkerPos "refugee_marker");
		};

		YUG_flee_count = YUG_flee_count + 1;

		sleep 5;
		private _animation_state = animationState _civ;
		waitUntil {(animationState _civ != _animation_state) || (_civ distance (_civ call YUG_fnc_getNearestPlayer) > _civ_radius) || (YUG_flee_count > YUG_flee_limit)};

		YUG_flee_count = YUG_flee_count - 1;

		/*_civ switchMove "";*/
	
	};

	_civ setVariable ["fleeing", false, true];

};


// RUNS LOCALLY AND ADDS CURSOR TARGET TO AN ARRAY

YUG_fnc_civs_targets = {

	if (!hasInterface) exitWith {};
	
	private _object = cursorObject;

	if (_object in YUG_cursor_targets) exitWith {};

	if ((primaryWeapon player != "") && (cameraView == "GUNNER")) then {

		if (_object isKindOf "MAN") then {

			YUG_cursor_targets append [_object];
			publicVariable "YUG_cursor_targets";

			_object spawn YUG_fnc_civs_targeted;

		} else {

			if ((!isNil {driver _object}) && (speed _object < 1)) then {

				{

					private _unit = _x select 0;
					_unit spawn YUG_fnc_civs_targeted;

				} forEach (fullCrew _object);

			};

		};

	};

};


// RUNS WHEN A UNIT IS TARGETED BY A PLAYER

YUG_fnc_civs_targeted = {

	params ["_unit"];

	_unit setVariable ["targeted", true, true];

	private _fleeing = _unit getVariable ["fleeing", false];
	private _surrender = _unit getVariable ["surrender", false];

	if (vehicle _unit != _unit) then {
		(group _unit) leaveVehicle (vehicle _unit);
	};

	if !(_surrender || _fleeing) then {
		_unit setVariable ["surrender", true, true];
		_unit spawn YUG_fnc_civs_surrender;
	};

	while {_unit in YUG_cursor_targets} do {
		waitUntil {if (_unit in YUG_cursor_targets) then {false} else {true}};
		sleep 5;
	};

	sleep 1;

	_unit setVariable ["targeted", false, true];

};


// MAKES CIV SURRENDER

YUG_fnc_civs_surrender = {

	params ["_civ"];

	private _fear = _civ getVariable ["fear", 1];
	private _armed = _civ getVariable ["armed", true];
	private _random = _civ getVariable ["random", 0];

	if (_random <= _fear && !_armed) then {
		
		if (vehicle _civ != _civ) then {
			waitUntil {sleep 1; (vehicle _civ == _civ)};
			_civ action ["Surrender", _civ];
			sleep (random [3,5,10]);
		};

		_civ action ["Surrender", _civ];

		while {_civ in YUG_cursor_targets} do {
			waitUntil {if (_civ in YUG_cursor_targets) then {false} else {true}};
			sleep (random [1, 2, 3]);
		};

		if (!alive _civ) exitWith {};

		_civ switchMove "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnonDnon";

		sleep 1;

		// [_civ] spawn MALO_fnc_civs_flee;

	};

	sleep 1;

	_civ setVariable ["surrender", false, true];

};


// MAKE A LIST OF CURSOR TARGETS

YUG_cursor_targets = [];
publicVariable "YUG_cursor_targets";
remoteExec ["YUG_fnc_civs_targets", 0];


// LOOP THROUGH NEARBY UNITS

private _units = [];
{_units append (nearestObjects [_x, ["MAN"], 2000 /*MALO_simulation_distance*/]);} forEach playableUnits;

/*private _close_units = [];
{_units append (nearestObjects [_x, ["MAN"], 10]);} forEach playableUnits;

private _serb_units = [];
{_serb_units append (missionNamespace getVariable [_x + "_civs", []]);} forEach serb_villages;*/

{

	if (!isPlayer _x) then {

		// DETERMINE IF UNIT IS ARMED OR UNARMED
		if (alive _x) then {
			if (_x call YUG_fnc_isArmed) then {
				_x setVariable ["armed", true, true];
			} else {
				_x setVariable ["armed", false, true];
			};
		};

		private _fear = _x getVariable ["fear", 1];
		private _armed = _x getVariable ["armed", false];
		private _will_flee = _x getVariable ["willFlee", false];
		private _fleeing = _x getVariable ["fleeing", false];
		private _targeted = _x getVariable ["targeted", false];
		private _surrender = _x getVariable ["surrender", false];

		// IF A CIV ISN'T MOVING WHILE IN A VEHICLE
		if (((speed (vehicle _x)) < 1) && (vehicle _x != _x) && !_armed && !(count waypoints _x > 1)) then {
			_x doMove (getMarkerPos "refugee_marker");
			(group _x) addWaypoint [(getMarkerPos "refugee_marker"), 0];
		};

		// IF A CIV IS IN A VEHICLE WITHOUT A DRIVER
		if ((vehicle _x != _x) && (isNull (driver vehicle _x)) && !_armed) then {
			_x moveInDriver (vehicle _x);
		};
		
		// BEHAVIOR EVENTS

		if !(_will_flee || _armed || _fleeing) then {
			
			private _random = ((random [0, 50, 100]) / 100);
			
			_x setVariable ["random", _random, true];
			_x setVariable ["willFlee", true, true];


			// FLEE IF FIRED NEAR

			_x addEventHandler ["FiredNear", {

				private _civ = _this select 0;
				_civ spawn YUG_fnc_civs_flee;
				_civ setVariable ["willFlee", false, true];
				_civ removeEventHandler ["FiredNear", _thisEventHandler];

			}];

		};

	};

} forEach _units;