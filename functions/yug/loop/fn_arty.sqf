// SCRIPTS AI ARTY

// USAGE EXAMPLE
/*
	while {true} do {
		call PREFIX_fnc_arty;
		sleep _delay;
	};
*/

// PREFIX
private _prefix = "YUG";
private _script = "arty";
private _PS = _prefix + "_" + _script;
//

// SETTINGS
private _guns = [serb_gun];	
	// GUNS THAT WILL BE USED ON THE FIRING MISSION
private _rounds = 9;	
	// NUMBER OF ROUNDS
private _type = 0;	
	// TYPE OF AMMO
private _infinite = true;	
	// INFINITE AMMO

private _timeVarname = _PS + "_lastArty";	
	// VARIABLE NAME FOR THE TIME THAT THE LAST FIRING MISSION OCCURED
private _delay = 900;
	// MINIMUM DELAY BETWEEN FIRING MISSIONS

private _targets = [getMarkerPos "arty_1", getMarkerPos "arty_2", getMarkerPos "arty_3", getMarkerPos "arty_4", getMarkerPos "arty_5", getMarkerPos "arty_6"];	
	// TARGET POSITIONS
private _spread = 50;
	// RADIUS IN WHICH THE TARGET MAY BE PLACED IN

private _checkForFriendlies = true;
	// ONLY DOES FIRING MISSION WHEN FRIENDLIES ARE CLEARED OF THE AREA
private _triggerName = _PS + "_friendlyTrigger";
	// VARIABLE NAME FOR TRIGGER
private _side = east;
	// FRIENDLY SIDE
private _distance = 100;
	// SAFE DISTANCE

private _condition = !isPlayer (missionNamespace getVariable ["kapetan", allUnits select 0]);
	// CONDITION THAT MUST BE TRUE FOR THE FIRING MISSION TO BEGIN
//


if (!isServer) exitWith {};


// CHECK IF SCRIPT IS ALREADY SPAWNED

private _queuedVarname = _PS + "_artyQueued";
private _queued = missionNamespace getVariable [_queuedVarname, false];
if (_queued) exitWith {};


// CHECK CONDITION

if (!_condition) exitWith {};


// SET INITIAL TIME VALUE

if (isNil _timeVarname) then {
	missionNamespace setVariable [_timeVarname, 0, true];
};


// INFINITE AMMO

{
	private _gun = _x;
	_gun setVehicleAmmo 1;
} forEach _guns;


// SELECT TARGET

private _target = selectRandom _targets;
_target = [[[_target, _spread]],[]] call BIS_fnc_randomPos;


// CHECK FOR FRIENDLIES

if (isNil _triggerName) then {
	private _trigger = createTrigger ["EmptyDetector", _target];
	_trigger setTriggerArea [_distance, _distance, 0, false];
	_trigger setTriggerActivation [str _side, "NOT PRESENT", true];
	missionNamespace setVariable [_triggerName, _trigger];
};

private _trigger = missionNamespace getVariable _triggerName;

_trigger setPos _target;

if (_checkForFriendlies) then {
	_trigger setTriggerStatements ["this", "", ""];
} else {
	_trigger setTriggerStatements ["true", "", ""];
};


// FIRE MISSION

private _last = missionNamespace getVariable [_timeVarname, 0];

if (time > _last + _delay) then {

	[_timeVarname, _queuedVarname, _trigger, _guns, _type, _target, _rounds] spawn {

		private _timeVarname = _this select 0;
		private _queuedVarname = _this select 1;
		private _trigger = _this select 2;
		private _guns = _this select 3;
		private _type = _this select 4;
		private _target = _this select 5;
		private _rounds = _this select 6;

		private _time = time;

		missionNamespace setVariable [_queuedVarname, true];

		waitUntil {time > _time + 5 || triggerActivated _trigger};
		if (time > _time + 5) exitWith {
			missionNamespace setVariable [_queuedVarname, false];
		};

		missionNamespace setVariable [_timeVarname, time];

		missionNamespace setVariable [_queuedVarname, false];
		
		{
			private _gun = _x;
			private _ammo = getArtilleryAmmo [_gun] select _type; 
			_gun doArtilleryFire [_target, _ammo, _rounds];
		} forEach _guns;

	};

};