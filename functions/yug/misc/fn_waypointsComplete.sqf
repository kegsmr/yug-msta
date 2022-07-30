// CHECKS IF A GROUP HAS COMPLETED ITS WAYPOINTS

if (false) exitWith {};

private _group = _this;
private _index = currentWaypoint _group;
private _count = count waypoints _group;

_index >= _count