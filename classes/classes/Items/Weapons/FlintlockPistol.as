package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class FlintlockPistol extends Weapon
	{
		
		public function FlintlockPistol(tier:int) 
		{
			var id:String = "Flintlk";
			var sname:String = "Flintlock";
			var name:String = "flintlock pistol";
			var lname:String = "a flintlock pistol";
			var desc:String = "A flintlock pistol. Pew pew pew. Can fire once before a reload is required and Speed has a factor in damage.";
			var attack:int = 14;
			var value:int = 250;
			this.weightCategory = Weapon.WEIGHT_LIGHT;
			if (tier == 1) {
				id = "Flntlk1";
				sname = "Flintlock+1";
				name = "fine flintlock pistol";
				lname = "a fine flintlock pistol";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Flntlk2";
				sname = "Flintlock+2";
				name = "masterwork flintlock pistol";
				lname = "a masterwork flintlock pistol";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "shot", attack, value, desc, "Ranged");
		}
		
	}

}