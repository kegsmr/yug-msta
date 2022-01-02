// ADDS A CHILD TO AN ITEM ON A TREE

// USAGE EXAMPLE
/*
	private _tree = [
		["category", []]
	];
	private _child = "thing";
	private _path = ["category"];
	private _tree = [_tree, _child, _path] call YUG_fnc_addChildToTree;

	RETURNS [
		["category", ["thing"]]
	]
*/

if (false) exitWith {};

private _tree = _this select 0;
private _child = _this select 1;
private _path = _this select 2;

/*

private _indexes = [];
private _trees = [];
private _currentTree = _tree;
{
	private _pathIndex = _forEachIndex;
	private _index = [_currentTree, _path select _pathIndex] call YUG_fnc_findItemInTree;
	_indexes = _indexes + [_index];
	_trees = _trees + [_currentTree];
	_currentTree = _currentTree select _index;
} forEach _path;

private _lastTree = _trees select count _trees - 1;
private _lastTreeChildren = _lastTree select 1;
_lastTreeChildren = _lastTreeChildren + [_child];
lastTree set [1, _lastTreeChildren];

for "_i" from 2 to count _trees do {
	private _index = count _trees - _i;
	_currentTree = _trees select _index;
	private _currentTreeChildren = _currentTree select 1;
	private _child = 
	_lastTree = _currentTree;
};

_subjectBriefings = _subjectBriefings + [_newEntry];
_subjectItem set [1, _subjectBriefings];
_sideBriefings set [_subjectIndex, _subjectItem];
_sideItem set [1, [_sideBriefings]];
_briefings set [_sideIndex, _sideItem];
missionNamespace setVariable [_briefingsVarname, _briefings, true];

*/