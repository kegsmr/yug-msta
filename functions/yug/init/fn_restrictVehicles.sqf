// RESTRICTS PLAYERS FROM DRIVING CERTAIN VEHICLES BASED ON UNIT TYPE

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_restrictVehicles;
*/

// PREFIX
private _prefix= "YUG";
//

// SETTINGS
private _restrictions = [
	[
		["CUP_I_Mi17_UN"], 
		["LOP_UN_Infantry_Pilot"], 
		["driver"]
	],
	[
		["KOS_YUG_t72_grom"], 
		["O_Serbia_Crew_01"], 
		["driver", "turret"]
	]
];
//


if (!hasInterface) exitWith {};

private _vehicles = [];
private _types = [];
private _roles = [];

for "_a" from 0 to (count _restrictions) - 1 do {

	private _restriction = _restrictions select _a;

	private _currentVehicles = _restriction select 0;
	private _currentTypes = _restriction select 1;
	private _currentRoles = _restriction select 2;

	for "_b" from 0 to (count _currentVehicles) - 1 do {

		private _currentVehicle = _currentVehicles select _b;

		_vehicles append [_currentVehicle];
		_types append [_currentTypes];
		_roles append [_currentRoles];

	};

};

missionNamespace setVariable [_prefix + "_restrictedVehicles", _vehicles];
missionNamespace setVariable [_prefix + "_restrictedVehiclesTypes", _types];
missionNamespace setVariable [_prefix + "_restrictedVehiclesRoles", _roles];

call compile ("

	player addEventHandler ['GetInMan', {

		[_this select 0, _this select 1, _this select 2] spawn {

			private _unit = _this select 0;
			private _role = _this select 1;
			private _vehicle = typeOf (_this select 2);

			private _type = typeOf _unit;
			
			private _vehicles = " + _prefix + "_restrictedVehicles;
			private _types = " + _prefix + "_restrictedVehiclesTypes;
			private _roles = " + _prefix + "_restrictedVehiclesRoles;

			private _vehicleIndex = _vehicles find _vehicle;

			if (_vehicleIndex > -1) then {

				private _currentTypes = _types select _vehicleIndex;
				private _currentRoles = _roles select _vehicleIndex;

				if !(_type in _currentTypes) then {

					while {player != vehicle player} do {

						_role = (assignedVehicleRole _unit) select 0;

						if (_role in _currentRoles) then {
							moveOut _unit;
						};

						sleep 1;

					};

				};

			};

		};

	}];

");

