// FINDS A NEARBY VEHICLE OF A SPECIFIC TYPE AND ORDERS THE GROUP TO GET IN THE VEHICLE

// USAGE EXAMPLE
/*
	[_group, types, _radius] spawn PREFIX_fnc_findNearbyVehicles;
*/

// ISSUES
/*
	- CAUSES ERRORS
	- DOES NOT WORK
*/

/*if (false) exitWith {};

private _group = _this select 0;
private _types = _this select 1;
private _radius = _this select 2;

private _leader = leader _group;

if (isPlayer _leader || _leader != vehicle _leader) exitWith {};

private _vehicles = nearestObjects [_leader, _types, _radius];

if (count _vehicles < 1) exitWith {};

// try {

	private _vehicle = _vehicles select {alive _x};

	_group addVehicle _vehicle;
	units _group orderGetIn true;

// } catch {

	_exception

// };*/