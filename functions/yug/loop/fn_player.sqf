// RUNS LOCALLY

if (!hasInterface) exitWith {};


// PREVENTS PLAYERS FROM BEING KILLED BY FRIENDLY AI BECAUSE OF TEAMKILLING OR CIVILIAN KILLS

if ((rating player < 0)) then {
	player addRating abs (rating player)
};