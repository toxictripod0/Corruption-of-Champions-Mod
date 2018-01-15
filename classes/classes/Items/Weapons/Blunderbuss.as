package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Blunderbuss extends Weapon
	{
		
		public function Blunderbuss(tier:int) 
		{
			var id:String = "Blunder";
			var sname:String = "Blndrbss";
			var name:String = "blunderbuss";
			var lname:String = "a blunderbuss";
			var desc:String = "This is a blunderbuss, a two-handed gun. It's effective at short range but poor at long range.";
			var attack:int = 16;
			var value:int = 600;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Blundr1";
				sname = "Blndrbss+1";
				name = "fine blunderbuss";
				lname = "a fine blunderbuss";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Blundr2";
				sname = "Blndrbss+2";
				name = "masterwork blunderbuss";
				lname = "a masterwork blunderbuss";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "shot", attack, value, desc, "Ranged");
		}
		
	}

}