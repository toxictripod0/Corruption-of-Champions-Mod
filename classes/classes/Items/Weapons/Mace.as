package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Mace extends Weapon
	{
		
		public function Mace(tier:int) 
		{
			var id:String = "Mace   ";
			var sname:String = "Mace";
			var name:String = "mace";
			var lname:String = "a mace";
			var desc:String = "This is a mace, designed to be able to crush against various defenses.";
			var attack:int = 9;
			var value:int = 100;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Mace  1";
				sname = "Mace+1";
				name = "fine mace";
				lname = "a fine mace";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Mace  2";
				sname = "Mace+2";
				name = "masterwork mace";
				lname = "a masterwork mace";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "smash", attack, value, desc);
		}
		
	}

}