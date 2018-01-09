package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class LargeAxe extends Weapon
	{
		
		public function LargeAxe(tier:int) 
		{
			var id:String = "L. Axe ";
			var sname:String = "L. Axe";
			var name:String = "large axe";
			var lname:String = "an axe large enough for a minotaur";
			var desc:String = "This massive axe once belonged to a minotaur. It'd be hard for anyone smaller than a giant to wield effectively. The axe is double-bladed and deadly-looking. Requires height of 6'6\" or 80 strength.";
			var attack:int = 15;
			var value:int = 100;
			this.weightCategory = Weapon.WEIGHT_HEAVY;
			if (tier == 1) {
				id = "L. Axe1";
				sname = "L. Axe+1";
				name = "fine large axe";
				lname = "a fine axe large enough for a minotaur";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Mace  2";
				sname = "Mace+2";
				name = "masterwork mace";
				lname = "a masterwork axe large enough for a minotaur";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "cleave", attack, value, desc, "Large");
		}
		
	}

}