package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Whip extends Weapon
	{
		
		public function Whip(tier:int) 
		{
			var id:String = "Whip   ";
			var sname:String = "Whip";
			var name:String = "coiled whip";
			var lname:String = "a coiled whip";
			var desc:String = "A coiled length of leather designed to lash your foes into submission. There's a chance the bondage inclined might enjoy it!";
			var attack:int = 5;
			var value:int = 500;
			this.weightCategory = Weapon.WEIGHT_LIGHT;
			if (tier == 1) {
				id = "Whip  1";
				sname = "Whip+1";
				name = "fine coiled whip";
				lname = "a fine coiled whip";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Whip  2";
				sname = "Whip+2";
				name = "masterwork coiled whip";
				lname = "a masterwork coiled whip";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "whip-crack", attack, value, desc);
		}
		
	}

}