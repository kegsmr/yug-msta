// AVOIDS COMBAT MODE SPAM

// USAGE EXAMPLE
/*
	private _group = mySquad;
	private _mode = "RED";
	private _delay = 0;	
		// (OPTIONAL)
	[_group, _mode, _delay] call PREFIX_fnc_setCombatMode;
*/

// PREFIX
private _prefix = "YUG";
private _script = "combatMode";
private _PS = _prefix + "_" + _script;
//

if (false) exitWith {};

private _group = _this select 0;
private _mode = _this select 1;
private _delay = _this select 2;

if (isNil "_delay") then {
	_delay = 10;
};

if (combatMode _group == _mode) exitWith {};

private _lastChangeVarname = _PS + "_lastCombatModeChange";
private _lastChange = _group getVariable [_lastChangeVarname, 0];

if (time < _lastChange + _delay) exitWith {};

_group setVariable [_lastChangeVarname, time, true];
_group setCombatMode _mode;