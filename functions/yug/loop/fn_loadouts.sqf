// DEALS WITH LOADOUTS

if (false) exitWith {};

if !(missionNamespace getVariable ["YUG_loadoutsAssigned", false]) then {
	
	missionNamespace setVariable ["YUG_loadoutsAssigned", true, false];

	{
		private _group = _x;
		{
			private _unit = _x;
			[_unit, [_unit, "YUG_startingInventory"]] call BIS_fnc_saveInventory;
			_unit addEventHandler ["Respawn", {
				private _unit = _this select 0;
				if (isPlayer _unit) exitWith{};
				[_unit, [_unit, "YUG_startingInventory"]] call BIS_fnc_loadInventory;
			}];
		} forEach units _group;
	} forEach [un_squad, serb_squad, serb_tank_squad];

};