// CREATES LOCAL MARKERS ON FRIENDLY AND KNOWN ENEMY GROUPS

// ISSUES
/*
	needs to use all markers, not just infantry, armored and motorized
	only tracks squads created at the start of the mission
*/

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_groupMarkers;
*/

// PREFIX
private _prefix = "YUG";
//

if (!hasInterface) exitWith {};

private _unitsMinimum = 2;
private _knowsAboutMinimum = 0;

{
	private _group = _x;
	if (count units _group >= _unitsMinimum && side _group != civilian) then {
		// _group setVariable [_prefix + "_groupMarkerCreated", true, false];
		[_group, _knowsAboutMinimum] spawn {

			private _group = _this select 0;
			private _leader = leader _group;
			private _position = position _leader;
			private _knowsAboutMinimum = _this select 1;

			private _marker = createMarkerLocal [((str (_group)) + "_marker"), _position];
			_marker setMarkerAlphaLocal 0;

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
						if (_vehicle isKindOf "Car") then {
							"motor_inf"
						} else {
							if (_vehicle isKindOf "Man") then {
								"inf"
							} else {
								"unknown"
							}
						}
					}
				);

				private _type = _prefix + _suffix;

				_marker setMarkerTypeLocal _type;
				if (alive player) then {
					if (_playerSide knowsAbout _leader > _knowsAboutMinimum && alive _leader) then {
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

				sleep 1;

			};

			deleteMarkerLocal _marker;

		};
	};
} forEach allGroups;