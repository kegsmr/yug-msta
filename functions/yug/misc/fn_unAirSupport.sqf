// ACTIVATES NATO PLANE

if (!isServer) exitWith {};

nato_plane enableSimulation true;
driver nato_plane reveal serb_tank;
driver nato_plane commandTarget serb_tank;

waitUntil {east knowsAbout nato_plane > 0};
sleep 60;

// allow serbs to call anti air?