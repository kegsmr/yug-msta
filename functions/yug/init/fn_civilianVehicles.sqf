// ALLOWS CIVILIANS TO ENTER CIVILIAN VEHICLES

// USAGE EXAMPLE
/*
	// RUN AT MISSION START

	call PREFIX_fnc_civilianVehicles;
*/

/*{

	_vehicle = _x;
	_type = typeOf _vehicle;

	if (count _type > 3) then {

		if (_type select [count _type - 3, 3] == "CIV") then {

			{

				_unit = _x;
				_group = group _unit;

				[_unit] allowGetIn true;

				if (_unit == leader _group) then {

					_group addVehicle _vehicle;

				};

			} forEach units civilian;

		};

	};

} forEach allMissionObjects "all";*/