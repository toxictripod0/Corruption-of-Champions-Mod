package classes {
	import classes.Scenes.NPCsSuite;
	import classes.Scenes.PlacesSuite;
	import classes.Scenes.AreasSuite;
	import classes.Scenes.PregnancyProgressionAnalBirthTest;
	import classes.Scenes.PregnancyProgressionTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ScenesSuite
	{
		 public var placesSuit:PlacesSuite;
		 public var npcsSuit:NPCsSuite;
		 public var areasSuit:AreasSuite;
		 public var pregnancyProgressionTest:PregnancyProgressionTest
		 public var pregnancyProgressionAnalBirthTest:PregnancyProgressionAnalBirthTest;
	}
}
