// RUNS LOCALLY

if (!hasInterface) exitWith {};


// PREVENTS PLAYERS FROM BEING KILLED BY FRIENDLY AI BECAUSE OF TEAMKILLING OR CIVILIAN KILLS

if ((rating player < 0)) then {
	player addRating abs (rating player)
};


// MAKE DEATH MARKERS

if !(player getVariable ["killedMarkerEventCreated", false]) then {

	player setVariable ["killedMarkerEventCreated", true, true];
	
	player addEventHandler ["Killed", {
		
		private _player = (_this select 0);
		private _position = position _player;

		private _marker = createMarkerLocal [((str (owner _player)) + "_death_t_" + (str time)), _position];
		
		_marker setMarkerTypeLocal "mil_destroy";
		_marker setMarkerColorLocal "ColorBlackAlpha";
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

};

