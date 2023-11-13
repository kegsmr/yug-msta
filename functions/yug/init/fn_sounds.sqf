// PLAYS SOUNDS AT MAP MARKERS

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_sounds;
*/

// PREFIX
private _prefix = "YUG";
//

// SETTINGS
private _radius = 200;	
	// THE RADIUS IN WHICH THE PRESENCE OF A PLAYABLE UNIT WILL INHIBIT THE SOUND BEING PLAYED
private _delay = [5, 25, 225];	
	// MIN, MID, MAX VALUES FOR RANDOMLY GENERATING THE DELAY FOR THE SOUND


if (!isServer) exitWith {};

missionNamespace setVariable [_prefix + "_fnc_sounds_loop", {

	if (!isServer) exitWith {};

	private _markers = _this select 0;
	private _radius = _this select 1;
	private _delay = _this select 2;

	while {true} do {

		{

			private _marker = _x;

			private _marker_delay = missionNamespace getVariable [_marker + "_delay", random _delay];

			if (_marker_delay > 0) then {

				missionNamespace setVariable [_marker + "_delay", _marker_delay - 1, true];

			} else {

				missionNamespace setVariable [_marker + "_delay", random _delay, true];

				private _position = getMarkerPos _marker;
				private _filename = markerText _marker;

				private _play = true;

				{

					private _unit = _x;

					if (_unit distance _position < _radius) then {
						_play = false;
					};

				} forEach playableUnits;

				if (_play) then {

					private _center = createCenter sideLogic;
					private _group = createGroup _center;
					private _logic = _group createUnit ["LOGIC", [0,0,0], [], 0, ""];

					_logic setPos _position;

					playSound3D [_filename, _logic, false, _position, 5];

					deleteVehicle _logic;

				};

			};

			sleep (1 / (count _markers));

		} forEach _markers;

	};

}];

private _markers = [];

{

	private _marker = _x;
	private _selection = _marker select [0,5];

	if (_selection == "sound") then {
		_markers append [_marker];
	};

} forEach allMapMarkers;

[_markers, _radius, _delay] spawn (missionNamespace getVariable (_prefix + "_fnc_sounds_loop"))