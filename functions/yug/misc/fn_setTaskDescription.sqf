// SETS A TASK'S DESCRIPTION, BUT ONLY THE DESCRIPTION

// USAGE EXAMPLE
/*
	private _task = myTask;
	private _description = "Do the thing please";
	[_task, _description] call PREFIX_fnc_setTaskDescription;
*/

if (false) exitWith {};

private _task = _this select 0;
private _description = _this select 1;

if ([_task] call BIS_fnc_taskExists) then {
	[
		_task,
		[
			_description,
			(_task call BIS_fnc_taskDescription) select 1,
			(_task call BIS_fnc_taskDescription) select 2
		]
	] call BIS_fnc_taskSetDescription;
};