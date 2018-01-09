package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Crossbow extends Weapon
	{
		
		public function Crossbow(tier:int) {
			var id:String = "Crossbw";
			var sname:String = "Crossbow";
			var name:String = "crossbow";
			var lname:String = "a crossbow";
			var desc:String = "This weapon fires bolts at your enemies with the pull of a lever.";
			var attack:int = 11;
			var value:int = 200;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Crsbow1";
				sname = "Crossbow+1";
				name = "fine crossbow";
				lname = "a fine crossbow";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Crsbow2";
				sname = "Crossbow+2";
				name = "masterwork crossbow";
				lname = "a masterwork crossbow";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "shot", attack, value, desc, "Ranged");
		}
		
	}

}