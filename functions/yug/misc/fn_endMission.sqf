// ENDS THE MISSION

// USAGE EXAMPLE
/*
	remoteExec ["PREFIX_fnc_endMission", 0]; 
*/


if (false) exitWith {};


// TASKS

if (YUG_peacekeepersKilled <= 20) then {
	["un_kia", "SUCCEEDED"] call BIS_fnc_taskSetState;
};


// ENDINGS

[] spawn {

	private _condition1 = YUG_evacuated_civs >= 30;

	/*addMissionEventHandler ["Ended", {}];*/

	if (!hasInterface) exitWith {

		if (_condition1) then {

			// UN VICTORY
			endMission "END1";

		} else {

			// SERB VICTORY
			endMission "END3";

		};

	};

	// TODO: add end music

	5 call YUG_fnc_desaturateOut;

	private _condition2 = side player == independent;

	if (_condition1) then {

		// UN VICTORY
		if (_condition2) then {

			// UN PERSPECTIVE
			endMission "END1";

		} else {

			// SERB PERSPECTIVE
			endMission "END2";

		}

	} else {

		// SERB VICTORY
		if (_condition2) then {

			// UN PERSPECTIVE
			endMission "END3";
		} else {

			// SERB PERSPECTIVE
			endMission "END4";

		}
		
	};

};