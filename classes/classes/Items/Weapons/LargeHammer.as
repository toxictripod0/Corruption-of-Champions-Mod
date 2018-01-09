/**
 * Created by aimozg on 10.01.14.
 */
package classes.Items.Weapons
{
	import classes.Items.Weapon;

	public class LargeHammer extends Weapon {
		
		public function LargeHammer(tier:int) {
			var id:String = "L.Hammr";
			var sname:String = "L.Hammer";
			var name:String = "large hammer";
			var lname:String = "Marble's large hammer";
			var desc:String = "This two-handed warhammer looks pretty devastating. You took it from Marble after she refused your advances.";
			var attack:int = 16;
			var value:int = 90
			this.weightCategory = Weapon.WEIGHT_HEAVY;
			if (tier == 1) {
				id = "L.Hamr1";
				sname = "L.Hammer+1";
				name = "fine large warhammer";
				lname = "a fine large warhammer";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "L.Hamr2";
				sname = "L.Hammer+2";
				name = "masterwork large hammer";
				lname = "a masterwork large hammer";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "smash", attack, value, desc, "Large");
		}
		
		override public function canUse():Boolean {
			if (game.player.tallness >= 60) return true;
			outputText("This hammer is too large for you to wield effectively.  ");
			return false;
		}
		
	}
}
