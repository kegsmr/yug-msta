// FINDS AN ITEM IN A TREE

// USAGE EXAMPLE
/*
	private _tree = [
		["thing", []]
	];
	private _item = "thing";
	private _index = [_tree, _item] call YUG_fnc_findItemInTree;
	
	// RETURNS 0
*/


if (false) exitWith {};

private _tree = _this select 0;
private _item = _this select 1;

private _index = -1;
{
	private _currentItem = _x select 0;
	private _currentItemIndex = _forEachIndex;
	if (_currentItem == _item) then {
		_index = _currentItemIndex;
	};
} forEach _tree;

_index