// DESATURATES THE SCREEN OVER THE GIVEN DURATION

if (!hasInterface) exitWith {};

private _time = _this;

private _name = "ColorCorrections";
private _priority = 1500;
private _effect = [1, 0.4, 0, [0, 0, 0, 0], [1, 1, 1, 0], [1, 1, 1, 0]];

private "_handle";

while {
	_handle = ppEffectCreate [_name, _priority];
	_handle < 0
} do {
	_priority = _priority + 1;
};

_handle ppEffectEnable true;
_handle ppEffectAdjust _effect;
_handle ppEffectCommit _time;

// uiSleep _time;

waitUntil {ppEffectCommitted _handle};