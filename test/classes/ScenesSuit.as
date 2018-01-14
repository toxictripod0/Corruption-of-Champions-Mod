package classes {
	import classes.Scenes.NPCsSuit;
	import classes.Scenes.PlacesSuit;
	import classes.Scenes.AreasSuit;
	import classes.Scenes.PregnancyProgressionTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ScenesSuit
	{
		 public var placesSuit:PlacesSuit;
		 public var npcsSuit:NPCsSuit;
		 public var areasSuit:AreasSuit;
		 public var pregnancyProgressionTest:PregnancyProgressionTest
	}
}