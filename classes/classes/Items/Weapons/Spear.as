package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Spear extends Weapon
	{
		
		public function Spear(tier:int) 
		{
			var id:String = "Spear  ";
			var sname:String = "Spear";
			var name:String = "deadly spear";
			var lname:String = "a deadly spear";
			var desc:String = "A staff with a sharp blade at the tip designed to pierce through the toughest armor. This would ignore most armors.";
			var attack:int = 8;
			var value:int = 450;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Spear 1";
				sname = "Spear+1";
				name = "fine spear";
				lname = "a fine, deadlier spear";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Spear 2";
				sname = "Spear+2";
				name = "masterwork spear";
				lname = "a masterwork, even deadlier spear";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "piercing stab", attack, value, desc);
		}
		
	}

}