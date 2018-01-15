package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Scimitar extends Weapon
	{
		
		public function Scimitar(tier:int) 
		{
			var id:String = "Scimitr";
			var sname:String = "Scimitar";
			var name:String = "scimitar";
			var lname:String = "a scimitar";
			var desc:String = "A vicious curved sword made for slashing. No doubt it'll easily cut through flesh.";
			var attack:int = 13;
			var value:int = 500;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Scimtr1";
				sname = "Scimitar+1";
				name = "fine scimitar";
				lname = "a fine scimitar";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Scimtr2";
				sname = "Scimitar+2";
				name = "masterwork scimitar";
				lname = "a masterwork scimitar";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "slash", attack, value, desc);
		}
		
	}

}