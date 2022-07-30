// ACTIVATES NATO PLANE

if (!isServer) exitWith {};

nato_plane enableSimulation true;
driver nato_plane reveal serb_tank;
driver nato_plane commandTarget serb_tank;

waitUntil {missionNamespace getVariable ["YUG_civTaskComplete", false]};

sleep 60;

nato_plane setDamage .5;