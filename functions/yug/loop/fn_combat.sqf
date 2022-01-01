// IMPROVES COMBAT REALISM

if (!isServer) exitWith {};
// if (!MALO_CFG_advanced_ai) exitWith {};

YUG_sniper_types = ["I_Bosnia_and_Herzegovina_Sniper_01", "O_Serbia_Sniper_01"];

private _sides = [east, west, independent];
private _radius = 500 /*MALO_simulation_distance*/;


YUG_combat_units = [];
{YUG_combat_units append (nearestObjects [_x, ["MAN"], _radius]);} forEach playableUnits;


// MAKES UNITS GET IN BUILDINGS WHEN FIRED UPON

YUG_fnc_combat_getInside = {
	
	params ["_unit"];

	private _building_types = YUG_building_types;
	private _radius = 50;

	private _objects = nearestObjects [_unit, _building_types, _radius];

	private _positions = [(position _unit)];
	{
		{_positions append [_x];} forEach (_x buildingPos -1);
	} forEach _objects;

	private _position = selectRandom _positions;
	_unit doMove _position;

	/*while {(_unit distance (_unit call MALO_fnc_getNearestPlayer)) < MALO_simulation_distance} do { 
		_unit doMove _position;
		waitUntil {(unitReady _unit) || ((_unit distance (_unit call MALO_fnc_getNearestPlayer)) > MALO_simulation_distance)};
	};*/
	
	sleep (random [0,300,600]);

	_unit setVariable ["willGetInside", false, true];
	
};


// LOOPING THROUGH NEARBY UNITS

