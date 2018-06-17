package classes.Scenes.Areas.Forest 
{
	import classes.Monster;
	import classes.PerkLib;
	
	/**
	 * This class contains code and text that are shared between Aiko and Yamata.
	 */
	public class BaseKitsune extends Monster 
	{
		
		public function BaseKitsune() 
		{
			super();
			
		}
		
		/**
		 * Calculate the resist value for attacks. This is based on INT and modified by certain perks.
		 * @return the calculated resist value
		 */
		protected function calculateAttackResist(): int {
			var resist:int = 0;
			
			if (player.inte < 30) {
				resist = Math.round(player.inte);
			} else {
				resist = 30;
			}
			
			if (player.findPerk(PerkLib.Whispered) >= 0) {
				resist += 20;
			}
			
			if (player.findPerk(PerkLib.HistoryReligious) >= 0 && player.isPureEnough(20)) {
				resist += 20 - player.corAdjustedDown();
			}
			
			return resist;
		}
	}
}