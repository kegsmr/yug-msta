class yug
{

	class main
	{
		file = "functions\yug";
		class main {};
	};

	class init
	{
		file = "functions\yug\init"
		class briefings {};
		class deathMarkers {};
		class lists {};
		class mines {};
		class respawnOnSL {};
		class retainLoadouts {};
	};

	class loop
	{
		file = "functions\yug\loop"
		class arty {};
		class civs {};
		class combat {};
		class evacuation {};
		class player {};
	};

	class misc
	{
		file = "functions\yug\misc"
		class activateTrigger {};
		class addChildToTree {};
		class callFunctions {};
		class deleteObjects {};
		class desaturateOut {};
		class endMission {};
		class findItemInTree {};
		class getNearestPlayableUnit {};
		class isArmed {};
		class setCombatMode {};
		class setPosAGLS {};
		class setTaskDescription {};
		class setValueIfNil {};
		class sideSpecificBriefing {};
		class subtractTime {};
	};

};
