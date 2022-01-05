// RETAINS CUSTOM LOADOUTS AFTER RESPAWN FOR NON-PLAYER PLAYABLE UNITS

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_retainLoadouts;
*/


if (!isServer) exitWith {};

{
	private _unit = _x;
	if (!isPlayer) then {
		[_unit, [_unit, "virtualInventory"]] call BIS_fnc_saveInventory;
		_unit addMPEventHandler ["MPRespawn", {
			private _unit = _this select 0;
			[_unit, [_unit, "virtualInventory"]] call BIS_fnc_loadInventory;
		}];
	};
} forEach playableUnits;