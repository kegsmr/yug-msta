// SCRIPTS AI ARTY

if (!isServer) exitWith {};

private _gun = serb_gun;
private _rounds = 9;
private _type = 0;
private _infinite = true;
private _target = getMarkerPos "msta";

private _timeVariableName = "YUG_lastArty";
private _delay = 600;

private _condition = !((isPlayer kapetan) || (triggerActivated trg_serbsPresent));


// CHECK CONDITION

if (!_condition) exitWith {};


// SET INITIAL TIME VALUE

if (isNil _timeVariableName) then {
	missionNamespace setVariable [_timeVariableName, 0, true];
};


// INFINITE AMMO

_gun setVehicleAmmo 1;


// FIRE MISSION

private _last = missionNamespace getVariable [_timeVariableName, 0];

if (time > _last + _delay) then {
	
	missionNamespace setVariable [_timeVariableName, time, true];

	private _ammo = getArtilleryAmmo [_gun] select _type; 

	_gun doArtilleryFire [_target, _ammo, _rounds];

};