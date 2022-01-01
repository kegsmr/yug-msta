// REDUCES COMBAT MODE SPAM

if (false) exitWith {};

private _prefix = "YUG";

private _group = _this select 0;
private _mode = _this select 1;
private _delay = _this select 2;

if (isNil "_delay") then {
	_delay = 10;
};

if (combatMode _group == _mode) exitWith {};

private _lastChange = _group getVariable [_prefix + "_lastCombatModeChange", 0];

if (time < _lastChange + _delay) exitWith {};

_group setVariable [_prefix + "_lastCombatModeChange", time, true];
_group setCombatMode _mode;