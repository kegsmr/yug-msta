// SUBTRACTS TIME FROM THE CAPTURE TIMER

if (false) exitWith {};

private _subtract = _this;

private _time = triggerTimeout trg_endMission select 1;
private _subtracted = _time - _subtract;

if (_subtracted < 60) then {
	_subtracted = 60;
};

trg_endMission setTriggerTimeout [_subtracted, _subtracted, _subtracted, true];