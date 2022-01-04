// DELETES OBJECTS ONCE NOT SIMULATED OR ONCE THE OBJECTS ARE FAR ENOUGH AWAY

// USAGE EXAMPLE
/*
	private _objects = [object1, object2, object3];
	_objects spawn PREFIX_fnc_deleteObjects;
*/

// SETTINGS
private _radius = 500;		
	// THE DEFAULT DISTANCE FOR DESPAWNING
private _delay = 10;
	// TIME TO WAIT BEFORE CHECKING IF THE OBJECTS CAN BE DELETED
//


if (!isServer) exitWith {};

private _objects = _this;

{
	if !(dynamicSimulationEnabled _x) then {
		_objects deleteAt _forEachIndex;
		[_x, _radius] spawn {
			params ["_object", "_radius"];
			waitUntil {_object distance (_object call YUG_fnc_getNearestPlayableUnit) > _radius};
			deleteVehicle _object;
		};
	};
} forEach _objects;

while {count _objects > 0} do {
	{
		if !(simulationEnabled _x) then {
			_objects deleteAt _forEachIndex;
			deleteVehicle _x;
		};
	} forEach _objects;
	sleep _delay;
}; 