// ENDS THE MISSION

if (false) exitWith {};

private _condition1 = YUG_evacuated_civs >= 30;

addMissionEventHandler ["Ended", {
	// TODO: add end music
}];

if (!hasInterface) exitWith {

	if (_condition1) then {

		// UN VICTORY
		endMission "END1";

	} else {

		// SERB VICTORY
		endMission "END3";

	};

};

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