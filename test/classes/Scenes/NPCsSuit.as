package classes.Scenes {

import classes.Scenes.NPCs.IsabellaSceneTest;
import classes.Scenes.NPCs.JojoSceneTest;
import classes.Scenes.NPCs.IsabellaFollowerSceneTest;
import classes.Scenes.NPCs.JojoTest;
import classes.Scenes.NPCs.MarblePurificationTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
	public class NPCsSuit
	{
		 public var jojoSceneTest:JojoSceneTest;
		 public var isabellaSceneTest : IsabellaSceneTest;
		 public var isabellaFollowerSceneTest:IsabellaFollowerSceneTest;
		 public var marblePurificationTest:MarblePurificationTest;
		 public var jojoTest:JojoTest;
	}
}
