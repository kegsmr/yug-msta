// STARTS CIVILIAN AIRLIFT

if (!isServer) exitWith {};

missionNamespace setVariable ["YUG_civilianAirlift", true, true];

[leader un_squad, "endCivilianAirlift"] call BIS_fnc_addCommMenuItem;

un_airlift_squad = createGroup independent;
[un_heliD, un_heliG] joinSilent un_airlift_squad;
un_airlift_squad selectLeader un_heliD;

un_heliD assignAsDriver un_heli;
un_heliG assignAsGunner un_heli;
[un_heliD, un_heliG] orderGetIn true;

un_airlift_squad addVehicle un_heli;

while {YUG_civilianAirlift} do {
	if (alive un_heli) then {
		if (vehicle un_heliD == un_heli) then {
			if (un_heli distance helipad_1 < 150) then {
				un_airlift_squad addWaypoint [helipad_2, 0];
				private _waypoint = un_airlift_squad addWaypoint [helipad_2, 0];
				_waypoint setWaypointType "GETOUT";
			} else {
				if (un_heli distance helipad_2 < 150) then {
					un_airlift_squad addWaypoint [helipad_1, 0];
					private _waypoint = un_airlift_squad addWaypoint [helipad_1, 0];
					_waypoint setWaypointType "GETOUT";
				};
			};
		} else {
			private _waypoint = un_airlift_squad addWaypoint [un_heli, 0];
			_waypoint setWaypointType "GETIN";
			un_airlift_squad setCurrentWaypoint _waypoint;
		};
	} else {
		private _unit = un_heliD;
		if (vehicle _unit == _unit && _unit distance (getMarkerPos "refugee_marker") > 1000) then {
			private _objects = nearestObjects [player, ["LOP_UN_UAZ", "LOP_UN_Ural"], 500];
			if (count _objects > 0) then {
				private _object = _objects select 0;
				private _waypoint = un_airlift_squad addWaypoint [_object, 0];
				_waypoint setWaypointType "GETIN";
				un_airlift_squad setCurrentWaypoint _waypoint;
			} else {
				private _waypoint = un_airlift_squad addWaypoint [getMarkerPos "refugee_marker", 0];
				un_airlift_squad setCurrentWaypoint _waypoint;
			}
		} else {
			private _waypoint = un_airlift_squad addWaypoint [getMarkerPos "refugee_marker", 0];
			un_airlift_squad setCurrentWaypoint _waypoint;
		}	
	};
	sleep 10;
};

[un_heliD, un_heliG] joinSilent un_squad;

[leader un_squad, "startCivilianAirlift"] call BIS_fnc_addCommMenuItem;