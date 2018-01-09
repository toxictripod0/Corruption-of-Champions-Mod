/**
 * Created by aimozg on 10.01.14.
 */
package classes.Items.Weapons
{
	import classes.Items.Weapon;
	import classes.Player;

	public class HugeWarhammer extends Weapon {
		
		public function HugeWarhammer(tier:int) {
			var id:String = "Warhamr";
			var sname:String = "Warhammer";
			var name:String = "huge warhammer";
			var lname:String = "a huge warhammer";
			var desc:String = "A huge war-hammer made almost entirely of steel that only the strongest warriors could use. Requires 80 strength to use. Getting hit with this might stun the victim.";
			var attack:int = 15;
			var value:int = 1600;
			this.weightCategory = Weapon.WEIGHT_HEAVY;
			if (tier == 1) {
				id = "Warham1";
				sname = "Warhammer+1";
				name = "fine warhammer";
				lname = "a fine warhammer";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Warham2";
				sname = "Warhammer+2";
				name = "masterwork warhammer";
				lname = "a masterwork warhammer";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "smash", attack, value, desc, "Large");
		}
		
		override public function canUse():Boolean {
			if (game.player.str >= 80) return true;
			outputText("You aren't strong enough to handle such a heavy weapon!  ");
			return false;
		}
		
	}
}
