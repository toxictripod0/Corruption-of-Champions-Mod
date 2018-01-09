/**
 * Created by aimozg on 10.01.14.
 */
package classes.Items.Weapons
{
	import classes.Items.Weapon;
	import classes.Player;

	public class LargeClaymore extends Weapon {
		
		public function LargeClaymore(tier:int) {
			var id:String = "Claymor";
			var sname:String = "L.Claymore";
			var name:String = "large claymore";
			var lname:String = "a large claymore";
			var desc:String = "A massive sword that a very strong warrior might use. Requires 40 strength to use.";
			var attack:int = 15;
			var value:int = 1000;
			this.weightCategory = Weapon.WEIGHT_HEAVY;
			if (tier == 1) {
				id = "Claymr1";
				sname = "L.Claymore+1";
				name = "fine claymore";
				lname = "a fine claymore";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Claymr2";
				sname = "L.Claymore+2";
				name = "masterwork claymore";
				lname = "a masterwork claymore";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "cleaving sword-slash", attack, value, desc, "Large");
		}
		
		override public function canUse():Boolean {
			if (game.player.str >= 40) return true;
			outputText("You aren't strong enough to handle such a heavy weapon!  ");
			return false;
		}
		
	}
}
