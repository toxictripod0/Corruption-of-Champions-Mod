package classes.Scenes.Areas.Forest 
{
	import classes.Monster;
	import classes.PerkLib;
	import classes.StatusEffects;
	
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
		
		/**
		 * Seal the player's attacks, rendering them unable to attack until it wears off.
		 */
		protected function sealPlayerAttack(): void {
			outputText("The kitsune playfully darts around you, grinning coyly.  She somehow slips in under your reach, and before you can react, draws a small circle on your chest with her fingertip.  As you move to strike again, the flaming runic symbol she left on you glows brightly, and your movements are halted mid-swing.");
			outputText("\n\n\"<i>Naughty naughty, you should be careful with that.</i>\"");

			outputText("\n\nDespite your best efforts, every time you attempt to attack her, your muscles recoil involuntarily and prevent you from going through with it.  <b>The kitsune's spell has sealed your attack!</b>  You'll have to wait for it to wear off before you can use your basic attacks.");
			player.createStatusEffect(StatusEffects.Sealed, 4, 0, 0, 0);
		}
	}
}