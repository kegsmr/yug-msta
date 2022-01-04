// CREATES A TEMPORARY LOCAL MARKER WHERE THE PLAYER DIES

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_deathMarkers;
*/

if (!hasInterface) exitWith {};

player addEventHandler ["Killed", {
	
	private _unit = (_this select 0);
	private _position = position _unit;

	private _marker = createMarkerLocal [((str (owner _unit)) + "_death_t_" + (str time)), _position];
	
	_marker setMarkerTypeLocal "mil_destroy";
	_marker setMarkerColorLocal "ColorBlack";
	_marker setMarkerAlphaLocal .5;
	_marker setMarkerDirLocal 45;
	_marker setMarkerSizeLocal [.5, .5];

	private _fnc = {

		params ["_marker"];
		
		sleep 600;

		_i = 0;
		for "_i" from 0 to 100 do {
			_marker setMarkerAlphaLocal (1 - (_i / 100));
			uisleep .05;
		};

		deleteMarkerLocal _marker;

	};

	_marker spawn _fnc;

}];