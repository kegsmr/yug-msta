// CALLS FUNCTIONS OF A GIVEN PREFIX AND CATEGORY AS DEFINED IN CFGFUNCTIONS

// USAGE EXAMPLE
/*
	private _prefix = "PREFIX";
	private _category = "category";
	[_prefix, _category] call PREFIX_fnc_callFunctions;
*/

if (false) exitWith {};

params ["_prefix", "_category"];

private _configs = "true" configClasses (missionconfigFile >> "CfgFunctions" >> _prefix >> _category);

private _array = [];
{
	_array append [(configname _x)];
} forEach _configs;

private _time_1 = time;

{

	missionNamespace setVariable [(_prefix + "_" + _category + "_current_function"), ("fn_" + _x), false];
	call compile ("
	
		call " + _prefix + "_fnc_" + _x + ";

	");

} forEach _array;

private _time_2 = time;
missionNamespace setVariable [(_prefix + "_" + _category + "_duration"), (_time_2 - _time_1), false];

missionNamespace setVariable [(_prefix + "_" + _category + "_current_function"), "none", false];