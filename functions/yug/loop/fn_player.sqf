// RUNS LOCALLY

if (!hasInterface) exitWith {};


// PREVENTS PLAYERS FROM BEING KILLED BY FRIENDLY AI BECAUSE OF TEAMKILLING OR CIVILIAN KILLS

if ((rating player < 0)) then {
	player addRating abs (rating player)
};


// UN CHOPPER MARKER

private _vehicle = un_heli;
private _marker = "un_heli";
if (side player == independent && alive _vehicle) then {
	private _position = _vehicle;
	private _crew = crew _vehicle;
	private _civsCount = {side _x == civilian && alive _x} count _crew;	
	_marker setMarkerAlphaLocal 1;
	_marker setMarkerPosLocal _position;
	_marker setMarkerTextLocal str _civsCount;
} else {
	_marker setMarkerAlphaLocal 0;
};