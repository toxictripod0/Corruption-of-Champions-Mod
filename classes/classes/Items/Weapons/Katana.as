package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Katana extends Weapon
	{
		
		public function Katana(tier:int) 
		{
			var id:String = "Katana ";
			var sname:String = "Katana";
			var name:String = "katana";
			var lname:String = "a katana";
			var desc:String = "A curved bladed weapon that cuts through flesh with the greatest of ease.";
			var attack:int = 10;
			var value:int = 500;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Katana1";
				sname = "Katana+1";
				name = "fine katana";
				lname = "a fine katana";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Katana2";
				sname = "Katana+2";
				name = "masterwork katana";
				lname = "a masterwork katana";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "keen cut", attack, value, desc);
		}
		
	}

}