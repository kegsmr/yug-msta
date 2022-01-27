// ACTIVATES A TRIGGER INSTANTLY

// USAGE EXAMPLE
/*
	private _trigger = trg_rtb;
	_trigger call PREFIX_fnc_activateTrigger;
*/

if (false) exitWith {};

params ["_trigger"];

_statements = triggerStatements _trigger;
_statements set [0, "true"];

_trigger setTriggerTimeout [0, 0, 0, false];
_trigger setTriggerStatements _statements;