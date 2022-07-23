// CREATES LOCAL MARKERS ON FRIENDLY AND KNOWN ENEMY GROUPS

// ISSUES
/*
	- needs to use all markers for all vehicle types
*/

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_groupMarkers;
*/

// PREFIX
private _prefix = "YUG";
//

// SETTINGS
private _unitsMinimum = 2;
	// MINIMUM UNITS FOR A GROUP TO GET A MARKER (INCLUSIVE)
private _knowsAboutMinimum = 0;
	// MINIMUM "KNOWS ABOUT" VALUE FOR A GROUP TO BE DETECTED (EXCLUSIVE)
private _excludeCivilian = true;
	// DO NOT SHOW CIVILIAN SQUADS
private _newGroupDelay = 60;
	// THE DELAY TO CHECK FOR NEW GROUPS
private _existingGroupDelay = 1;
	// THE DELAY TO UPDATE EXISTING GROUPS
//


if (!hasInterface) exitWith {};

[_unitsMinimum, _knowsAboutMinimum, _excludeCivilian, _newGroupDelay, _existingGroupDelay, _prefix] spawn {
	private _unitsMinimum = _this select 0;
	private _knowsAboutMinimum = _this select 1;
	private _excludeCivilian = _this select 2;
	private _newGroupDelay = _this select 3;
	private _existingGroupDelay = _this select 4;
	private _prefix = _this select 5;
	while {true} do {
		{
			private _group = _x;
			private _created = !isnil {_group getVariable (_prefix + "_groupMarker")};
			if (!_created && (count units _group >= _unitsMinimum) && (side _group != civilian || !_excludeCivilian)) then {
				[_group, _knowsAboutMinimum, _existingGroupDelay, _prefix] spawn {

					private _group = _this select 0;
					private _knowsAboutMinimum = _this select 1;
					private _existingGroupDelay = _this select 2;
					private _prefix = _this select 3;

					private _leader = leader _group;
					private _position = position _leader;

					private _marker = createMarkerLocal [((str (_group)) + "_marker"), _position];
					_marker setMarkerAlphaLocal 0;

					_group setVariable [_prefix + "_groupMarker", _marker, false];

					while {!isNull _group} do {

						private _leader = leader _group;
						private _position = position _leader;
						private _playerSide = side player;
						private _groupSide = side _group;
						private _vehicle = vehicle _leader;

						private _prefix = (
							if (_groupSide == west) then {
								"b_"
							} else {
								if (_groupSide == east) then {
									"o_"
								} else {
									"n_"
								}
							}
						);

						private _suffix = (
							if (_vehicle isKindOf "Tank") then {
								"armor"
							} else {
								if (_vehicle isKindOf "Helicopter") then {
									"air"
								} else {
									if (_vehicle isKindOf "Plane") then {
										"plane"
									} else {
										if (_vehicle isKindOf "StaticCannon") then {
											"art"
										} else {
											if (_vehicle isKindOf "Car") then {
												"motor_inf"
											} else {
												if (_vehicle isKindOf "Man") then {
													"inf"
												} else {
													"unknown"
												};
											};
										};
									};
								};
							}
						);

						private _type = _prefix + _suffix;

						_marker setMarkerTypeLocal _type;
						if (alive player) then {
							private _agent = (if (leader group player == player) then {
								_playerSide
							} else {
								player
							});
							if (_agent knowsAbout _vehicle > _knowsAboutMinimum && alive _leader) then {
								_marker setMarkerPosLocal _position;
								_marker setMarkerAlphaLocal 1;
							} else {
								if ({alive _x} count units _group < 1) then {
									_marker setMarkerAlphaLocal 0;
								} else {
									if (markerAlpha _marker == 1) then {
										_marker setMarkerAlphaLocal .5;
									};
								};
							};
						} else {
							_marker setMarkerAlphaLocal 0;
						};

						if (_playerSide == _groupSide) then {
							_marker setMarkerTextLocal groupId _group;
						} else {
							_marker setMarkerTextLocal "";
						};

						sleep _existingGroupDelay;

					};

					deleteMarkerLocal _marker;

				};
			};
		} forEach allGroups;
		sleep _newGroupDelay;
	};
};