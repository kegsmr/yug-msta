// RETAINS CUSTOM LOADOUTS AFTER RESPAWN FOR PLAYABLE UNITS

if (false /*!isServer*/) exitWith {};

{
	private _unit = _x;
	[_unit, [_unit, "YUG_startingInventory"]] call BIS_fnc_saveInventory;
	_unit addMPEventHandler ["MPRespawn", {
		private _unit = _this select 0;
		[_unit, [_unit, "YUG_startingInventory"]] call BIS_fnc_loadInventory;
	}];
} forEach playableUnits;