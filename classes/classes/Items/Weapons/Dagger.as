package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Dagger extends Weapon
	{
		
		public function Dagger(tier:int) 
		{
			var id:String = "Dagger ";
			var sname:String = "Dagger";
			var name:String = "dagger";
			var lname:String = "a dagger";
			var desc:String = "A small blade easily held in one hand. Preferred weapon for the rogues. Has increased critical chance.";
			var attack:int = 3;
			var value:int = 40;
			this.weightCategory = Weapon.WEIGHT_LIGHT;
			if (tier == 1) {
				id = "Dagger1";
				sname = "Dagger+1";
				name = "fine dagger";
				lname = "a fine dagger";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Dagger2";
				sname = "Dagger+2";
				name = "masterwork dagger";
				lname = "a masterwork dagger";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "stab", attack, value, desc);
		}
		
	}

}