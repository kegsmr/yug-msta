// RETAINS CUSTOM LOADOUTS AFTER RESPAWN FOR PLAYABLE UNITS

if (false) exitWith {};

{
	private _unit = _x;
	[_unit, [_unit, "YUG_startingInventory"]] call BIS_fnc_saveInventory;
	_unit addEventHandler ["Respawn", {
		private _unit = _this select 0;
		// if (isPlayer _unit) exitWith{};
		[_unit, [_unit, "YUG_startingInventory"]] call BIS_fnc_loadInventory;
	}];
} forEach playableUnits;