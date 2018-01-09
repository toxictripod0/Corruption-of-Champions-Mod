package classes.Items.Weapons 
{
	import classes.Items.Weapon;

	public class Flail extends Weapon
	{
		
		public function Flail(tier:int) 
		{
			var id:String = "Flail  ";
			var sname:String = "Flail";
			var name:String = "flail";
			var lname:String = "a flail";
			var desc:String = "This is a flail, a weapon consisting of a metal spiked ball attached to a stick by chain. Be careful with this as you might end up injuring yourself.";
			var attack:int = 10;
			var value:int = 200;
			this.weightCategory = Weapon.WEIGHT_MEDIUM;
			if (tier == 1) {
				id = "Flail 1";
				sname = "Flail+1";
				name = "fine flail";
				lname = "a fine flail";
				desc += " This weapon has been upgraded to be of fine quality.";
				attack += 2;
				value *= 1.5;
			}
			if (tier == 2) {
				id = "Flail 2";
				sname = "Flail+2";
				name = "masterwork flail";
				lname = "a masterwork flail";
				desc += " This weapon has been upgraded to be of masterwork quality.";
				attack += 4;
				value *= 2;
			}
			super(id, sname, name, lname, "smash", attack, value, desc);
		}
		
	}

}