{
	
	if ((side _x in _sides) && (!isPlayer _x) && (!isPlayer leader group _x) && (vehicle _x == _x)) then {
		

		// CREATE GET IN BUILDING EVENT HANDLER

		if !(_x getVariable ["willGetInside", false]) then {
			
			_x setVariable ["willGetInside", true, true];

			_x addEventHandler ["FiredNear", {
				private _unit = _this select 0;
				if ((behaviour _x == "SAFE") && (unitPos _x == "UP")) then {
					_x setUnitPos "MIDDLE";
				};
				group _unit setBehaviour "COMBAT";
				_unit spawn YUG_fnc_combat_getInside;
				_unit removeEventHandler ["FiredNear", _thisEventHandler];
			}];

		};

		// CREATE MORALE EVENT HANDLER

		/*if !(_x getVariable ["killedMoraleEventHandlerCreated", false]) then {

			_x setVariable ["killedMoraleEventHandlerCreated", true, true];

			_x addEventHandler ["Killed", {
				private _unit = _this select 0;
				private _group = group _unit;
				_group setVariable ["morale", ((_group getVariable ["morale", 100]) - (100 / (count units _group))), true]
			}];

		};*/


		// ENABLE ALL AI IF ENEMY WITHIN TEN METERS

		if ((_x distance (_x findNearestEnemy _x) < 10) /*&& (typeOf _x != "LOP_UN_Infantry_Rifleman")*/) then {
			_x enableAi "ALL";
		};


		// SURRENDER IF MORALE LOW ENOUGH
		/*if ((((group _x) getVariable ["morale", 100]) < 20) && (side _x != east)) then {

			if (_x getVariable ["targeted", false]) then {
				private _group = createGroup civilian;
				[_x] joinSilent _group;
				[_x] spawn YUG_fnc_deleteObjects;
				_x spawn {
					_this disableAi "MOVE"; 
					waitUntil {!(_this isEqualTo objNull) || !(alive _this) || !(_this getVariable ["surrender", false])};
					sleep 5;
					removeAllWeapons _this;
					while {!(_this isEqualTo objNull) && (alive _this)} do {
						_this switchmove "boundCaptive_loop";
						sleep MALO_delay;
					};
				};
			};
		};*/
		

		// FREEZE SAFE UNITS IF IN A GROUP OF TWO OR MORE

		/*if ((count units group _x > 1) && (vehicle _x == _x) && !(count waypoints group _x > 1)) then {
			if (_x call BIS_fnc_enemyDetected) then {
				_x enableAi "ALL";
			} else {
				_x disableAI "PATH";
			};
		};*/


		// BEHAVIOR

		private _unit = _x;
		private _group = group _unit;

		private _aggressive = _group getVariable ["aggressive", false];
		private _stealthy = _group getVariable ["stealthy", false];
		private _morale = _group getVariable ["morale", 100];

		if (_unit call BIS_fnc_enemyDetected) then {

			if ((behaviour _unit) == "SAFE") then {
				
				if (_stealthy) then {
					_group setBehaviour "STEALTH";
				} else {
					_group setBehaviour "AWARE";
				};
			
			};

		} else {

			_group setBehaviour "SAFE";

		};

		if (behaviour _unit == "AWARE" && !(count waypoints _group > 1)) then {

			_group setBehaviour "COMBAT";

		};


		// COMBAT MODES AND SPEED MODES

		private _unit = _x;
		private _group = group _unit;

		private _sniper = (if (typeOf _unit in YUG_sniper_types) then {true} else {false});
		private _in_vehicle = vehicle _unit != _unit;
		private _enemy_spotted = _unit call BIS_fnc_enemyDetected;
		private _aggressive = _group getVariable ["aggressive", false];
		private _morale = _group getVariable ["morale", 100];

		if (_sniper || _in_vehicle) then {

			_group setSpeedMode "FULL";
			[_group, "RED"] call YUG_fnc_setCombatMode;

		} else {

			if (!_enemy_spotted) then {

				_group setSpeedMode "NORMAL";

				if (count waypoints _group > 1) then {
					[_group, "GREEN"] call YUG_fnc_setCombatMode;
				} else {
					[_group, "WHITE"] call YUG_fnc_setCombatMode;
				};

			} else {
				
				if (_aggressive && _morale > 20) then {

					_group setSpeedMode "FULL";
					[_group, "RED"] call YUG_fnc_setCombatMode;

				} else {

					_group setSpeedMode "FULL";

					if (time - (_group getVariable ["enemy_distance_last_updated", 0]) > (/*MALO_delay **/ 10)) then {
						_group setVariable ["enemy_distance_last_updated", time, true];
						private _enemy_distance = "none";
						{
							private _unit = _x;
							private _unit_enemy_distance = _unit distance (_unit findNearestEnemy _unit);
							if (_enemy_distance isEqualTo "none") then {
								_enemy_distance = _unit_enemy_distance;
							} else {
								if (_enemy_distance > _unit_enemy_distance) then {
									_enemy_distance = _unit_enemy_distance;
								};
							};
						} forEach units _group;
						_group setVariable ["enemy_distance", _enemy_distance, true];
					};
					private _distance = _group getVariable ["enemy_distance", 0];

					private _mid = 100;
					private _far = 300;
					private _range = "close";
					if (_distance > _mid) then {
						_range = "mid";
					} else {
						if (_distance > _far) then {
							_range = "far";
						};
					};

					switch (_range) do {
						
						case "close": {
							if (_morale < 20) then {
								[_group, "YELLOW"] call YUG_fnc_setCombatMode;
								_unit enableAi "ALL";
								_unit doMove (getMarkerPos "west_retreat_marker");
							} else {
								[_group, "RED"] call YUG_fnc_setCombatMode;
							};
						};

						case "mid": {
							if (_morale < 40) then {
								[_group, "BLUE"] call YUG_fnc_setCombatMode;
							} else {
								[_group, "WHITE"] call YUG_fnc_setCombatMode;
							};
						};
						
						case "far": {
							if (_morale < 60) then {
								[_group, "BLUE"] call YUG_fnc_setCombatMode;
							} else {
								[_group, "WHITE"] call YUG_fnc_setCombatMode;
							};
						};
						
						default {};
					
					};
				
				};

			};

		};


		// FORMATIONS AND UNIT POSITIONS

		private _unit = _x;
		private _group = group _unit;

		private _can_move = (_unit checkAIFeature "MOVE") && (_unit checkAIFeature "PATH");
		private _behavior = behaviour _unit;
		private _unit_pos = unitPos _unit;

		if (_can_move) then {

			switch (_behavior) do {

				case "SAFE": {

					_group setFormation "FILE";

					if (_unit_pos == "DOWN") then {
						_unit setUnitPos "MIDDLE";
					} else {
						_unit setUnitPos "AUTO";
					};

				};
				
				case "AWARE": {

					_group setFormation "FILE";

					if ((speed (vehicle _unit))  == 0) then {
						_unit setUnitPos "MIDDLE";
					} else {
						_unit setUnitPos "UP";
					};

				};

				case "COMBAT": {

					_group setFormation "FILE";
					_unit setUnitPos "AUTO";

				};

				case "STEALTH": {

					_group setFormation "FILE";
					_unit setUnitPos "AUTO";

				};

				default {};

			};

		};

	};


	// MAKE UN UNITS HOSTILE WHEN A GUN IS POINTED AT THEM

	/*if (typeOf _x == "LOP_UN_Infantry_Rifleman") then {

		private _unit = _x;
		
		private _targeted = _unit getVariable ["targeted", false];
		private _armed = _unit call YUG_fnc_isArmed;

		YUG_fnc_combat_unHostile = {
			params ["_unit"];
			private _group = createGroup west;
			(units (group _unit)) joinSilent _group;
			{_x enableAi "ALL";} forEach units _group;
		};

		if (_targeted && _armed) then {
			_unit spawn YUG_fnc_combat_unHostile;
		};

		if !(_unit getVariable ["hitHostileEventHandlerCreated", false]) then {
			_unit setVariable ["hitHostileEventHandlerCreated", true, true];
			{
				_unit addEventHandler [_x, {
					_unit spawn MALO_fnc_combat_unHostile;
				}];

			} forEach ["Hit", "Killed"];
		};

	};*/

} forEach YUG_combat_units;