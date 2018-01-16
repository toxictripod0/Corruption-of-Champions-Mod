/**
 * ...
 * @author Melchi ...
 */
package classes.Items.Shields 
{
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Items.Shield;
	import classes.Player;
	
	public class WoodShield extends Shield
	{
		
		public function WoodShield() 
		{
			super("WoodShl", "WoodShld", "wood shield", "a wooden shield", 6, 10, "A crude wooden shield. It doesn't look very sturdy");
		}
		
	}

}