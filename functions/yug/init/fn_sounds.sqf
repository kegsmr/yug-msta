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

missionNamespace setVariable [_prefix + "_fnc_sounds_sound", {

	if (!isServer) exitWith {};

	private _marker = _this select 0;
	private _radius = _this select 1;
	private _delay = _this select 2;

	private _position = getMarkerPos _marker;
	private _filename = markerText _marker;

	private _center = createCenter sideLogic;
	private _group = createGroup _center;
	private _logic = _group createUnit ["LOGIC", [0,0,0], [], 0, ""];

	_logic setPos _position;

	while {true} do {

		sleep (random _delay);

		_play = true;

		{

			private _unit = _x;

			if (_unit distance _position < _radius) then {
				_play = false;
			};

		} forEach playableUnits;

		if (_play) then {
			playSound3D [_filename, _logic, false, _position, 5];
			// hintSilent ('Sound played: "' + _filename + '"');
		};

	};

}];

{

	private _marker = _x;
	private _selection = _marker select [0,5];

	if (_selection == "sound") then {
		[_marker, _radius, _delay] spawn (missionNamespace getVariable (_prefix + "_fnc_sounds_sound"));
	};

} forEach allMapMarkers;