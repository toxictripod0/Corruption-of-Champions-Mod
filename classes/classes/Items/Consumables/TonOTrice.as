package classes.Items.Consumables 
{
	import classes.Appearance;
	import classes.CockTypesEnum;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Items.Consumable;
	import classes.Items.ConsumableLib;
	import classes.PerkLib;
	import classes.StatusEffects;

	/**
	 * @since  26.05.2017
	 * @author Stadler76
	 */
	public class TonOTrice extends Consumable
	{
		
		public function TonOTrice() 
		{
			super(
				"ToTrice",
				"Ton o' Trice",
				"a ton o' trice",
				ConsumableLib.DEFAULT_VALUE,
				"It’s a small bottle of thick turquoise liquid labelled ‘Ton o’ Trice’. The label shows an avian creature with a thick reptilian"+
				" tail and bright coloured plumage playfully flying around the text."
			);
		}

		override public function useItem():Boolean
		{
			var tfSource:String = "TonOTrice";
			player.slimeFeed();
			// init stuff
			changes = 0;
			changeLimit = 1;
			// Randomly choose affects limit
			if (rand(2) == 0) changeLimit++;
			if (rand(2) == 0) changeLimit++;
			if (player.findPerk(PerkLib.HistoryAlchemist) >= 0) changeLimit++;
			if (player.findPerk(PerkLib.TransformationResistance) >= 0) changeLimit--;

			clearOutput();
			outputText("You drink the slimy concoction, grimacing as it reaches your tongue. At first you’re shocked you don’t gag but once you taste"
			          +" the mixture you realise it's not so bad, almost having a hint of almond behind that thick texture.");

			if (player.spe < player.ngPlus(100) && changes < changeLimit && rand(3) == 0) {
				outputText("\n\nYou stumble as you shift position, surprised by how quickly you move. After a moment or two of disorientation,"
				          +" you adjust. You’re certain that you can run faster now.");
				//+3 spe if less than 50
				if (player.lib < 50) dynStats("spe", 1);
				//+2 spe if less than 75
				if (player.lib < 75) dynStats("spe", 1);
				//+1 if above 75.
				dynStats("spe", 1);
				changes++;
			}

			if (player.tou > player.ngPlus(80) && changes < changeLimit && rand(4) == 0) {
				outputText("\n\nYou feel yourself become a little more delicate, as though you can’t handle quite so strong hits anymore. Then again,"
				          +" who needs to withstand a blow when you can just move with the speed of the wind and dodge it?");
				dynStats("tou", -1);
				changes++;

			}

			//-Reduces sensitivity.
			if (player.sens > 20 && changes < changeLimit && rand(3) == 0) {
				outputText("\n\nThe sensation of prickly pins and needles moves over your body, leaving your senses a little dulled in its wake.");
				dynStats("sen", -1);
				changes++;
			}

			//Raises libido greatly to 50, then somewhat to 75, then slowly to 100.
			if (player.lib < 100 && changes < changeLimit && rand(3) == 0) {
				outputText("\n\nA knot of fire in your gut doubles you over but passes after a few moments. As you straighten you can feel the heat"
				          +" seeping into you, ");
				//(DICK)
				if (player.cocks.length > 0 && (player.gender != GENDER_HERM || rand(2) == 0)) {
					outputText("filling [if (cocks > 1)each of] your [cocks] with the desire to breed. You get a bit hornier when you realize your"
					          +" sex-drive has gotten a boost.");
				}
				//(COOCH)
				else if (player.hasVagina()) {
					outputText("puddling in your [vagina]. An instinctive desire to mate and lay eggs spreads through you, increasing your lust and"
					          +" boosting your sex-drive.");
				}
				//(TARDS)
				else {
					outputText("puddling in your featureless crotch for a split-second before it slides into your [ass].  You want to be fucked,"
					          +" filled, and perhaps even gain a proper gender again.  Through the lust you realize your sex-drive has been"
					          +" permanently increased.");
				}
				//+3 lib if less than 50
				if (player.lib < 50) dynStats("lib", 1);
				//+2 lib if less than 75
				if (player.lib < 75) dynStats("lib", 1);
				//+1 if above 75.
				dynStats("lib", 1);
				changes++;
			}

			//FAILSAFE CHANGE
			if (changes == 0) {
				outputText("\n\nInhuman vitality spreads through your body, invigorating you!\n");
				game.HPChange(50, true);
				dynStats("lus", 3);
			}
			player.refillHunger(20);
			game.flags[kFLAGS.TIMES_TRANSFORMED] += changes;
			return false;
		}
	}
}
