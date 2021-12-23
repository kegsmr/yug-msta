_leader1 = serbian_leader;
_leader2 = bosnian_leader;
_location = getMarkerPos "playable_area";
_distance = 100;

_group1 = group _leader1;
_group2 = group _leader2;


while {true} do {

	sleep 10;

	_group1 addWaypoint [_location, 0];
	_group2 addWaypoint [_location, 0];
	sleep 60;
	
	/* if (_leader1 distance _location < _distance)  then {
	
		_group1 setBehaviorStrong "COMBAT";
		
	} else {
	
		_group1 setBehaviorStrong "AWARE";
	
	};
	
	if (_leader2 distance _location < _distance)  then {
	
		_group2 setBehaviorStrong "COMBAT";
		
	} else {
	
		_group2 setBehaviorStrong "AWARE";
	
	}; */
};