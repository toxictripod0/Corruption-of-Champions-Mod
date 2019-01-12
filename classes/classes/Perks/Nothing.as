package classes.Perks 
{
	import classes.PerkType;
	
	/**
	 * A perk that does nothing, intended as a null object.
	 */
	public class Nothing extends PerkType 
	{
		/**
		 * Does not take any parameters and does nothing.
		 */
		public function Nothing() 
		{
			super("Nothing", "Nothing", "It does nothing!", "A perk that does absolutly nothing.");
			
		}
	}
}
