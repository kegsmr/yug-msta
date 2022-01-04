// CREATES A SIDE-SPECIFIC BRIEFING

// USAGE EXAMPLE
/*
	// TO CREATE A NEW DIARY SUBJECT

	private _side = west;
	private _subject = "killTheStuff";
	private _title = "Kill the Stuff";
	private _image = "killTheStuff.jpg";
	[_side, _subject, _title, _image] call YUG_fnc_sideSpecificBriefing;
*/
// OR
/*
	// TO CREATE A NEW DIARY ENTRY

	private _side = west;
	private _subject = "killTheStuff";
	private _title = "Kill the Stuff";
	private _text = "Kill the stuff.";
	[_side, _subject, [_title, _text]] call YUG_fnc_sideSpecificBriefing;
*/

// ISSUES 
/*
	- DOES NOT WORK
*/

if (!isServer) exitWith {};

private _prefix = "YUG";

private _side = str (_this select 0);
private _subject = _this select 1;

YUG_fnc_playerBriefings = {
	
	if (!hasInterface) exitWith {};

	private _prefix = _this;

	private _startedVarname = _prefix + "_briefingScriptStarted";
	private _sideOfBriefingsVarname = _prefix + "_sideOfBriefings";
	private _briefingsVarname = _prefix + "_sideSpecificBriefings";
	private _delay = 1;

	private _namespace = missionNamespace;
	private _name = _startedVarname;
	private _value = false;
	private _public = false;
	[_namespace, _name, _value, _public] call YUG_fnc_setValueIfNil;

	private _started = missionNamespace getVariable _startedVarname;
	if (_started) exitWith {};

	missionNamespace setVariable [_startedVarname, true, false];

	private _namespace = missionNamespace;
	private _name = _sideOfBriefingsVarname;
	private _value = str side player;
	private _public = false;
	[_namespace, _name, _value, _public] call YUG_fnc_setValueIfNil;

	private _delete = false;
	_sideOfBriefings = missionNamespace getVariable _sideOfBriefingsVarname;
	if (_sideOfBriefings != str side player) then {
		_delete = true;
		_sideOfBriefings = str side player;
		missionNamespace setVariable [_sideOfBriefingsVarname, _sideOfBriefings, false];
	};

	while {true} do {

		private _briefings = missionNamespace getVariable _briefingsVarname;

		{

			private _side = _x select 0;
			private _sideChildren = _x select 1;

			{
				private _subject = _x select 0;
				private _subjectChildren = _x select 1;
				private _subjectTitle = _x select 2;
				private _subjectImage = "";
				if (count _x > 3) then {
					_subjectImage = _x select 3;
				};

				if (_delete) then {

					player removeDiarySubject _subject;

				} else {

					if !(player diarySubjectExists _subject) then {
						if (_subjectImage == "") then {
							player createDiarySubject [_subject, _subjectTitle]
						} else {
							player createDiarySubject [_subject, _subjectTitle, _subjectImage];
						};
					};

					private _allPlayerSubjects = allDiarySubjects player;
					private _playerSubjectIndex = [_allPlayerSubjects, _subject] call YUG_fnc_findItemInTree;
					private _playerSubject = _allPlayerSubjects select _playerSubjectIndex;
					private _countRecords = _playerSubject select 3;
					private _count = 0;

					{

						if (_count >= _countRecords) then {

							private _entryTitle = _x select 0;
							private _entryText = _x select 1;

							player createDiaryRecord [_subject, [_entryTitle, _entryText]];

						};

						_count = _count + 1;

					} forEach _subjectChildren;

				};

			} forEach _sideChildren;

		} forEach _briefings;

		sleep _delay;

	};

};

private _briefingsVarname = _prefix + "_sideSpecificBriefings";

private _namespace = missionNamespace;
private _name = _briefingsVarname;
private _value = [];
private _public = true;
[_namespace, _name, _value, _public] call YUG_fnc_setValueIfNil;

private _briefings = (missionNamespace getVariable _briefingsVarname);

private _sideIndex = [_briefings, _side] call YUG_fnc_findItemInTree;

if (_sideIndex == -1) then {
	_briefings = _briefings + [[_side, []]];
	missionNamespace setVariable [_briefingsVarname, _briefings, true];
	_sideIndex = count _briefings - 1;
};

private _sideItem = _briefings select _sideIndex;
private _sideBriefings = _sideItem select 1;

private _subjectIndex = [_sideBriefings, _subject] call YUG_fnc_findItemInTree;

if (_subjectIndex == -1) then {

	private _title = _this select 2;
	private _image = "";
	if (count _this > 3) then {
		_image = _this select 3;
	};

	private _newEntry = [_subject, [], _title];

	private _addImage = _image != "";

	if (_addImage) then {
		_newEntry = _newEntry + _image;
	};

	_sideBriefings = _sideBriefings + [_newEntry];
	_sideItem set [1, _sideBriefings];
	_briefings set [_sideIndex, _sideItem];
	missionNamespace setVariable [_briefingsVarname, _briefings, true];

} else {

	private _title = (_this select 2) select 0;
	private _text = (_this select 2) select 1;

	private _subjectItem = _sideBriefings select _subjectIndex;
	private _subjectBriefings = _subjectItem select 1;

	private _newEntry = [_title, _text];

	_subjectBriefings = _subjectBriefings + [_newEntry];
	_subjectItem set [1, _subjectBriefings];
	_sideBriefings set [_subjectIndex, _subjectItem];
	_sideItem set [1, _sideBriefings];
	_briefings set [_sideIndex, _sideItem];
	missionNamespace setVariable [_briefingsVarname, _briefings, true];

};

_prefix remoteExec ["YUG_fnc_playerBriefings", 0];