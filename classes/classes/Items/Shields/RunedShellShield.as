package classes.Items.Shields 
{
	import classes.Items.Shield;
	import classes.GlobalFlags.kFLAGS;
	
	public class RunedShellShield extends Shield
	{
		
		public function RunedShellShield() 
		{
			super("RDgnShl", "RDgnShl", "runed dragon-shell shield", "a runed dragon-shell shield", 16, 2000, "A durable shield that has been forged from the remains of the dragon egg you found in the swamp.  Absorbs any fluid attacks you can catch, rendering them useless.");
		}
		
		override public function get description():String {
			var desc:String = game.flags[kFLAGS.EMBER_HATCHED] > 0 ? "A durable shield that has been forged from the dragon eggshell Ember gave you for maxing out " + game.emberScene.emberMF("his", "her") + " affection." : "A durable shield that has been forged from the remains of the dragon egg you found in the swamp.";
			desc += " This shield has since been enhanced and now intricate glowing runes surround the edges.";
			//Type
			desc += "\n\nType: Shield";
			//Block Rating
			desc += "\nBlock: " + String(block);
			//Value
			desc += "\nBase value: " + String(value);
			return desc;
		}
		
	}

}