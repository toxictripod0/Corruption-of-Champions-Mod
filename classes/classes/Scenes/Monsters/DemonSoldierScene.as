package classes.Scenes.Monsters 
{
	import classes.BaseContent;
	import classes.GlobalFlags.kFLAGS;

	public class DemonSoldierScene extends BaseContent
	{
		
		public function DemonSoldierScene() 
		{
			//Nothing to declare here.
		}
		
		public function encounterTheSoldierz():void {
			clearOutput();
			monster = new DemonSoldier();
			if (flags[kFLAGS.DEMON_SOLDIERS_ENCOUNTERED] < 1) {
				outputText("As you pick your way through the terrain a shadow passes overhead, looking up you spot a large flying shape silhouetted against the sun. At first you think it might be some sort of bird, but as the shape swoops closer you see that the wings are more like those of a bat, with a long, spaded tail trailing out behind .. Uh-oh...");
				outputText("\n\nThe Demon lands in front of you with an almost liquid grace. " + monster.mf("He", "She") + " folds " + monster.mf("his", "her") + " wings behind " + monster.mf("his", "her") + " back, and " + monster.mf("his", "her") + " tail whips back and forth as a truly malevolent grin splits the infernal creature's face.");
				if (player.demonScore() < 4) outputText("<i>\"Well well, it looks like I've found some sport to liven up a dull patrol!\"</i>");
				else outputText("\"<i>Hmm... you may look like one of us, but I can smell your soul from here; I shall enjoy fucking it out of you!\"</i>");
				outputText(" The " + (monster as DemonSoldier).demonTitle(0) + " purrs. \n\nThe demon draws " + monster.mf("his", "her") + " wickedly serrated scimitar and adopts an aggressive combat stance. It's a fight!");
				flags[kFLAGS.DEMON_SOLDIERS_ENCOUNTERED] = 1;
			}
			else {
				outputText("Another of Lethice's demonic soldiers swoops down out of the sky and attacks, announcing \"<i>I'll enjoy turning you into a fuck-toy, mortal!\"</i>");
				outputText("\n\nThis time, the demon is " + (monster as DemonSoldier).demonTitle(1) + " and " + monster.mf("he", "she") + " draws " + monster.mf("his", "her") + " scimitar. It's a fight!");
				flags[kFLAGS.DEMON_SOLDIERS_ENCOUNTERED]++;
			}
			startCombat(monster);
		}
		
		public function victoryOverSoldier(hpVictory:Boolean):void {
			clearOutput();
			outputText("(Placeholder) You are victorious over the demon! What will you do?");
			menu();
			addButton(3, "Kill " + monster.mf("Him", "Her"), killTheSoldier);
			addButton(4, "Leave", getGame().combat.cleanupAfterCombat);
		}
		
		public function killTheSoldier():void {
			
		}
		
		public function defeatedBySoldier(hpVictory:Boolean):void {
			clearOutput();
			outputText("(Placeholder) You have lost to the demon and thus the demon has " + monster.mf("his", "her") + " way with you, leaving you abused.");
			player.orgasm();
			getGame().combat.cleanupAfterCombat();
		}
	}

}