// SPAWNS MINEFIELDS WITHIN AREAS PLACED ON THE MAP

if (!isServer) exitWith {};

YUG_fnc_initMines_spawned = {

	if (!isServer) exitWith {};

	private _minefield = _this;

	private _density = (1/25);
	private _type = "rhs_mine_a200_bz";

	private _area = _minefield call BIS_fnc_getArea;
	_area params ["_center", "_a", "_b", "_angle", "_is_rectangle"];

	private _sqm = (
		if (_is_rectangle) then {
			_a * _b
		} else {
			3.14 * _a * _b
		}
	);

	private _count = round (_sqm * _density);

	private _i = 0;

	for "_i" from 0 to _count do {

		private _position = [
			[
				[_center, [_a, _b, _angle, _is_rectangle]]
			],
			[
				"water"
			]
		] call BIS_fnc_randomPos;
		
		if (isOnRoad _position) exitWith {};

		private _mine = createMine [_type, _position, [], 0];
		_mine setVectorUp surfaceNormal position _mine;
		_mine enableSimulation true;
		_mine enableDynamicSimulation true;

	};

	private _radius = (
		if (_a < _b) then {
			_a / 2
		} else {
			_b / 2
		}
	);

	private _position = [
		[
			[_center, _radius]
		],
		[
			"water"
		]
	] call BIS_fnc_randomPos;

	private _marker = createMarker [(_minefield + "_marker"), _position];
	_marker setMarkerType "mil_warning";
	_marker setMarkerColor "ColorRedAlpha";
	_marker setMarkerSize [.5, .5];

	// MALO_TIP_mines = true;

};

{

	private _marker = _x;
	private _selection = _marker select [0,9];

	if (_selection == "minefield") then {

		private _area = _marker call BIS_fnc_getArea;
		_area params ["_center", "_a", "_b", "_angle", "_is_rectangle"];

		private _trigger = createTrigger ["EmptyDetector", _center, true];
		_trigger setTriggerArea [_a * 1.5, _b * 1.5, _angle, _is_rectangle, 100];
		_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_trigger setTriggerStatements ["this", ("'" + _marker + "' spawn YUG_fnc_initMines_spawned;"), ""];

	};

} forEach allMapMarkers;