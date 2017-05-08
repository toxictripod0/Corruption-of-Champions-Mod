package classes {
	import classes.Scenes.CampTest;
	import classes.Scenes.NPCsSuit;
	import classes.Scenes.PlacesSuit;
	import classes.Scenes.AreasSuit;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ScenesSuit
	{
		 public var placesSuit:PlacesSuit;
		 public var npcsSuit:NPCsSuit;
		 public var areasSuit:AreasSuit;
		 public var campTest:CampTest;
	}
}