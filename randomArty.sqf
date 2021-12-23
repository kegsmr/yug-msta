guns = [

	mortar_1,
	mortar_2,
	mortar_3,
	mortar_4,
	mortar_5

];

tgts = [

	getMarkerPos "tgt_1",
	getMarkerPos "tgt_2",
	getMarkerPos "tgt_3",
	getMarkerPos "tgt_4",
	getMarkerPos "tgt_5",
	getMarkerPos "tgt_6",
	getMarkerPos "tgt_7",
	getMarkerPos "tgt_8",
	getMarkerPos "tgt_9",
	getMarkerPos "tgt_10"

];

while {true} do {

	sleep 300;
	
	{
		_x setVehicleAmmo 1;
		
		_tgt = selectRandom tgts;
		_ammo = getArtilleryAmmo [_x] select 0; 
		
		_x doArtilleryFire [_tgt, _ammo, 2];
		
		sleep 1;
	
	} forEach guns;

}