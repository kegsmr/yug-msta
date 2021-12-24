// DELETES OBJECTS ONCE NOT SIMULATED OR ONCE THE OBJECTS ARE FAR ENOUGH AWAY

if (!isServer) exitWith {};

private _objects = _this;

if (MALO_init) exitWith {
	{deleteVehicle _x;} forEach _objects;
};

private _radius = MALO_CFG_view_distance;		// THE DEFAULT DISTANCE FOR DESPAWNING


{
	if !(dynamicSimulationEnabled _x) then {
		_objects deleteAt _forEachIndex;
		[_x, _radius] spawn {
			params ["_object", "_radius"];
			waitUntil {_object distance (_object call MALO_fnc_getNearestPlayer) > _radius};
			deleteVehicle _object;
		};
	};
} forEach _objects;

while {count _objects > 0} do {
	private _delay = MALO_delay * 10;			
	{
		if !(simulationEnabled _x) then {
			_objects deleteAt _forEachIndex;
			deleteVehicle _x;
		};
	} forEach _objects;
	sleep _delay;
}; 