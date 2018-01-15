package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class RidingCrop extends Weapon
	{
		
		public function RidingCrop(tier:int) 
		{
			var id:String = "RidingC";
			var sname:String = "RidingC";
			var name:String = "riding crop";
			var lname:String = "a riding crop";
			var desc:String = "This riding crop appears to be made of black leather, and could be quite a painful (or exciting) weapon.";
			var attack:int = 5;
			var value:int = 50;
			this.weightCategory = Weapon.WEIGHT_LIGHT;
			if (tier == 1) {
				id = "Riding1";
				sname = "RidingC+1";
				name = "fine riding crop";
				lname = "a fine riding crop";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Riding2";
				sname = "RidingC+2";
				name = "masterwork riding crop";
				lname = "a masterwork riding crop";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "whip-crack", attack, value, desc);
		}
		
	}

}