// ACTIVATES NATO PLANE

if (!isServer) exitWith {};

YUG_fnc_unAirSupport_start = {

	nato_plane enableSimulation true;
	driver nato_plane reveal serb_tank;
	driver nato_plane commandTarget serb_tank;

	units group driver nato_plane select 1 setdamage 1;

	waitUntil {missionNamespace getVariable ["YUG_civTaskComplete", false]};

	sleep 60;

	nato_plane setDamage .5;

};

[] remoteExec ["YUG_fnc_unAirSupport_start"];