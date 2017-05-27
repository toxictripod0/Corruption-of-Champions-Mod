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
			var i:int;
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

			//Sexual changes

			//-Lactation stoppage.
			if (player.biggestLactation() >= 1 && changes < changeLimit && rand(4) == 0) {
				outputText("\n\n[if (totalNipples == 2)Both of your|All of your many] nipples relax. It's a strange feeling, and you pull back your"
				          +" top to touch one. It feels fine, though there doesn't seem to be any milk leaking out.  You give it a squeeze and marvel"
				          +" when nothing [if (hasNippleCunts)but sexual fluid] escapes it. <b>You are no longer lactating.</b> That makes sense,"
				          +" only mammals lactate!  Smiling, you muse at how much time this will save you when cleaning your gear.");
				if (player.findPerk(PerkLib.Feeder) >= 0 || player.hasStatusEffect(StatusEffects.Feeder)) {
					outputText("\n\n(<b>Feeder perk lost!</b>)");
					player.removePerk(PerkLib.Feeder);
					player.removeStatusEffect(StatusEffects.Feeder);
				}
				changes++;
				//Loop through and reset lactation
				for (i = 0; i < player.breastRows.length; i++) {
					player.breastRows[i].lactationMultiplier = 0;
				}
			}

			//-Nipples reduction to 1 per tit.
			if (player.averageNipplesPerBreast() > 1 && changes < changeLimit && rand(4) == 0) {
				outputText("\n\nA chill runs over your [allBreasts] and vanishes. You stick a hand under your [armor] and discover that your extra"
				          +" nipples are missing! You're down to just one per [if (biggestTitSize < 1)'breast'|breast].");
				changes++;
				//Loop through and reset nipples
				for (i = 0; i < player.breastRows.length; i++) {
					player.breastRows[i].nipplesPerBreast = 1;
				}
			}

			//Remove additional breasts
			if (changes < changeLimit && player.breastRows.length > 1 && rand(3) == 0) {
				outputText("\n\nYou stumble back when your center of balance shifts, and though you adjust before you can fall over, you're left to"
				          +" watch in awe as your bottom-most " + player.breastDescript(player.breastRows.length - 1) + " shrink down,"
				          +" disappearing completely into your [if (breastRows >= 3)abdomen|chest]."
				          +" The " + player.nippleDescript(player.breastRows.length - 1) + "s even fade until nothing but ");
				if (player.hasFur()) outputText(player.furColor + " " + player.skinDesc);
				else outputText(player.skinTone + " " + player.skinDesc);
				outputText(" remains. <b>You've lost a row of breasts!</b>");
				dynStats("sen", -5);
				player.removeBreastRow(player.breastRows.length - 1, 1);
				changes++;
			}

			if (player.isFemaleOrHerm()) {
				//Breasts > D cup - Decrease breast size by up to 3 cups
				if (player.isFemaleOrHerm() && player.biggestTitSize() > BREAST_CUP_D && changes < changeLimit && rand(3) == 0) {
					for (i = 0; i < player.breastRows.length; i++) {
						if (player.breastRows[i].breastRating > BREAST_CUP_D)
							player.breastRows[i].breastRating -= 1 + rand(3);
					}
					outputText("\n\nYour breasts feel tight[if (hasArmor), your [armor] feeling looser around your chest]. You watch in shock as your"
							  +" breast flesh rapidly diminishes, shrinking into your chest. They finally stop when they reach [breastcup] size."
							  +" You feel a little lighter.");
					dynStats("spe", 1);
					changes++;
				}

				//Breasts < B cup - Increase breast size by 1 cup
				if (player.isFemaleOrHerm() && player.smallestTitSize() < BREAST_CUP_B && changes < changeLimit && rand(3) == 0) {
					for (i = 0; i < player.breastRows.length; i++) {
						if (player.breastRows[i].breastRating < BREAST_CUP_B)
							player.breastRows[i].breastRating++;
					}
					outputText("\n\nYour breasts feel constrained and painful against your top as they grow larger by the moment, finally stopping as"
							  +" they reach [breastcup] size. You rub the tender orbs as you get used to your larger breast flesh.");
					dynStats("lib", 1);
					changes++;
				}

				//Hips > 12 - decrease hip size by 1-3 sizes
				if (player.hipRating > 12 && changes < changeLimit && rand(3) == 0) {
					outputText("\n\nYou stumble a bit as the bones in your pelvis rearrange themselves painfully. Your hips have narrowed.");
					player.hipRating -= 1 + rand(3);
					changes++;
				}

				//Hips < 6 - increase hip size by 1-3 sizes
				if (player.hipRating < 6 && changes < changeLimit && rand(3) == 0) {
					outputText("\n\nYou stumble as you feel the bones in your hips grinding, expanding your hips noticeably.");
					player.hipRating += 1 + rand(3);
					changes++;
				}

				if (player.nippleLength > 1 && changes < changeLimit && rand(3) == 0) {
					outputText("\n\nWith a sudden pinch your [nipples] get smaller and smaller,"
							  +" stopping when they are roughly half their previous size");
					player.nippleLength /= 2;
				}
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
