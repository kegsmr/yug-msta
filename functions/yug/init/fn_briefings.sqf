// DEALS WITH BRIEFINGS

if (!hasInterface) exitWith {};

/*private _side = independent;
private _subject = "Diary";
private _title = "Entry";
private _text = "Entry text";
[_side, _subject, [_title, _text]] call YUG_fnc_sideSpecificBriefing;*/

if (side player == independent) then {
	player createDiaryRecord ["Diary", ["Intel", "<img image='images\un_briefing.jpg' width='400'/> <br/>The Serbs are attacking the sieged village of Msta. Our objective is to defend the village for as long as is needed to evacuate the civilians. Use the helicopter to shuttle civilians to the UN compound. Supplies are available at the UN compound or at the red house in the center of Msta. Avoid civilian and peacekeeper casualties. Act fast."]];
} else {
	if (side player == east) then {
		player createDiaryRecord ["Diary", ["Intel", "<img image='images\serb_briefing.jpg' width='400'/> <br/>The occupied village of Msta is almost in our hands. One final offensive is needed to capture it. A tank will lead the offensive and the infantry will follow. Ammo crates, mortars and turrets are available at the HQ to be loaded into trucks. Act fast to ensure we can capture enough war criminals before the UN evacuates them!"]];
	};
};