package classes.Items
{
	import classes.*;
	import classes.BodyParts.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.lists.ColorLists;

	/**
	 * This class performs the various mutations on the player, transforming one or more
	 * aspects of their appearance.
	 */
	public final class Mutations extends MutationsHelper
	{
		private static var _instance:Mutations = new Mutations();

		public function Mutations()
		{
			if (_instance !== null)
			{
				throw new Error("Mutations can only be accessed through Mutations.init()");
			}
		}

		public static function init():Mutations { return _instance; }

		public function incubiDraft(tainted:Boolean,player:Player):void
		{
			var tfSource:String = "incubiDraft";
			if (!tainted) tfSource += "-purified";
			player.slimeFeed();
			var temp2:Number = 0;
			var temp3:Number = 0;
			var rando:Number = rand(100);
			if (player.hasPerk(PerkLib.HistoryAlchemist)) rando += 10;
			if (player.hasPerk(PerkLib.TransformationResistance)) rando -= 10;
			clearOutput();
			outputText("The draft is slick and sticky, ");
			if (player.cor <= 33) outputText("just swallowing it makes you feel unclean.");
			if (player.cor > 33 && player.cor <= 66) outputText("reminding you of something you just can't place.");
			if (player.cor > 66) outputText("deliciously sinful in all the right ways.");
			if (player.cor >= 90) outputText("  You're sure it must be distilled from the cum of an incubus.");
			//Lowlevel changes
			if (rando < 50) {
				if (player.cocks.length == 1) {
					if (player.cocks[0].cockType !== CockTypesEnum.DEMON) outputText("\n\nYour " + player.cockDescript(0) + " becomes shockingly hard.  It turns a shiny inhuman purple and spasms, dribbling hot demon-like cum as it begins to grow.");
					else outputText("\n\nYour " + player.cockDescript(0) + " becomes shockingly hard.  It dribbles hot demon-like cum as it begins to grow.");
					if (rand(4) === 0) temp = player.increaseCock(0, 3);
					else temp = player.increaseCock(0, 1);
					if (temp < .5) outputText("  It stops almost as soon as it starts, growing only a tiny bit longer.");
					if (temp >= .5 && temp < 1) outputText("  It grows slowly, stopping after roughly half an inch of growth.");
					if (temp >= 1 && temp <= 2) outputText("  The sensation is incredible as more than an inch of lengthened dick-flesh grows in.");
					if (temp > 2) outputText("  You smile and idly stroke your lengthening " + player.cockDescript(0) + " as a few more inches sprout.");
					if (tainted) dynStats("int", 1, "lib", 2, "sen", 1, "lus", 5 + temp * 3, "cor", 1);
					else dynStats("int", 1, "lib", 2, "sen", 1, "lus", 5 + temp * 3);
					if (player.cocks[0].cockType !== CockTypesEnum.DEMON) outputText("  With the transformation complete, your " + player.cockDescript(0) + " returns to its normal coloration.");
					else outputText("  With the transformation complete, your " + player.cockDescript(0) + " throbs in an almost happy way as it goes flaccid once more.");
				}
				if (player.cocks.length > 1) {
					temp = player.cocks.length;
					temp2 = 0;
					//Find shortest cock
					while (temp > 0) {
						temp--;
						if (player.cocks[temp].cockLength <= player.cocks[temp2].cockLength) {
							temp2 = temp;
						}
					}
					if (rand(4) === 0) temp3 = player.increaseCock(temp2, 3);
					else temp3 = player.increaseCock(temp2, 1);
					if (tainted) dynStats("int", 1, "lib", 2, "sen", 1, "lus", 5 + temp * 3, "cor", 1);
					else dynStats("int", 1, "lib", 2, "sen", 1, "lus", 5 + temp * 3);
					//Grammar police for 2 cocks
					if (player.cockTotal() == 2) outputText("\n\nBoth of your " + player.multiCockDescriptLight() + " become shockingly hard, swollen and twitching as they turn a shiny inhuman purple in color.  They spasm, dripping thick ropes of hot demon-like pre-cum along their lengths as your shortest " + player.cockDescript(temp2) + " begins to grow.");
					//For more than 2
					else outputText("\n\nAll of your " + player.multiCockDescriptLight() + " become shockingly hard, swollen and twitching as they turn a shiny inhuman purple in color.  They spasm, dripping thick ropes of hot demon-like pre-cum along their lengths as your shortest " + player.cockDescript(temp2) + " begins to grow.");

					if (temp3 < .5) outputText("  It stops almost as soon as it starts, growing only a tiny bit longer.");
					if (temp3 >= .5 && temp3 < 1) outputText("  It grows slowly, stopping after roughly half an inch of growth.");
					if (temp3 >= 1 && temp3 <= 2) outputText("  The sensation is incredible as more than an inch of lengthened dick-flesh grows in.");
					if (temp3 > 2) outputText("  You smile and idly stroke your lengthening " + player.cockDescript(temp2) + " as a few more inches sprout.");
					outputText("  With the transformation complete, your " + player.multiCockDescriptLight() + " return to their normal coloration.");
				}
				//NO CAWKS?
				if (player.cocks.length == 0) {
					outputText("\n\n");
					growDemonCock(1);
					if (tainted) dynStats("lib", 3, "sen", 5, "lus", 10, "cor", 3);
					else dynStats("lib", 3, "sen", 5, "lus", 10);
				}
				//TIT CHANGE 25% chance of shrinkage
				if (rand(4) === 0 && !flags[kFLAGS.HYPER_HAPPY])
				{
					player.shrinkTits();
				}
			}
			//Mid-level changes
			if (rando >= 50 && rando < 93) {
				if (player.cocks.length > 1) {
					outputText("\n\nYour cocks fill to full-size... and begin growing obscenely.  ");
					temp = player.cocks.length;
					while (temp > 0) {
						temp--;
						temp2 = player.increaseCock(temp, rand(3) + 2);
						temp3 = player.cocks[temp].thickenCock(1);
						if (temp3 < .1) player.cocks[temp].cockThickness += .05;
					}
					player.lengthChange(temp2, player.cocks.length);
					//Display the degree of thickness change.
					if (temp3 >= 1) {
						if (player.cocks.length == 1) outputText("\n\nYour cock spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy.");
						else outputText("\n\nYour cocks spread rapidly, swelling as they grow an inch or more in girth, making them feel fat and floppy.");
					}
					if (temp3 <= .5) {
						if (player.cocks.length > 1) outputText("\n\nYour cocks feel swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. They are definitely thicker.");
						else outputText("\n\nYour cock feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It is definitely thicker.");
					}
					if (temp3 > .5 && temp2 < 1) {
						if (player.cocks.length == 1) outputText("\n\nYour cock seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens.");
						if (player.cocks.length > 1) outputText("\n\nYour cocks seem to swell up, feeling heavier. You look down and watch them growing fatter as they thicken.");
					}
					if (tainted) dynStats("lib", 3, "sen", 5, "lus", 10, "cor", 3);
					else dynStats("lib", 3, "sen", 5, "lus", 10);
				}
				if (player.cocks.length == 1) {
					outputText("\n\nYour cock fills to its normal size and begins growing... ");
					temp3 = player.cocks[0].thickenCock(1);
					temp2 = player.increaseCock(0, rand(3) + 2);
					player.lengthChange(temp2, 1);
					//Display the degree of thickness change.
					if (temp3 >= 1) {
						if (player.cocks.length == 1) outputText("  Your cock spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy.");
						else outputText("  Your cocks spread rapidly, swelling as they grow an inch or more in girth, making them feel fat and floppy.");
					}
					if (temp3 <= .5) {
						if (player.cocks.length > 1) outputText("  Your cocks feel swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. They are definitely thicker.");
						else outputText("  Your cock feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It is definitely thicker.");
					}
					if (temp3 > .5 && temp2 < 1) {
						if (player.cocks.length == 1) outputText("  Your cock seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens.");
						if (player.cocks.length > 1) outputText("  Your cocks seem to swell up, feeling heavier. You look down and watch them growing fatter as they thicken.");
					}
					if (tainted) dynStats("lib", 3, "sen", 5, "lus", 10, "cor", 3);
					else dynStats("lib", 3, "sen", 5, "lus", 10);
				}
				if (player.cocks.length == 0) {
					outputText("\n\n");
					growDemonCock(1);
					if (tainted) dynStats("lib", 3, "sen", 5, "lus", 10, "cor", 3);
					else dynStats("lib", 3, "sen", 5, "lus", 10);
				}
				//Shrink breasts a more
				//TIT CHANGE 50% chance of shrinkage
				if (rand(2) === 0 && !flags[kFLAGS.HYPER_HAPPY])
				{
					player.shrinkTits();
				}
			}
			//High level change
			if (rando >= 93) {
				if (player.cockTotal() < 10) {
					if (rand(10) < int(player.cor / 25)) {
						outputText("\n\n");
						growDemonCock(rand(2) + 2);
						if (tainted) dynStats("lib", 3, "sen", 5, "lus", 10, "cor", 5);
						else dynStats("lib", 3, "sen", 5, "lus", 10);
					}
					else {
						growDemonCock(1);
					}
					if (tainted) dynStats("lib", 3, "sen", 5, "lus", 10, "cor", 3);
					else dynStats("lib", 3, "sen", 5, "lus", 10);
				}
				if (!flags[kFLAGS.HYPER_HAPPY])
				{
					player.shrinkTits();
					player.shrinkTits();
				}
			}
			//Neck restore
			if (player.neck.type !== Neck.NORMAL && changes < changeLimit && rand(4) === 0) restoreNeck(tfSource);
			//Rear body restore
			if (player.hasNonSharkRearBody() && changes < changeLimit && rand(5) === 0) restoreRearBody(tfSource);
			//Ovi perk loss
			if (rand(5) === 0) updateOvipositionPerk(tfSource);
			//Demonic changes - higher chance with higher corruption.
			if (rand(40) + player.cor / 3 > 35 && tainted) demonChanges(tfSource);
			if (rand(4) === 0 && tainted) outputText(player.modFem(5, 2));
			if (rand(4) === 0 && tainted) outputText(player.modThickness(30, 2));
			player.refillHunger(10);
			flags[kFLAGS.TIMES_TRANSFORMED] += changes;
		}

		public function minotaurCum(purified:Boolean, player:Player):void
		{
			player.slimeFeed();
			clearOutput();
			//Minotaur cum addiction
			if (!purified) player.minoCumAddiction(7);
			else player.minoCumAddiction(-2);
			outputText("As soon as you crack the seal on the bottled white fluid, a ");
			if (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] == 0 && !player.hasPerk(PerkLib.MinotaurCumResistance)) outputText("potent musk washes over you.");
			else outputText("heavenly scent fills your nostrils.");
			if (!purified) {
				if (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] < 50) outputText("  It makes you feel dizzy, ditzy, and placid.");
				else outputText("  It makes you feel euphoric, happy, and willing to do ANYTHING to keep feeling this way.");
			}
			else outputText("  You know that the bottle is purified and you're positive you won't get any addiction from this bottle.");
			outputText("  Unbidden, your hand brings the bottle to your lips, and the heady taste fills your mouth as you convulsively swallow the entire bottle.");
			//-Raises lust by 10.
			//-Raises sensitivity
			dynStats("sen", 1, "lus", 10);
			//-Raises corruption by 1 to 50, then by .5 to 75, then by .25 to 100.
			if (!purified) {
				if (player.cor < 50) dynStats("cor", 1);
 				else if (player.cor < 75) dynStats("cor", .5);
				else dynStats("cor", .25);
			}
			outputText("\n\nIntermittent waves of numbness wash through your body, turning into a warm tingling that makes you feel sensitive all over.  The warmth flows through you, converging in your loins and bubbling up into lust.");
			if (player.cocks.length > 0) {
				outputText("  ");
				if (player.cockTotal() == 1) outputText("Y");
				else outputText("Each of y");
				outputText("our " + player.multiCockDescriptLight() + " aches, flooding with blood until it's bloating and trembling.");
			}
			if (player.hasVagina()) {
				outputText("  Your " + player.clitDescript() + " engorges, ");
				if (player.getClitLength() < 3) outputText("parting your lips.");
				else outputText("bursting free of your lips and bobbing under its own weight.");
				if (player.vaginas[0].vaginalWetness <= VaginaClass.WETNESS_NORMAL) outputText("  Wetness builds inside you as your " + player.vaginaDescript(0) + " tingles and aches to be filled.");
				else if (player.vaginas[0].vaginalWetness <= VaginaClass.WETNESS_SLICK) outputText("  A trickle of wetness escapes your " + player.vaginaDescript(0) + " as your body reacts to the desire burning inside you.");
				else if (player.vaginas[0].vaginalWetness <= VaginaClass.WETNESS_DROOLING) outputText("  Wet fluids leak down your thighs as your body reacts to this new stimulus.");
				else outputText("  Slick fluids soak your thighs as your body reacts to this new stimulus.");
			}
			//(Minotaur fantasy)
			if (!kGAMECLASS.inCombat && rand(10) == 1 && (!purified && !player.hasPerk(PerkLib.MinotaurCumResistance))) {
				outputText("\n\nYour eyes flutter closed for a second as a fantasy violates your mind.  You're on your knees, prostrate before a minotaur.  Its narcotic scent fills the air around you, and you're swaying back and forth with your belly already sloshing and full of spunk.  Its equine-like member is rubbing over your face, and you submit to the beast, stretching your jaw wide to take its sweaty, glistening girth inside you.  Your tongue quivers happily as you begin sucking and slurping, swallowing each drop of pre-cum you entice from the beastly erection.  Gurgling happily, you give yourself to your inhuman master for a chance to swallow into unthinking bliss.");
				dynStats("lib", 1, "lus", rand(5) + player.cor / 20 + flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] / 5);
			}
			//(Healing – if hurt and uber-addicted (hasperk))
			if (player.HP < player.maxHP() && player.hasPerk(PerkLib.MinotaurCumAddict)) {
				outputText("\n\nThe fire of your arousal consumes your body, leaving vitality in its wake.  You feel much better!");
				player.HPChange(int(player.maxHP() / 4), false);
			}
			//Uber-addicted status!
			if (player.hasPerk(PerkLib.MinotaurCumAddict) && flags[kFLAGS.MINOTAUR_CUM_REALLY_ADDICTED_STATE] <= 0 && !purified) {
				flags[kFLAGS.MINOTAUR_CUM_REALLY_ADDICTED_STATE] = 3 + rand(2);
				outputText("\n\n<b>Your body feels so amazing and sensitive.  Experimentally you pinch yourself and discover that even pain is turning you on!</b>");
			}
			//Clear mind a bit
			if (purified && (player.hasPerk(PerkLib.MinotaurCumAddict) || flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] >= 40)) {
				outputText("\n\nYour mind feels a bit clearer just from drinking the purified minotaur cum. Maybe if you drink more of these, you'll be able to rid yourself of your addiction?");
				if (player.hasPerk(PerkLib.MinotaurCumAddict) && flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] <= 50) {
					outputText("  Suddenly, you black out and images flash in your mind about getting abducted by minotaurs and the abandonment of your quest that eventually leads to Lethice's success in taking over Mareth. No, it cannot be! You wake up and recover from the blackout, horrified to find out what would really happen if you spend the rest of your life with the Minotaurs! You shake your head and realize that you're no longer dependent on the cum.  ");
					outputText("\n<b>(Lost Perk: Minotaur Cum Addict!)</b>");
					player.removePerk(PerkLib.MinotaurCumAddict);
				}

			}
			player.refillHunger(25);
		}

		public function succubiMilk(tainted:Boolean,player:Player):void
		{
			var tfSource:String = "succubiMilk";
			if (!tainted) tfSource += "-purified";
			player.slimeFeed();
			var temp2:Number = 0;
			var temp3:Number = 0;
			var rando:Number = rand(100);
			if (player.hasPerk(PerkLib.HistoryAlchemist)) rando += 10;
			if (player.hasPerk(PerkLib.TransformationResistance)) rando -= 10;
			clearOutput();
			if (player.cor < 35) outputText("You wonder why in the gods' names you would drink such a thing, but you have to admit, it is the best thing you have ever tasted.");
			if (player.cor >= 35 && player.cor < 70) {
				outputText("You savor the incredible flavor as you greedily gulp it down.");
				if (player.gender == 2 || player.gender == 3) {
					outputText("  The taste alone makes your " + player.vaginaDescript(0) + " feel ");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DRY) outputText("tingly.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_NORMAL) outputText("wet.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_WET) outputText("sloppy and wet.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLICK) outputText("sopping and juicy.");
					if (player.vaginas[0].vaginalWetness >= VaginaClass.WETNESS_DROOLING) outputText("dripping wet.");
				}
				else if (player.hasCock()) outputText("  You feel a building arousal, but it doesn't affect your cock.");
			}
			if (player.cor >= 70) {
				outputText("You pour the milk down your throat, chugging the stuff as fast as you can.  You want more.");
				if (player.gender == 2 || player.gender == 3) {
					outputText("  Your " + player.vaginaDescript(0));
					if (player.vaginas.length > 1) outputText(" quiver in orgasm, ");
					if (player.vaginas.length == 1) outputText(" quivers in orgasm, ");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DRY) outputText("becoming slightly sticky.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_NORMAL) outputText("leaving your undergarments sticky.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_WET) outputText("wet with girlcum.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLICK) outputText("staining your undergarments with cum.");
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DROOLING) outputText("leaving cunt-juice trickling down your leg.");
					if (player.vaginas[0].vaginalWetness >= VaginaClass.WETNESS_SLAVERING) outputText("spraying your undergarments liberally with slick girl-cum.");
					player.orgasm('Vaginal');
				}
				else if (player.gender !== 0) {
					if (player.cocks.length == 1) outputText("  You feel a strange sexual pleasure, but your " + player.multiCockDescript() + " remains unaffected.");
					else outputText("  You feel a strange sexual pleasure, but your " + player.multiCockDescript() + " remain unaffected.");
				}
			}
			if (tainted) dynStats("spe", 1, "lus", 3, "cor", 1);
			else dynStats("spe", 1, "lus", 3);
			//Breast growth (maybe cock reduction!)
			if (rando <= 75) {
				//Temp stores the level of growth...
				temp = 1 + rand(3);
				if (player.breastRows.length > 0) {
					if (player.breastRows[0].breastRating < 2 && rand(3) === 0) temp++;
					if (player.breastRows[0].breastRating < 5 && rand(4) === 0) temp++;
					if (player.breastRows[0].breastRating < 6 && rand(5) === 0) temp++;
				}
				outputText("\n\n");
				player.growTits(temp, player.breastRows.length, true, 3);
				if (player.breastRows.length == 0) {
					outputText("A perfect pair of B cup breasts, complete with tiny nipples, form on your chest.");
					player.createBreastRow();
					player.breastRows[0].breasts = 2;
					player.breastRows[0].nipplesPerBreast = 1;
					player.breastRows[0].breastRating = 2;
					outputText("\n");
				}
				if (!flags[kFLAGS.HYPER_HAPPY])
				{
					// Shrink cocks if you have them.
					if (player.cocks.length > 0) {
						temp = 0;
						temp2 = player.cocks.length;
						temp3 = 0;
						//Find biggest cock
						while (temp2 > 0) {
							temp2--;
							if (player.cocks[temp].cockLength <= player.cocks[temp2].cockLength) temp = temp2;
						}
						//Shrink said cock
						if (player.cocks[temp].cockLength < 6 && player.cocks[temp].cockLength >= 2.9) {
							player.cocks[temp].cockLength -= .5;
							temp3 -= .5;
							if (player.cocks[temp].cockThickness * 6 > player.cocks[temp].cockLength) player.cocks[temp].cockThickness -= .2;
							if (player.cocks[temp].cockThickness * 8 > player.cocks[temp].cockLength) player.cocks[temp].cockThickness -= .2;
							if (player.cocks[temp].cockThickness < .5) player.cocks[temp].cockThickness = .5;
						}
						temp3 += player.increaseCock(temp, (rand(3) + 1) * -1);
						outputText("\n\n");
						player.lengthChange(temp3, 1);
						if (player.cocks[temp].cockLength < 2) {
							outputText("  ");
							player.killCocks(1);
						}
					}
				}
			}
			if (player.vaginas.length == 0 && (rand(3) === 0 || (rando > 75 && rando < 90))) {
				player.createVagina();
				player.vaginas[0].vaginalLooseness = VaginaClass.LOOSENESS_TIGHT;
				player.vaginas[0].vaginalWetness = VaginaClass.WETNESS_NORMAL;
				player.vaginas[0].virgin = true;
				player.setClitLength(.25);
				if (player.fertility <= 5) player.fertility = 6;
				outputText("\n\nAn itching starts in your crotch and spreads vertically.  You reach down and discover an opening.  You have grown a <b>new " + player.vaginaDescript(0) + "</b>!");
			}
			//Increase pussy wetness or grow one!!
			else if (rando > 75 && rando < 90) {
				//Shrink cawk
				if (player.cocks.length > 0 && !flags[kFLAGS.HYPER_HAPPY]) {
					outputText("\n\n");
					temp = 0;
					temp2 = player.cocks.length;
					//Find biggest cock
					while (temp2 > 0) {
						temp2--;
						if (player.cocks[temp].cockLength <= player.cocks[temp2].cockLength) temp = temp2;
					}
					//Shrink said cock
					if (player.cocks[temp].cockLength < 6 && player.cocks[temp].cockLength >= 2.9) {
						player.cocks[temp].cockLength -= .5;
					}
					temp3 = player.increaseCock(temp, -1 * (rand(3) + 1));
					player.lengthChange(temp3, 1);
					if (player.cocks[temp].cockLength < 3) {
						outputText("  ");
						player.killCocks(1);
					}
				}
				if (player.vaginas.length > 0) {
					outputText("\n\n");
					//0 = dry, 1 = wet, 2 = extra wet, 3 = always slick, 4 = drools constantly, 5 = female ejaculator
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLAVERING) {
						if (player.vaginas.length == 1) outputText("Your " + player.vaginaDescript(0) + " gushes fluids down your leg as you spontaneously orgasm.");
						else outputText("Your " + player.vaginaDescript(0) + "s gush fluids down your legs as you spontaneously orgasm, leaving a thick puddle of pussy-juice on the ground.  It is rapidly absorbed by the earth.");
						player.orgasm('Vaginal');
						if (tainted) dynStats("cor", 1);
					}
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DROOLING) {
						if (player.vaginas.length == 1) outputText("Your pussy feels hot and juicy, aroused and tender.  You cannot resist as your hands dive into your " + player.vaginaDescript(0) + ".  You quickly orgasm, squirting fluids everywhere.  <b>You are now a squirter</b>.");
						if (player.vaginas.length > 1) outputText("Your pussies feel hot and juicy, aroused and tender.  You cannot resist plunging your hands inside your " + player.vaginaDescript(0) + "s.  You quiver around your fingers, squirting copious fluids over yourself and the ground.  The fluids quickly disappear into the dirt.");
						player.orgasm('Vaginal');
						if (tainted) dynStats("cor", 1);
					}
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLICK) {
						if (player.vaginas.length == 1) outputText("You feel a sudden trickle of fluid down your leg.  You smell it and realize it's your pussy-juice.  Your " + player.vaginaDescript(0) + " now drools lubricant constantly down your leg.");
						if (player.vaginas.length > 1) outputText("You feel sudden trickles of fluids down your leg.  You smell the stuff and realize it's your pussies-juices.  They seem to drool lubricant constantly down your legs.");
					}
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_WET) {
						outputText("You flush in sexual arousal as you realize how moist your cunt-lips have become.  Once you've calmed down a bit you realize they're still slick and ready to fuck, and always will be.");
					}
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_NORMAL) {
						if (player.vaginas.length == 1) outputText("A feeling of intense arousal passes through you, causing you to masturbate furiously.  You realize afterwards that your " + player.vaginaDescript(0) + " felt much wetter than normal.");
						else outputText("A feeling of intense arousal passes through you, causing you to masturbate furiously.  You realize afterwards that your " + player.vaginaDescript(0) + " were much wetter than normal.");
					}
					if (player.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DRY) {
						outputText("You feel a tingling in your crotch, but cannot identify it.");
					}
					temp = player.vaginas.length;
					while (temp > 0) {
						temp--;
						if (player.vaginas[temp].vaginalWetness < VaginaClass.WETNESS_SLAVERING) player.vaginas[temp].vaginalWetness++;
					}
				}
			}
			if (rando >= 90) {
				if (!tainted || player.skin.tone == "blue" || player.skin.tone == "purple" || player.skin.tone == "indigo" || player.skin.tone == "shiny black") {
					if (player.vaginas.length > 0) {
						outputText("\n\nYour heart begins beating harder and harder as heat floods to your groin.  You feel your clit peeking out from under its hood, growing larger and longer as it takes in more and more blood.");
						if (player.getClitLength() > 3 && !player.hasPerk(PerkLib.BigClit)) outputText("  After some time it shrinks, returning to its normal aroused size.  You guess it can't get any bigger.");
						if (player.getClitLength() > 5 && player.hasPerk(PerkLib.BigClit)) outputText("  Eventually it shrinks back down to its normal (but still HUGE) size.  You guess it can't get any bigger.");
						if (((player.hasPerk(PerkLib.BigClit)) && player.getClitLength() < 6)
							|| player.getClitLength() < 3) {
							temp = 2; // minimum growth
							if (player.hasPerk(PerkLib.BigClit)) temp += 2;
							player.changeClitLength((rand(4) + temp) / 10);
						}
						dynStats("sen", 3, "lus", 8);
					}
					else {
						player.createVagina();
						player.vaginas[0].vaginalLooseness = VaginaClass.LOOSENESS_TIGHT;
						player.vaginas[0].vaginalWetness = VaginaClass.WETNESS_NORMAL;
						player.vaginas[0].virgin = true;
						player.setClitLength(.25);
						outputText("\n\nAn itching starts in your crotch and spreads vertically.  You reach down and discover an opening.  You have grown a <b>new " + player.vaginaDescript(0) + "</b>!");
					}
				}
				else {
					temp = rand(10);
					if (temp == 0) player.skin.tone = "shiny black";
					if (temp == 1 || temp == 2) player.skin.tone = "indigo";
					if (temp == 3 || temp == 4 || temp == 5) player.skin.tone = "purple";
					if (temp > 5) player.skin.tone = "blue";
					outputText("\n\nA tingling sensation runs across your skin in waves, growing stronger as <b>your skin's tone slowly shifts, darkening to become " + player.skin.tone + " in color.</b>");
					player.arms.updateClaws(player.arms.claws.type);
					if (tainted) dynStats("cor", 1);
					else dynStats("cor", 0);
					kGAMECLASS.rathazul.addMixologyXP(20);
				}
			}
			//Neck restore
			if (player.neck.type !== Neck.NORMAL && changes < changeLimit && rand(4) === 0) restoreNeck(tfSource);
			//Rear body restore
			if (player.hasNonSharkRearBody() && changes < changeLimit && rand(5) === 0) restoreRearBody(tfSource);
			//Ovi perk loss
			if (rand(5) === 0) updateOvipositionPerk(tfSource);
			//Demonic changes - higher chance with higher corruption.
			if (rand(40) + player.cor / 3 > 35 && tainted) demonChanges(tfSource);
			if (tainted) {
				outputText(player.modFem(100, 2));
				if (rand(3) === 0) outputText(player.modTone(15, 2));
			}
			else {
				outputText(player.modFem(90, 1));
				if (rand(3) === 0) outputText(player.modTone(20, 2));
			}
			player.refillHunger(20);
			flags[kFLAGS.TIMES_TRANSFORMED] += changes;
		}


		public function succubisDelight(tainted:Boolean,player:Player):void
		{
			player.slimeFeed();
			var crit:Number = 1;
			//Determine crit multiplier (x2 or x3)
			if (rand(4) === 0) crit += rand(2) + 1;
			initTransformation([2, 2]);
			//Generic drinking text
			clearOutput();
			outputText("You uncork the bottle and drink down the strange substance, struggling to down the thick liquid.");
			//low corruption thoughts
			if (player.cor < 33) outputText("  This stuff is gross, why are you drinking it?");
			//high corruption
			if (player.cor >= 66) outputText("  You lick your lips, marvelling at how thick and sticky it is.");
			//Corruption increase
			if ((player.cor < 50 || rand(2)) && tainted) {
				outputText("\n\nThe drink makes you feel... dirty.");
				var temp:Number = 1;
				//Corrupts the uncorrupted faster
 				if (player.cor < 50) temp++;
 				if (player.cor < 40) temp++;
 				if (player.cor < 30) temp++;
				//Corrupts the very corrupt slower
				if (player.cor >= 90) temp = .5;
				if (tainted) dynStats("cor", temp);
				else dynStats("cor", 0);
				changes++;
			}
			//Makes your balls biggah! (Or cummultiplier higher if futa!)
			if (rand(1.5) === 0 && changes < changeLimit && player.balls > 0) {
				player.ballSize++;
				//They grow slower as they get bigger...
				if (player.ballSize > 10) player.ballSize -= .5;
				//Texts
				if (player.ballSize <= 2) outputText("\n\nA flash of warmth passes through you and a sudden weight develops in your groin.  You pause to examine the changes and your roving fingers discover your " + player.simpleBallsDescript() + " have grown larger than a human's.");
				if (player.ballSize > 2) outputText("\n\nA sudden onset of heat envelops your groin, focusing on your " + player.sackDescript() + ".  Walking becomes difficult as you discover your " + player.simpleBallsDescript() + " have enlarged again.");
				dynStats("lib", 1, "lus", 3);
				changes++;
			}
			//Grow new balls!
			if (player.balls < 2 && changes < changeLimit && rand(4) === 0) {
				if (player.balls == 0) {
					player.balls = 2;
					outputText("\n\nIncredible pain scythes through your crotch, doubling you over.  You stagger around, struggling to pull open your " + player.armorName + ".  In shock, you barely register the sight before your eyes: <b>You have balls!</b>");
					player.ballSize = 1;
				}
				changes++;
			}
			//Boost cum multiplier
			if (changes < changeLimit && rand(2) === 0 && player.cocks.length > 0) {
				if (player.cumMultiplier < 6 && rand(2) === 0 && changes < changeLimit) {
					//Temp is the max it can be raised to
					temp = 3;
					//Lots of cum raises cum multiplier cap to 6 instead of 3
					if (player.hasPerk(PerkLib.MessyOrgasms)) temp = 6;
					if (temp < player.cumMultiplier + .4 * crit) {
						changes--;
					}
					else {
						player.cumMultiplier += .4 * crit;
						//Flavor text
						if (player.balls == 0) outputText("\n\nYou feel a churning inside your body as something inside you changes.");
						if (player.balls > 0) outputText("\n\nYou feel a churning in your " + player.ballsDescriptLight() + ".  It quickly settles, leaving them feeling somewhat more dense.");
						if (crit > 1) outputText("  A bit of milky pre dribbles from your " + player.multiCockDescriptLight() + ", pushed out by the change.");
						dynStats("lib", 1);
					}
					changes++;
				}
			}
			//Fail-safe
			if (changes == 0) {
				outputText("\n\nYour groin tingles, making it feel as if you haven't cum in a long time.");
				player.hoursSinceCum += 100;
			}
			if (player.balls > 0 && rand(3) === 0) {
				outputText(player.modFem(12, 3));
			}
			player.refillHunger(10);
		}

//butt expansion
		public function brownEgg(large:Boolean,player:Player):void
		{
			clearOutput();
			outputText("You devour the egg, momentarily sating your hunger.\n\n");
			if (!large) {
				outputText("You feel a bit of additional weight on your backside as your " + player.buttDescript() + " gains a bit more padding.");
				player.butt.rating++;
				player.refillHunger(20);
			}
			else {
				outputText("Your " + player.buttDescript() + " wobbles, nearly throwing you off balance as it grows much bigger!");
				player.butt.rating += 2 + rand(3);
				player.refillHunger(60);
			}
			if (rand(3) === 0) {
				if (large) outputText(player.modThickness(100, 8));
				else outputText(player.modThickness(95, 3));
			}

		}

//hip expansion
		public function purpleEgg(large:Boolean,player:Player):void
		{
			clearOutput();
			outputText("You devour the egg, momentarily sating your hunger.\n\n");
			if (!large || player.hips.rating > 20) {
				outputText("You stumble as you feel your " + player.hipDescript() + " widen, altering your gait slightly.");
				player.hips.rating++;
				player.refillHunger(20);
			}
			else {
				outputText("You stagger wildly as your hips spread apart, widening by inches.  When the transformation finishes you feel as if you have to learn to walk all over again.");
				player.hips.rating += 2 + rand(2);
				player.refillHunger(60);
			}
			if (rand(3) === 0) {
				if (large) outputText(player.modThickness(80, 8));
				else outputText(player.modThickness(80, 3));
			}
		}

//Femminess
		public function pinkEgg(large:Boolean,player:Player):void
		{
			clearOutput();
			outputText("You devour the egg, momentarily sating your hunger.\n\n");
			if (!large) {
				//Remove a dick
				if (player.cocks.length > 0) {
					player.killCocks(1);
					outputText("\n\n");
				}
				//remove balls
				if (player.balls > 0) {
					if (player.ballSize > 15) {
						player.ballSize -= 8;
						outputText("Your scrotum slowly shrinks, settling down at a MUCH smaller size.  <b>Your " + player.ballsDescriptLight() + " are much smaller.</b>\n\n");
					}
					else {
						player.balls = 0;
						player.ballSize = 1;
						outputText("Your scrotum slowly shrinks, eventually disappearing entirely!  <b>You've lost your balls!</b>\n\n");
					}
				}
				//Fertility boost
				if (player.vaginas.length > 0 && player.fertility < 40) {
					outputText("You feel a tingle deep inside your body, just above your " + player.vaginaDescript(0) + ", as if you were becoming more fertile.\n\n");
					player.fertility += 5;
				}
				player.refillHunger(20);
			}
			//LARGE
			else {
				//Remove a dick
				if (player.cocks.length > 0) {
					player.killCocks(-1);
					outputText("\n\n");
				}
				if (player.balls > 0) {
					player.balls = 0;
					player.ballSize = 1;
					outputText("Your scrotum slowly shrinks, eventually disappearing entirely!  <b>You've lost your balls!</b>\n\n");
				}
				//Fertility boost
				if (player.vaginas.length > 0 && player.fertility < 70) {
					outputText("You feel a powerful tingle deep inside your body, just above your " + player.vaginaDescript(0) + ". Instinctively you know you have become more fertile.\n\n");
					player.fertility += 10;
				}
				player.refillHunger(60);
			}
			if (rand(3) === 0) {
				if (large) outputText(player.modFem(100, 8));
				else outputText(player.modFem(95, 3));
			}
		}

//Maleness
		public function blueEgg(large:Boolean,player:Player):void
		{
			clearOutput();
			var temp2:Number = 0;
			var temp3:Number = 0;
			outputText("You devour the egg, momentarily sating your hunger.");
			if (!large) {
				//Kill pussies!
				if (player.vaginas.length > 0) {
					outputText("\n\nYour vagina clenches in pain, doubling you over.  You slip a hand down to check on it, only to feel the slit growing smaller and smaller until it disappears, taking your clit with it! <b> Your vagina is gone!</b>");
					player.setClitLength(.5);
					player.removeVagina(0, 1);
				}
				//Dickz
				if (player.cocks.length > 0) {
					//Multiz
					if (player.cocks.length > 1) {
						outputText("\n\nYour " + player.multiCockDescript() + " fill to full-size... and begin growing obscenely.");
						temp = player.cocks.length;
						while (temp > 0) {
							temp--;
							temp2 = player.increaseCock(temp, rand(3) + 2);
							temp3 = player.cocks[temp].thickenCock(1);
						}
						player.lengthChange(temp2, player.cocks.length);
						//Display the degree of thickness change.
						if (temp3 >= 1) {
							if (player.cocks.length == 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy.");
							else outputText("\n\nYour " + player.multiCockDescriptLight() + " spread rapidly, swelling as they grow an inch or more in girth, making them feel fat and floppy.");
						}
						if (temp3 <= .5) {
							if (player.cocks.length > 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " feel swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. They are definitely thicker.");
							else outputText("\n\nYour " + player.multiCockDescriptLight() + " feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It is definitely thicker.");
						}
						if (temp3 > .5 && temp2 < 1) {
							if (player.cocks.length == 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens.");
							if (player.cocks.length > 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " seem to swell up, feeling heavier. You look down and watch them growing fatter as they thicken.");
						}
						dynStats("lib", 1, "sen", 1, "lus", 20);
					}
					//SINGLEZ
					if (player.cocks.length == 1) {
						outputText("\n\nYour " + player.multiCockDescriptLight() + " fills to its normal size... and begins growing... ");
						temp3 = player.cocks[0].thickenCock(1);
						temp2 = player.increaseCock(0, rand(3) + 2);
						player.lengthChange(temp2, 1);
						//Display the degree of thickness change.
						if (temp3 >= 1) {
							if (player.cocks.length == 1) outputText("  Your " + player.multiCockDescriptLight() + " spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy.");
							else outputText("  Your " + player.multiCockDescriptLight() + " spread rapidly, swelling as they grow an inch or more in girth, making them feel fat and floppy.");
						}
						if (temp3 <= .5) {
							if (player.cocks.length > 1) outputText("  Your " + player.multiCockDescriptLight() + " feel swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. They are definitely thicker.");
							else outputText("  Your " + player.multiCockDescriptLight() + " feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It is definitely thicker.");
						}
						if (temp3 > .5 && temp2 < 1) {
							if (player.cocks.length == 1) outputText("  Your " + player.multiCockDescriptLight() + " seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens.");
							if (player.cocks.length > 1) outputText("  Your " + player.multiCockDescriptLight() + " seem to swell up, feeling heavier. You look down and watch them growing fatter as they thicken.");
						}
						dynStats("lib", 1, "sen", 1, "lus", 20);
					}

				}
				player.refillHunger(20);
			}
			//LARGE
			else {
				//New lines if changes
				if (player.bRows() > 1 || player.butt.rating > 5 || player.hips.rating > 5 || player.hasVagina()) outputText("\n\n");
				//Kill pussies!
				if (player.vaginas.length > 0) {
					outputText("Your vagina clenches in pain, doubling you over.  You slip a hand down to check on it, only to feel the slit growing smaller and smaller until it disappears, taking your clit with it!\n\n");
					if (player.bRows() > 1 || player.butt.rating > 5 || player.hips.rating > 5) outputText("  ");
					player.setClitLength(.5);
					player.removeVagina(0, 1);
				}
				//Kill extra boobages
				if (player.bRows() > 1) {
					outputText("Your back relaxes as extra weight vanishes from your chest.  <b>Your lowest " + player.breastDescript(player.bRows() - 1) + " have vanished.</b>");
					if (player.butt.rating > 5 || player.hips.rating > 5) outputText("  ");
					//Remove lowest row.
					player.removeBreastRow((player.bRows() - 1), 1);
				}
				//Ass/hips shrinkage!
				if (player.butt.rating > 5) {
					outputText("Muscles firm and tone as you feel your " + player.buttDescript() + " become smaller and tighter.");
					if (player.hips.rating > 5) outputText("  ");
					player.butt.rating -= 2;
				}
				if (player.hips.rating > 5) {
					outputText("Feeling the sudden burning of lactic acid in your " + player.hipDescript() + ", you realize they have slimmed down and firmed up some.");
					player.hips.rating -= 2;
				}
				//Shrink tits!
				if (player.biggestTitSize() > 0)
				{
					player.shrinkTits();
				}
				if (player.cocks.length > 0) {
					//Multiz
					if (player.cocks.length > 1) {
						outputText("\n\nYour " + player.multiCockDescript() + " fill to full-size... and begin growing obscenely.  ");
						temp = player.cocks.length;
						while (temp > 0) {
							temp--;
							temp2 = player.increaseCock(temp, rand(3) + 5);
							temp3 = player.cocks[temp].thickenCock(1.5);
						}
						player.lengthChange(temp2, player.cocks.length);
						//Display the degree of thickness change.
						if (temp3 >= 1) {
							if (player.cocks.length == 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy.");
							else outputText("\n\nYour " + player.multiCockDescriptLight() + " spread rapidly, swelling as they grow an inch or more in girth, making them feel fat and floppy.");
						}
						if (temp3 <= .5) {
							if (player.cocks.length > 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " feel swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. They are definitely thicker.");
							else outputText("\n\nYour " + player.multiCockDescriptLight() + " feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It is definitely thicker.");
						}
						if (temp3 > .5 && temp2 < 1) {
							if (player.cocks.length == 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens.");
							if (player.cocks.length > 1) outputText("\n\nYour " + player.multiCockDescriptLight() + " seem to swell up, feeling heavier. You look down and watch them growing fatter as they thicken.");
						}
						dynStats("lib", 1, "sen", 1, "lus", 20);
					}
					//SINGLEZ
					if (player.cocks.length == 1) {
						outputText("\n\nYour " + player.multiCockDescriptLight() + " fills to its normal size... and begins growing...");
						temp3 = player.cocks[0].thickenCock(1.5);
						temp2 = player.increaseCock(0, rand(3) + 5);
						player.lengthChange(temp2, 1);
						//Display the degree of thickness change.
						if (temp3 >= 1) {
							if (player.cocks.length == 1) outputText("  Your " + player.multiCockDescriptLight() + " spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy.");
							else outputText("  Your " + player.multiCockDescriptLight() + " spread rapidly, swelling as they grow an inch or more in girth, making them feel fat and floppy.");
						}
						if (temp3 <= .5) {
							if (player.cocks.length > 1) outputText("  Your " + player.multiCockDescriptLight() + " feel swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. They are definitely thicker.");
							else outputText("  Your " + player.multiCockDescriptLight() + " feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It is definitely thicker.");
						}
						if (temp3 > .5 && temp2 < 1) {
							if (player.cocks.length == 1) outputText("  Your " + player.multiCockDescriptLight() + " seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens.");
							if (player.cocks.length > 1) outputText("  Your " + player.multiCockDescriptLight() + " seem to swell up, feeling heavier. You look down and watch them growing fatter as they thicken.");
						}
						dynStats("lib", 1, "sen", 1, "lus", 20);
					}
				}
				player.refillHunger(60);
			}
			if (rand(3) === 0) {
				if (large) outputText(player.modFem(0, 8));
				else outputText(player.modFem(5, 3));
			}
		}

//Nipplezzzzz
		public function whiteEgg(large:Boolean,player:Player):void
		{
			clearOutput();
			var temp2:Number = 0;
			outputText("You devour the egg, momentarily sating your hunger.");
			if (!large) {
				//Grow nipples
				if (player.nippleLength < 3 && player.biggestTitSize() > 0) {
					outputText("\n\nYour nipples engorge, prodding hard against the inside of your " + player.armorName + ".  Abruptly you realize they've gotten almost a quarter inch longer.");
					player.nippleLength += .2;
					dynStats("lus", 15);
				}
				player.refillHunger(20);
			}
			//LARGE
			else {
				//Grow nipples
				if (player.nippleLength < 3 && player.biggestTitSize() > 0) {
					outputText("\n\nYour nipples engorge, prodding hard against the inside of your " + player.armorName + ".  Abruptly you realize they've grown more than an additional quarter-inch.");
					player.nippleLength += (rand(2) + 3) / 10;
					dynStats("lus", 15);
				}
				//NIPPLECUNTZZZ
				temp = player.breastRows.length;
				//Set nipplecunts on every row.
				while (temp > 0) {
					temp--;
					if (!player.breastRows[temp].fuckable && player.nippleLength >= 2) {
						player.breastRows[temp].fuckable = true;
						//Keep track of changes.
						temp2++;
					}
				}
				//Talk about if anything was changed.
				if (temp2 > 0) outputText("\n\nYour " + player.allBreastsDescript() + " tingle with warmth that slowly migrates to your nipples, filling them with warmth.  You pant and moan, rubbing them with your fingers.  A trickle of wetness suddenly coats your finger as it slips inside the nipple.  Shocked, you pull the finger free.  <b>You now have fuckable nipples!</b>");
				player.refillHunger(60);
			}
		}

		public function blackRubberEgg(large:Boolean,player:Player):void
		{
			clearOutput();
			outputText("You devour the egg, momentarily sating your hunger.");
			//Small
			if (!large) {
				//Change skin to normal if not flawless!
				if ((player.skin.adj !== "smooth" && player.skin.adj !== "latex" && player.skin.adj !== "rubber") || player.skin.desc !== "skin") {
					outputText("\n\nYour " + player.skin.desc + " tingles delightfully as it ");
					if (player.hasPlainSkin()) outputText(" loses its blemishes, becoming flawless smooth skin.");
					if (player.hasFur()) outputText(" falls out in clumps, revealing smooth skin underneath.");
					if (player.hasScales()) outputText(" begins dropping to the ground in a pile around you, revealing smooth skin underneath.");
					if (player.hasGooSkin()) outputText(" shifts and changes into flawless smooth skin.");
					player.skin.desc = "skin";
					player.skin.adj = "smooth";
					if (player.skin.tone == "rough gray") player.skin.tone = "gray";
					player.skin.type = Skin.PLAIN;
					player.underBody.restore();
					player.arms.updateClaws(player.arms.claws.type);
				}
				//chance of hair change
				else {
					//If hair isn't rubbery/latex yet
					if (player.hair.color.indexOf("rubbery") == -1 && player.hair.color.indexOf("latex-textured") && player.hair.length !== 0) {
						//if skin is already one...
						if (player.skin.desc == "skin" && player.skin.adj == "rubber") {
							outputText("\n\nYour scalp tingles and your " + player.hairDescript() + " thickens, the strands merging into ");
							outputText(" thick rubbery hair.");
							player.hair.color = "rubbery " + player.hair.color;
							dynStats("cor", 2);
						}
						if (player.skin.desc == "skin" && player.skin.adj == "latex") {
							outputText("\n\nYour scalp tingles and your " + player.hairDescript() + " thickens, the strands merging into ");
							outputText(" shiny latex hair.");
							player.hair.color = "latex-textured " + player.hair.color;
							dynStats("cor", 2);
						}
					}
				}
				player.refillHunger(20);
			}
			//Large
			if (large) {
				//Change skin to latex if smooth.
				if (player.skin.desc == "skin" && player.skin.adj == "smooth") {
					outputText("\n\nYour already flawless smooth skin begins to tingle as it changes again.  It becomes shinier as its texture changes subtly.  You gasp as you touch yourself and realize your skin has become ");
					if (rand(2) === 0) {
						player.skin.desc = "skin";
						player.skin.adj = "latex";
						outputText("a layer of pure latex.  ");
					}
					else {
						player.skin.desc = "skin";
						player.skin.adj = "rubber";
						outputText("a layer of sensitive rubber.  ");
					}
					flags[kFLAGS.PC_KNOWS_ABOUT_BLACK_EGGS] = 1;
					if (player.cor < 66) outputText("You feel like some kind of freak.");
					else outputText("You feel like some kind of sexy " + player.skin.desc + " love-doll.");
					dynStats("spe", -3, "sen", 8, "lus", 10, "cor", 2);
				}
				//Change skin to normal if not flawless!
				if ((player.skin.adj !== "smooth" && player.skin.adj !== "latex" && player.skin.adj !== "rubber") || player.skin.desc !== "skin") {
					outputText("\n\nYour " + player.skin.desc + " tingles delightfully as it ");
					if (player.hasPlainSkin()) outputText(" loses its blemishes, becoming flawless smooth skin.");
					if (player.hasFur()) outputText(" falls out in clumps, revealing smooth skin underneath.");
					if (player.hasScales()) outputText(" begins dropping to the ground in a pile around you, revealing smooth skin underneath.");
					if (player.hasGooSkin()) outputText(" shifts and changes into flawless smooth skin.");
					player.skin.desc = "skin";
					player.skin.adj = "smooth";
					if (player.skin.tone == "rough gray") player.skin.tone = "gray";
					player.skin.type = Skin.PLAIN;
					player.underBody.restore();
					player.arms.updateClaws(player.arms.claws.type);
				}
				//chance of hair change
				else {
					//If hair isn't rubbery/latex yet
					if (player.hair.color.indexOf("rubbery") == -1 && player.hair.color.indexOf("latex-textured") && player.hair.length !== 0) {
						//if skin is already one...
						if (player.skin.adj == "rubber" && player.skin.desc == "skin") {
							outputText("\n\nYour scalp tingles and your " + player.hairDescript() + " thickens, the strands merging into ");
							outputText(" thick rubbery hair.");
							player.hair.color = "rubbery " + player.hair.color;
							dynStats("cor", 2);
						}
						if (player.skin.adj == "latex" && player.skin.desc == "skin") {
							outputText("\n\nYour scalp tingles and your " + player.hairDescript() + " thickens, the strands merging into ");
							outputText(" shiny latex hair.");
							player.hair.color = "latex-textured " + player.hair.color;
							dynStats("cor", 2);
						}
					}
				}
				player.refillHunger(60);
			}
		}

		/*Purified LaBova:
		 This will be one of the items that the player will have to give Marble to purify her, but there is a limit on how much she can be purified in this way.
		 Effects on the player:
		 Mostly the same, but without animal transforms, corruption, and lower limits on body changes
		 Hips and ass cap at half the value for LaBova
		 Nipple growth caps at 1 inch
		 Breasts cap at E or DD cup
		 Raises lactation to a relatively low level, reduces high levels: \"Your breasts suddenly feel less full, it seems you aren't lactating at quite the level you where.\"  OR  \"The insides of your breasts suddenly feel bloated.  There is a spray of milk from them, and they settle closer to a more natural level of lactation.\"
		 Does not apply the addictive quality
		 If the player has the addictive quality, this item can remove that effect

		 Enhanced LaBova:
		 Something that the player can either make or find later; put it in whenever you want, or make your own item.  This is just a possible suggestion.  If it is given to Marble, she only gains the quad nipples.
		 Effects on the player
		 Mostly the same, but some of the effects can be more pronounced.  Ie, more str gain from one dose, or more breast growth.
		 If the player's nipples are larger than 1 inch in length, this item is guaranteed to give them quad nipples.  This applies to all their breasts; seems like it ould be a good compromise on whether or not cowgirls should have 4 breasts.
		 Very small chance to increase fertility (normally this increase would only happen when the player forces a creature to drink their milk).
		 */
		public function laBova(tainted:Boolean,enhanced:Boolean,player:Player):void
		{
			var tfSource:String = "laBova";
			player.slimeFeed();
			initTransformation([2, 3, 3], enhanced ? 3 : 1);
			//Temporary storage
			var temp:Number = 0;
			var temp2:Number = 0;
			var temp3:Number = 0;
			//LaBova:
			//ItemDesc: "A bottle containing a misty fluid with a grainy texture, it has a long neck and a ball-like base.  The label has a stylized picture of a well endowed cowgirl nursing two guys while they jerk themselves off.  "
			//ItemUseText:
			clearOutput();
			outputText("You drink the ");
			if (enhanced) outputText("Pro Bova");
			else outputText("La Bova");
			outputText(".  The drink has an odd texture, but is very sweet.  It has a slight aftertaste of milk.");
			//Possible Item Effects:
			//STATS
			//Increase player str:
			if (changes < changeLimit && rand(3) === 0) {
				temp = 60 - player.str;
				if (temp <= 0) temp = 0;
				else {
					if (rand(2) === 0) outputText("\n\nThere is a slight pain as you feel your muscles shift somewhat.  Their appearance does not change much, but you feel much stronger.");
					else outputText("\n\nYou feel your muscles tighten and clench as they become slightly more pronounced.");
					dynStats("str", temp / 10);
				}
			}
			//Increase player tou:
			if (changes < changeLimit && rand(3) === 0) {
				temp = 60 - player.tou;
				if (temp <= 0) temp = 0;
				else {
					if (rand(2) === 0) outputText("\n\nYou feel your insides toughening up; it feels like you could stand up to almost any blow.");
					else outputText("\n\nYour bones and joints feel sore for a moment, and before long you realize they've gotten more durable.");
					dynStats("tou", temp / 10);

				}
			}
			//Decrease player spd if it is over 30:
			if (changes < changeLimit && rand(3) === 0) {
				if (player.spe100 > 30) {
					outputText("\n\nThe body mass you've gained is making your movements more sluggish.");
					temp = (player.spe - 30) / 10;
					dynStats("spe", -temp);
				}
			}
			//Increase Corr, up to a max of 50.
			if (tainted) {
				temp = 50 - player.cor;
				if (temp < 0) temp = 0;
				dynStats("cor", temp / 10);
			}
			//Sex bits - Duderiffic
			if (player.cocks.length > 0 && rand(2) === 0 && !flags[kFLAGS.HYPER_HAPPY]) {
				//If the player has at least one dick, decrease the size of each slightly,
				outputText("\n\n");
				temp = 0;
				temp2 = player.cocks.length;
				temp3 = 0;
				//Find biggest cock
				while (temp2 > 0) {
					temp2--;
					if (player.cocks[temp].cockLength <= player.cocks[temp2].cockLength) temp = temp2;
				}
				//Shrink said cock
				if (player.cocks[temp].cockLength < 6 && player.cocks[temp].cockLength >= 2.9) {
					player.cocks[temp].cockLength -= .5;
					temp3 -= .5;
				}
				temp3 += player.increaseCock(temp, (rand(3) + 1) * -1);
				player.lengthChange(temp3, 1);
				if (player.cocks[temp].cockLength < 2) {
					outputText("  ");
					if (player.cockTotal() == 1 && !player.hasVagina()) {
						outputText("Your " + player.cockDescript(0) + " suddenly starts tingling.  It's a familiar feeling, similar to an orgasm.  However, this one seems to start from the top down, instead of gushing up from your loins.  You spend a few seconds frozen to the odd sensation, when it suddenly feels as though your own body starts sucking on the base of your shaft.  Almost instantly, your cock sinks into your crotch with a wet slurp.  The tip gets stuck on the front of your body on the way down, but your glans soon loses all volume to turn into a shiny new clit.");
						if (player.balls > 0) outputText("  At the same time, your " + player.ballsDescriptLight() + " fall victim to the same sensation; eagerly swallowed whole by your crotch.");
						outputText("  Curious, you touch around down there, to find you don't have any exterior organs left.  All of it got swallowed into the gash you now have running between two fleshy folds, like sensitive lips.  It suddenly occurs to you; <b>you now have a vagina!</b>");
						player.balls = 0;
						player.ballSize = 1;
						player.createVagina();
						player.setClitLength(.25);
						player.removeCock(0, 1);
					}
					else {
						player.killCocks(1);
					}
				}
				//if the last of the player's dicks are eliminated this way, they gain a virgin vagina;
				if (player.cocks.length == 0 && !player.hasVagina()) {
					player.createVagina();
					player.vaginas[0].vaginalLooseness = VaginaClass.LOOSENESS_TIGHT;
					player.vaginas[0].vaginalWetness = VaginaClass.WETNESS_NORMAL;
					player.vaginas[0].virgin = true;
					player.setClitLength(.25);
					outputText("\n\nAn itching starts in your crotch and spreads vertically.  You reach down and discover an opening.  You have grown a <b>new " + player.vaginaDescript(0) + "</b>!");

					changes++;
					dynStats("lus", 10);
				}
			}
			//Sex bits - girly
			var boobsGrew:Boolean = false;
			//Increase player's breast size, if they are HH or bigger
			//do not increase size, but do the other actions:
			if (((tainted && player.biggestTitSize() <= 11) || (!tainted && player.biggestTitSize() <= 5)) && changes < changeLimit && (rand(3) === 0 || enhanced)) {
				if (rand(2) === 0) outputText("\n\nYour " + player.breastDescript(0) + " tingle for a moment before becoming larger.");
				else outputText("\n\nYou feel a little weight added to your chest as your " + player.breastDescript(0) + " seem to inflate and settle in a larger size.");
				player.growTits(1 + rand(3), 1, false, 3);
				changes++;
				dynStats("sen", .5);
				boobsGrew = true;
			}
			//Remove feathery hair
			removeFeatheryHair();
			//If breasts are D or bigger and are not lactating, they also start lactating:
			if (player.biggestTitSize() >= 4 && player.breastRows[0].lactationMultiplier < 1 && changes < changeLimit && (rand(3) === 0 || boobsGrew || enhanced)) {
				outputText("\n\nYou gasp as your " + player.breastDescript(0) + " feel like they are filling up with something.  Within moments, a drop of milk leaks from your " + player.breastDescript(0) + "; <b> you are now lactating</b>.");
				player.breastRows[0].lactationMultiplier = 1.25;
				changes++;
				dynStats("sen", .5);
			}
			//Quad nipples and other 'special enhanced things.
			if (enhanced) {
				//QUAD DAMAGE!
				if (player.breastRows[0].nipplesPerBreast == 1) {
					changes++;
					player.breastRows[0].nipplesPerBreast = 4;
					outputText("\n\nYour " + player.nippleDescript(0) + "s tingle and itch.  You pull back your " + player.armorName + " and watch in shock as they split into four distinct nipples!  <b>You now have four nipples on each side of your chest!</b>");
					if (player.breastRows.length >= 2 && player.breastRows[1].nipplesPerBreast == 1) {
						outputText("A moment later your second row of " + player.breastDescript(1) + " does the same.  <b>You have sixteen nipples now!</b>");
						player.breastRows[1].nipplesPerBreast = 4;
					}
					if (player.breastRows.length >= 3 && player.breastRows[2].nipplesPerBreast == 1) {
						outputText("Finally, your ");
						if (player.bRows() == 3) outputText("third row of " + player.breastDescript(2) + " mutates along with its sisters, sprouting into a wonderland of nipples.");
						else if (player.bRows() >= 4) {
							outputText("everything from the third row down mutates, sprouting into a wonderland of nipples.");
							player.breastRows[3].nipplesPerBreast = 4;
							if (player.bRows() >= 5) player.breastRows[4].nipplesPerBreast = 4;
							if (player.bRows() >= 6) player.breastRows[5].nipplesPerBreast = 4;
							if (player.bRows() >= 7) player.breastRows[6].nipplesPerBreast = 4;
							if (player.bRows() >= 8) player.breastRows[7].nipplesPerBreast = 4;
							if (player.bRows() >= 9) player.breastRows[8].nipplesPerBreast = 4;
						}
						player.breastRows[2].nipplesPerBreast = 4;
						outputText("  <b>You have a total of " + num2Text(player.totalNipples()) + " nipples.</b>");
					}
				}
				//QUAD DAMAGE IF WEIRD SHIT BROKE BEFORE
				else if (player.breastRows.length > 1 && player.breastRows[1].nipplesPerBreast == 1) {
					if (player.breastRows[1].nipplesPerBreast == 1) {
						outputText("\n\nYour second row of " + player.breastDescript(1) + " tingle and itch.  You pull back your " + player.armorName + " and watch in shock as your " + player.nippleDescript(1) + " split into four distinct nipples!  <b>You now have four nipples on each breast in your second row of breasts</b>.");
						player.breastRows[1].nipplesPerBreast = 4;
					}
				}
				else if (player.breastRows.length > 2 && player.breastRows[2].nipplesPerBreast == 1) {
					if (player.breastRows[2].nipplesPerBreast == 1) {
						outputText("\n\nYour third row of " + player.breastDescript(2) + " tingle and itch.  You pull back your " + player.armorName + " and watch in shock as your " + player.nippleDescript(2) + " split into four distinct nipples!  <b>You now have four nipples on each breast in your third row of breasts</b>.");
						player.breastRows[2].nipplesPerBreast = 4;
					}
				}
				else if (player.breastRows.length > 3 && player.breastRows[3].nipplesPerBreast == 1) {
					if (player.breastRows[3].nipplesPerBreast == 1) {
						outputText("\n\nYour fourth row of " + player.breastDescript(3) + " tingle and itch.  You pull back your " + player.armorName + " and watch in shock as your " + player.nippleDescript(3) + " split into four distinct nipples!  <b>You now have four nipples on each breast in your fourth row of breasts</b>.");
						player.breastRows[3].nipplesPerBreast = 4;
					}
				}
				else if (player.biggestLactation() > 1) {
					if (rand(2) === 0) outputText("\n\nA wave of pleasure passes through your chest as your " + player.breastDescript(0) + " start leaking milk from a massive jump in production.");
					else outputText("\n\nSomething shifts inside your " + player.breastDescript(0) + " and they feel MUCH fuller and riper.  You know that you've started producing much more milk.");
					player.boostLactation(2.5);
					if ((player.nippleLength < 1.5 && tainted) || (!tainted && player.nippleLength < 1)) {
						outputText("  Your " + player.nippleDescript(0) + "s swell up, growing larger to accommodate your increased milk flow.");
						player.nippleLength += .25;
						dynStats("sen", .5);
					}
					changes++;
				}
			}
			//If breasts are already lactating and the player is not lactating beyond a reasonable level, they start lactating more:
			else {
				if (tainted && player.breastRows[0].lactationMultiplier > 1 && player.breastRows[0].lactationMultiplier < 5 && changes < changeLimit && (rand(3) === 0 || enhanced)) {
					if (rand(2) === 0) outputText("\n\nA wave of pleasure passes through your chest as your " + player.breastDescript(0) + " start producing more milk.");
					else outputText("\n\nSomething shifts inside your " + player.breastDescript(0) + " and they feel fuller and riper.  You know that you've started producing more milk.");
					player.boostLactation(0.75);
					if ((player.nippleLength < 1.5 && tainted) || (!tainted && player.nippleLength < 1)) {
						outputText("  Your " + player.nippleDescript(0) + "s swell up, growing larger to accommodate your increased milk flow.");
						player.nippleLength += .25;
						dynStats("sen", .5);
					}
					changes++;
				}
				if (!tainted) {
					if (player.breastRows[0].lactationMultiplier > 1 && player.breastRows[0].lactationMultiplier < 3.2 && changes < changeLimit && rand(3) === 0) {
						if (rand(2) === 0) outputText("\n\nA wave of pleasure passes through your chest as your " + player.breastDescript(0) + " start producing more milk.");
						else outputText("\n\nSomething shifts inside your " + player.breastDescript(0) + " and they feel fuller and riper.  You know that you've started producing more milk.");
						player.boostLactation(0.75);
						if ((player.nippleLength < 1.5 && tainted) || (!tainted && player.nippleLength < 1)) {
							outputText("  Your " + player.nippleDescript(0) + "s swell up, growing larger to accommodate your increased milk flow.");
							player.nippleLength += .25;
							dynStats("sen", .5);
						}
						changes++;
					}
					if ((player.breastRows[0].lactationMultiplier > 2 && player.hasStatusEffect(StatusEffects.Feeder)) || player.breastRows[0].lactationMultiplier > 5) {
						if (rand(2) === 0) outputText("\n\nYour breasts suddenly feel less full, it seems you aren't lactating at quite the level you were.");
						else outputText("\n\nThe insides of your breasts suddenly feel bloated.  There is a spray of milk from them, and they settle closer to a more natural level of lactation.");
						changes++;
						dynStats("sen", .5);
						player.boostLactation(-1);
					}
				}
			}
			//If breasts are lactating at a fair level
			//and the player has not received this status,
			//apply an effect where the player really wants
			//to give their milk to other creatures
			//(capable of getting them addicted):
			if (!player.hasStatusEffect(StatusEffects.Feeder) && player.biggestLactation() >= 3 && rand(2) === 0 && player.biggestTitSize() >= 5 && player.isCorruptEnough(35)) {
				outputText("\n\nYou start to feel a strange desire to give your milk to other creatures.  For some reason, you know it will be very satisfying.\n\n<b>(You have gained the 'Feeder' perk!)</b>");
				player.createStatusEffect(StatusEffects.Feeder, 0, 0, 0, 0);
				player.createPerk(PerkLib.Feeder, 0, 0, 0, 0);
				changes++;
			}
			//UNFINISHED
			//If player has addictive quality and drinks pure version, removes addictive quality.
			//if the player has a vagina and it is tight, it loosens.
			if (player.hasVagina()) {
				if (player.vaginas[0].vaginalLooseness < VaginaClass.LOOSENESS_LOOSE && changes < changeLimit && rand(2) === 0) {
					outputText("\n\nYou feel a relaxing sensation in your groin.  On further inspection you discover your " + player.vaginaDescript(0) + " has somehow relaxed, permanently loosening.");
					player.vaginas[0].vaginalLooseness++;
					player.vaginas[0].resetRecoveryProgress();
					player.vaginas[0].vaginalLooseness++;
					changes++;
					dynStats("lus", 10);
				}
			}
			//Neck restore
			if (player.neck.type !== Neck.NORMAL && changes < changeLimit && rand(4) === 0) restoreNeck(tfSource);
			//Rear body restore
			if (player.hasNonSharkRearBody() && changes < changeLimit && rand(5) === 0) restoreRearBody(tfSource);
			//Ovi perk loss
			if (tainted && rand(5) === 0) updateOvipositionPerk(tfSource);
			//General Appearance (Tail -> Ears -> Paws(fur stripper) -> Face -> Horns
			//Give the player a bovine tail, same as the minotaur
			if (tainted && player.tail.type !== Tail.COW && changes < changeLimit && rand(3) === 0) {
				if (player.tail.type == Tail.NONE) outputText("\n\nYou feel the flesh above your " + player.buttDescript() + " knotting and growing.  It twists and writhes around itself before flopping straight down, now shaped into a distinctly bovine form.  You have a <b>cow tail</b>.");
				else {
					if (player.tail.type < Tail.SPIDER_ABDOMEN || player.tail.type > Tail.BEE_ABDOMEN) {
						outputText("\n\nYour tail bunches uncomfortably, twisting and writhing around itself before flopping straight down, now shaped into a distinctly bovine form.  You have a <b>cow tail</b>.");
					}
					//insect
					if (player.tail.type == Tail.SPIDER_ABDOMEN || player.tail.type == Tail.BEE_ABDOMEN) {
						outputText("\n\nYour insect-like abdomen tingles pleasantly as it begins shrinking and softening, chitin morphing and reshaping until it looks exactly like a <b>cow tail</b>.");
					}
				}
				player.tail.type = Tail.COW;
				changes++;
			}
			//Give the player bovine ears, same as the minotaur
			if (tainted && player.ears.type !== Ears.COW && changes < changeLimit && rand(4) === 0 && player.tail.type == Tail.COW) {
				outputText("\n\nYou feel your ears tug on your scalp as they twist shape, becoming oblong and cow-like.  <b>You now have cow ears.</b>");
				player.ears.type = Ears.COW;
				changes++;
			}
			//If the player is under 7 feet in height, increase their height, similar to the minotaur
			if (((enhanced && player.tallness < 96) || player.tallness < 84) && changes < changeLimit && rand(2) === 0) {
				temp = rand(5) + 3;
				//Slow rate of growth near ceiling
				if (player.tallness > 74) temp = Math.floor(temp / 2);
				//Never 0
				if (temp == 0) temp = 1;
				//Flavor texts.  Flavored like 1950's cigarettes. Yum.
				if (temp < 5) outputText("\n\nYou shift uncomfortably as you realize you feel off balance.  Gazing down, you realize you have grown SLIGHTLY taller.");
				if (temp >= 5 && temp < 7) outputText("\n\nYou feel dizzy and slightly off, but quickly realize it's due to a sudden increase in height.");
				if (temp == 7) outputText("\n\nStaggering forwards, you clutch at your head dizzily.  You spend a moment getting your balance, and stand up, feeling noticeably taller.");
				player.tallness += temp;
				changes++;
			}
			//Give the player hoofs, if the player already has hoofs STRIP FUR
			if (tainted && player.lowerBody.type !== LowerBody.HOOFED && player.ears.type == Ears.COW) {
				if (changes < changeLimit && rand(3) === 0) {
					changes++;
					if (player.lowerBody.type == LowerBody.HUMAN) outputText("\n\nYou stagger as your feet change, curling up into painful angry lumps of flesh.  They get tighter and tighter, harder and harder, until at last they solidify into hooves!");
					else if (player.lowerBody.type == LowerBody.DOG) outputText("\n\nYou stagger as your paws change, curling up into painful angry lumps of flesh.  They get tighter and tighter, harder and harder, until at last they solidify into hooves!");
					else if (player.lowerBody.type == LowerBody.NAGA) outputText("\n\nYou collapse as your sinuous snake-tail tears in half, shifting into legs.  The pain is immense, particularly in your new feet as they curl inward and transform into hooves!");
					//Catch-all
					else if (player.lowerBody.type > LowerBody.NAGA) outputText("\n\nYou stagger as your " + player.feet() + " change, curling up into painful angry lumps of flesh.  They get tighter and tighter, harder and harder, until at last they solidify into hooves!");
					outputText("  A coat of beastial fur springs up below your waist, itching as it fills in.<b>  You now have hooves in place of your feet!</b>");
					player.lowerBody.type = LowerBody.HOOFED;
					player.lowerBody.legCount = 2;
					dynStats("cor", 0);
					changes++;
				}
			}
			//If the player's face is non-human, they gain a human face
			if (!enhanced && player.lowerBody.type == LowerBody.HOOFED && player.face.type !== Face.HUMAN && changes < changeLimit && rand(4) === 0) {
				//Remove face before fur!
				outputText("\n\nYour visage twists painfully, returning to a normal human shape.  <b>Your face is human again!</b>");
				player.face.type = Face.HUMAN;
				changes++;
			}
			//enhanced get shitty fur
			if (enhanced && (player.skin.desc !== "fur" || player.skin.furColor !== "black and white spotted")) {
				if (player.skin.desc !== "fur") outputText("\n\nYour " + player.skin.desc + " itches intensely.  You scratch and scratch, but it doesn't bring any relief.  Fur erupts between your fingers, and you watch open-mouthed as it fills in over your whole body.  The fur is patterned in black and white, like that of a cow.  The color of it even spreads to your hair!  <b>You have cow fur!</b>");
				else outputText("\n\nA ripple spreads through your fur as some patches darken and others lighten.  After a few moments you're left with a black and white spotted pattern that goes the whole way up to the hair on your head!  <b>You've got cow fur!</b>");
				player.skin.desc = "fur";
				player.skin.adj = "";
				player.skin.type = Skin.FUR;
				player.hair.color = "black and white spotted";
				player.skin.furColor = player.hair.color;
				player.underBody.restore(); // Restore the underbody for now
			}
			//if enhanced to probova give a shitty cow face
			else if (enhanced && player.face.type !== Face.COW_MINOTAUR) {
				outputText("\n\nYour visage twists painfully, warping and crackling as your bones are molded into a new shape.  Once it finishes, you reach up to touch it, and you discover that <b>your face is like that of a cow!</b>");
				player.face.type = Face.COW_MINOTAUR;
				changes++;
			}
			//Give the player bovine horns, or increase their size, same as the minotaur
			//New horns or expanding mino horns
			if (tainted && changes < changeLimit && rand(3) === 0 && player.face.type == Face.HUMAN) {
				//Get bigger or change horns
				if (player.horns.type == Horns.COW_MINOTAUR || player.horns.type == Horns.NONE) {
					//Get bigger if player has horns
					if (player.horns.type == Horns.COW_MINOTAUR) {
						if (player.horns.value < 5) {
							//Fems horns don't get bigger.
							outputText("\n\nYour small horns get a bit bigger, stopping as medium sized nubs.");
							player.horns.value += 1 + rand(2);
							changes++;
						}
					}
					//If no horns yet..
					if (player.horns.type == Horns.NONE || player.horns.value == 0) {
						outputText("\n\nWith painful pressure, the skin on your forehead splits around two tiny nub-like horns, similar to those you would see on the cattle back in your homeland.");
						player.horns.type = Horns.COW_MINOTAUR;
						player.horns.value = 1;
						changes++;
					}
					//TF other horns
					if (player.horns.type !== Horns.NONE && player.horns.type !== Horns.COW_MINOTAUR && player.horns.value > 0) {
						outputText("\n\nYour horns twist, filling your skull with agonizing pain for a moment as they transform into cow-horns.");
						player.horns.type = Horns.COW_MINOTAUR;
					}
				}
				//Not mino horns, change to cow-horns
				if (player.horns.type == Horns.DEMON || player.horns.type > Horns.COW_MINOTAUR) {
					outputText("\n\nYour horns vibrate and shift as if made of clay, reforming into two small bovine nubs.");
					player.horns.type = Horns.COW_MINOTAUR;
					player.horns.value = 2;
					changes++;
				}
			}
			//Increase the size of the player's hips, if they are not already childbearing or larger
			if (rand(2) === 0 && player.hips.rating < 15 && changes < changeLimit) {
				if (!tainted && player.hips.rating < 8 || tainted) {
					outputText("\n\nYou stumble as you feel the bones in your hips grinding, expanding your hips noticeably.");
					player.hips.rating += 1 + rand(4);
					changes++;
				}
			}
			// Remove gills
			if (rand(4) === 0 && player.hasGills() && changes < changeLimit) updateGills();

			//Increase the size of the player's ass (less likely then hips), if it is not already somewhat big
			if (rand(2) === 0 && player.butt.rating < 13 && changes < changeLimit) {
				if (!tainted && player.butt.rating < 8 || tainted) {
					outputText("\n\nA sensation of being unbalanced makes it difficult to walk.  You pause, paying careful attention to your new center of gravity before understanding dawns on you - your ass has grown!");
					player.butt.rating += 1 + rand(2);
					changes++;
				}
			}
			//Nipples Turn Back:
			if (player.hasStatusEffect(StatusEffects.BlackNipples) && changes < changeLimit && rand(3) === 0) {
				removeBlackNipples(tfSource);
			}
			//Debugcunt
			if (changes < changeLimit && rand(3) === 0 && player.vaginaType() == 5 && player.hasVagina()) {
				outputText("\n\nSomething invisible brushes against your sex, making you twinge.  Undoing your clothes, you take a look at your vagina and find that it has turned back to its natural flesh colour.");
				player.vaginaType(0);
				changes++;
			}
			if (rand(3) === 0) outputText(player.modFem(79, 3));
			if (rand(3) === 0) outputText(player.modThickness(70, 4));
			if (rand(5) === 0) outputText(player.modTone(10, 5));
			player.refillHunger(20);
			flags[kFLAGS.TIMES_TRANSFORMED] += changes;
		}

		public function lustDraft(fuck:Boolean,player:Player):void
		{
			player.slimeFeed();
			clearOutput();
			outputText("You drink the ");
			if (fuck) outputText("red");
			else outputText("pink");
			outputText(" potion, and its unnatural warmth immediately flows to your groin.");
			dynStats("lus", (30 + rand(player.lib / 10)), "scale", false);

			//Heat/Rut for those that can have them if "fuck draft"
			if (fuck) {
				//Try to go into intense heat.
				player.goIntoHeat(true, 2);
				//Males go into rut
				player.goIntoRut(true);
			}
			//ORGAZMO
			if (player.lust >= player.maxLust() && !kGAMECLASS.inCombat) {
				outputText("\n\nThe arousal from the potion overwhelms your senses and causes you to spontaneously orgasm.  You rip off your " + player.armorName + " and look down as your ");
				if (player.cocks.length > 0) {
					outputText(player.multiCockDescriptLight() + " erupts in front of you, liberally spraying the ground around you.  ");
				}
				if (player.cocks.length > 0 && player.vaginas.length > 0) {
					outputText("At the same time your ");
				}
				if (player.vaginas.length > 0) {
					outputText(player.vaginaDescript(0) + " soaks your thighs.  ");
				}
				if (player.gender == 0) outputText("body begins to quiver with orgasmic bliss.  ");
				outputText("Once you've had a chance to calm down, you notice that the explosion of pleasure you just experienced has rocked you to your core.  You are a little hornier than you were before.");
				//increase player libido, and maybe sensitivity too?
				player.orgasm('Generic');
				dynStats("lib", 2, "sen", 1);
			}
			if (player.lust > player.maxLust()) player.lust = player.maxLust();
			outputText("\n\n");
			player.refillHunger(5);
		}

		public function neonPinkEgg(pregnantChange:Boolean,player:Player):void
		{
			var tfSource:String = "neonPinkEgg";
			initTransformation([2, 2]);
			//If this is a pregnancy change, only 1 change per proc.
			if (pregnantChange) changeLimit = 1;
			else clearOutput();
			//If not pregnancy, mention eating it.
			if (!pregnantChange) outputText("You eat the neon pink egg, and to your delight it tastes sweet, like candy.  In seconds you've gobbled down the entire thing, and you lick your fingers clean before you realize you ate the shell – and it still tasted like candy.");
			//If pregnancy, warning!
			if (pregnantChange) {
				outputText("\n<b>Your egg-stuffed ");
				if (player.pregnancyType == PregnancyStore.PREGNANCY_BUNNY) {
					outputText("womb ");
					if (player.buttPregnancyType == PregnancyStore.PREGNANCY_BUNNY) outputText("and ");
				}
				if (player.buttPregnancyType == PregnancyStore.PREGNANCY_BUNNY) outputText("backdoor ");
				if (player.buttPregnancyType == PregnancyStore.PREGNANCY_BUNNY && player.pregnancyType == PregnancyStore.PREGNANCY_BUNNY) outputText("rumble");
				else outputText("rumbles");
				outputText(" oddly, and you have a hunch that something's about to change</b>.");
			}
			//STATS CHANGURYUUUUU
			//Boost speed (max 80!)
			if (changes < changeLimit && rand(3) === 0 && player.spe100 < 80) {
				if (player.spe100 < 30) outputText("\n\nTingles run through your muscles, and your next few movements seem unexpectedly fast.  The egg somehow made you faster!");
				else if (player.spe100 < 50) outputText("\n\nYou feel tingles running through your body, and after a moment, it's clear that you're getting faster.");
				else if (player.spe100 < 65) outputText("\n\nThe tight, ready feeling you've grown accustomed to seems to intensify, and you know in the back of your mind that you've become even faster.");
				else outputText("\n\nSomething changes in your physique, and you grunt, chopping an arm through the air experimentally.  You seem to move even faster than before, confirming your suspicions.");
				if (player.spe100 < 35) dynStats("spe", 1);
				dynStats("spe", 1);
			}
			//Boost libido
			if (changes < changeLimit && rand(5) === 0) {
				dynStats("lib", 1, "lus", (5 + player.lib / 7));
				if (player.lib100 < 30) dynStats("lib", 1);
				if (player.lib100 < 40) dynStats("lib", 1);
				if (player.lib100 < 60) dynStats("lib", 1);
				//Lower ones are gender specific for some reason
				if (player.lib100 < 60) {
					//(Cunts or assholes!
					if (!player.hasCock() || (player.gender == 3 && rand(2) === 0)) {
						if (player.lib100 < 30) {
							outputText("\n\nYou squirm a little and find your eyes glancing down to your groin.  Strange thoughts jump to mind, wondering how it would feel to breed until you're swollen and pregnant.  ");
							if (player.cor < 25) outputText("You're repulsed by such shameful thoughts.");
							else if (player.cor < 60) outputText("You worry that this place is really getting to you.");
							else if (player.cor < 90) outputText("You pant a little and wonder where the nearest fertile male is.");
							else outputText("You grunt and groan with desire and disappointment.  You should get bred soon!");
						}
						else outputText("\n\nYour mouth rolls open as you start to pant with desire.  Did it get hotter?  Your hand reaches down to your " + player.assholeOrPussy() + ", and you're struck by just how empty it feels.  The desire to be filled, not by a hand or a finger but by a virile male, rolls through you like a wave, steadily increasing your desire for sex.");
					}
					//WANGS!
					if (player.hasCock()) {
						if (player.lib100 < 30) {
							outputText("\n\nYou squirm a little and find your eyes glancing down to your groin.  Strange thoughts jump to mind, wondering how it would feel to fuck a ");
							if (rand(2) === 0) outputText("female hare until she's immobilized by all her eggs");
							else outputText("herm rabbit until her sack is so swollen that she's forced to masturbate over and over again just to regain mobility");
							outputText(". ");
							if (player.cor < 25) outputText("You're repulsed by such shameful thoughts.");
							else if (player.cor < 50) outputText("You worry that this place is really getting to you.");
							else if (player.cor < 75) outputText("You pant a little and wonder where the nearest fertile female is.");
							else outputText("You grunt and groan with desire and disappointment.  Gods you need to fuck!");
						}
						else outputText("\n\nYour mouth rolls open as you start to pant with desire.  Did it get hotter?  Your hand reaches down to " + player.sMultiCockDesc() + ", and you groan from how tight and hard it feels.  The desire to squeeze it, not with your hand but with a tight pussy or puckered asshole, runs through you like a wave, steadily increasing your desire for sex.");
					}
				}
				//Libido over 60? FUCK YEAH!
				else if (player.lib100 < 80) {
					outputText("\n\nYou fan your neck and start to pant as your " + player.skin.tone + " skin begins to flush red with heat");
					if (!player.hasPlainSkin()) outputText(" through your " + player.skin.desc);
					outputText(".  ");
					if (player.gender == 1) outputText("Compression tightens down on " + player.sMultiCockDesc() + " as it strains against your " + player.armorName + ".  You struggle to fight down your heightened libido, but it's hard – so very hard.");
					else if (player.gender == 0) outputText("Sexual hunger seems to gnaw at your " + player.assholeDescript() + ", demanding it be filled, but you try to resist your heightened libido.  It's so very, very hard.");
					else if (player.gender == 2) outputText("Moisture grows between your rapidly-engorging vulva, making you squish and squirm as you try to fight down your heightened libido, but it's hard – so very hard.");
					else outputText("Steamy moisture and tight compression war for your awareness in your groin as " + player.sMultiCockDesc() + " starts to strain against your " + player.armorName + ".  Your vulva engorges with blood, growing slicker and wetter.  You try so hard to fight down your heightened libido, but it's so very, very hard.  The urge to breed lingers in your mind, threatening to rear its ugly head.");
				}
				//MEGALIBIDO
				else {
					outputText("\n\nDelicious, unquenchable desire rises higher and higher inside you, until you're having trouble tamping it down all the time.  A little, nagging voice questions why you would ever want to tamp it down.  It feels so good to give in and breed that you nearly cave to the delicious idea on the spot.  Life is beginning to look increasingly like constant fucking or masturbating in a lust-induced haze, and you're having a harder and harder time finding fault with it.  ");
					if (player.cor < 33) outputText("You sigh, trying not to give in completely.");
					else if (player.cor < 66) outputText("You pant and groan, not sure how long you'll even want to resist.");
					else {
						outputText("You smile and wonder if you can ");
						if (player.lib100 < 100) outputText("get your libido even higher.");
						else outputText("find someone to fuck right now.");
					}
				}
			}
			//BIG sensitivity gains to 60.
			if (player.sens100 < 60 && changes < changeLimit && rand(3) === 0) {
				outputText("\n\n");
				//(low)
				if (rand(3) !== 2) {
					outputText("The feeling of small breezes blowing over your " + player.skin.desc + " gets a little bit stronger.  How strange.  You pinch yourself and nearly jump when it hurts a tad more than you'd think. You've gotten more sensitive!");
					dynStats("sen", 5);
				}
				//(BIG boost 1/3 chance)
				else {
					dynStats("sen", 15);
					outputText("Every movement of your body seems to bring heightened waves of sensation that make you woozy.  Your " + player.armorName + " rubs your " + player.nippleDescript(0) + "s deliciously");
					if (player.hasFuckableNipples()) {
						outputText(", sticking to the ");
						if (player.biggestLactation() > 2) outputText("milk-leaking nipple-twats");
						else outputText("slippery nipple-twats");
					}
					else if (player.biggestLactation() > 2) outputText(", sliding over the milk-leaking teats with ease");
					else outputText(" catching on each of the hard nubs repeatedly");
					outputText(".  Meanwhile, your crotch... your crotch is filled with such heavenly sensations from ");
					if (player.gender == 1) {
						outputText(player.sMultiCockDesc() + " and your ");
						if (player.balls > 0) outputText(player.ballsDescriptLight());
						else outputText(player.assholeDescript());
					}
					else if (player.gender == 2) outputText("your " + player.vaginaDescript(0) + " and " + player.clitDescript());
					else if (player.gender == 3) {
						outputText(player.sMultiCockDesc() + ", ");
						if (player.balls > 0) outputText(player.ballsDescriptLight() + ", ");
						outputText(player.vaginaDescript(0) + ", and " + player.clitDescript());
					}
					//oh god genderless
					else outputText("you " + player.assholeDescript());
					outputText(" that you have to stay stock-still to keep yourself from falling down and masturbating on the spot.  Thankfully the orgy of tactile bliss fades after a minute, but you still feel way more sensitive than your previous norm.  This will take some getting used to!");
				}
			}
			//Makes girls very girl(90), guys somewhat girly (61).
			if (changes < changeLimit && rand(2) === 0) {
				var buffer:String = "";
				if (player.gender < 2) buffer += player.modFem(61, 4);
				else buffer += player.modFem(90, 4);
				if (buffer !== "") {
					outputText(buffer);
					changes++;
				}
			}

			//De-wettification of cunt (down to 3?)!
			if (player.wetness() > 3 && changes < changeLimit && rand(3) === 0) {
				//Just to be safe
				if (player.hasVagina()) {
					outputText("\n\nThe constant flow of fluids that sluice from your " + player.vaginaDescript(0) + " slow down, leaving you feeling a bit less like a sexual slip-'n-slide.");
					player.vaginas[0].vaginalWetness--;
					changes++;
				}
			}
			//Fertility boost!
			if (changes < changeLimit && rand(4) === 0 && player.fertility < 50 && player.hasVagina()) {
				player.fertility += 2 + rand(5);
				changes++;
				outputText("\n\nYou feel strange.  Fertile... somehow.  You don't know how else to think of it, but you know your body is just aching to be pregnant and give birth.");
			}
			//-VAGs
			//Neck restore
			if (player.neck.type !== Neck.NORMAL && changes < changeLimit && rand(4) === 0) restoreNeck(tfSource);
			//Rear body restore
			if (player.hasNonSharkRearBody() && changes < changeLimit && rand(5) === 0) restoreRearBody(tfSource);
			//Ovi perk loss
			if (rand(4) === 0) updateOvipositionPerk(tfSource);
			if (player.hasVagina() && player.findPerk(PerkLib.BunnyEggs) < 0 && changes < changeLimit && rand(4) === 0 && player.bunnyScore() > 3) {
				outputText("\n\nDeep inside yourself there is a change.  It makes you feel a little woozy, but passes quickly.  Beyond that, you aren't sure exactly what just happened, but you are sure it originated from your womb.\n\n");
				outputText("(<b>Perk Gained: Bunny Eggs</b>)");
				player.createPerk(PerkLib.BunnyEggs, 0, 0, 0, 0);
				changes++;
			}
			//Shrink Balls!
			if (player.balls > 0 && player.ballSize > 5 && rand(3) === 0 && changes < changeLimit) {
				if (player.ballSize < 10) {
					outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose about an inch of their diameter.");
					player.ballSize--;
				}
				else if (player.ballSize < 25) {
					outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose a few inches of their diameter.  Wow, it feels so much easier to move!");
					player.ballSize -= (2 + rand(3));
				}
				else {
					outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose at least six inches of diameter.  Wow, it feels SOOOO much easier to move!");
					player.ballSize -= (6 + rand(3));
				}
				changes++;
			}
			//Get rid of extra balls
			if (player.balls > 2 && changes < changeLimit && rand(3) === 0) {
				changes++;
				outputText("\n\nThere's a tightening in your " + player.sackDescript() + " that only gets higher and higher until you're doubled over and wheezing.  When it passes, you reach down and discover that <b>two of your testicles are gone.</b>");
				player.balls -= 2;
			}
			//Boost cum production
			if ((player.balls > 0 || player.hasCock()) && player.cumQ() < 3000 && rand(3) === 0 && changeLimit > 1) {
				changes++;
				player.cumMultiplier += 3 + rand(7);
				if (player.cumQ() >= 250) dynStats("lus", 3);
				if (player.cumQ() >= 750) dynStats("lus", 4);
				if (player.cumQ() >= 2000) dynStats("lus", 5);
				//Balls
				if (player.balls > 0) {
					//(Small cum quantity) < 50
					if (player.cumQ() < 50) outputText("\n\nA twinge of discomfort runs through your " + player.ballsDescriptLight() + ", but quickly vanishes.  You heft your orbs but they haven't changed in size – they just feel a little bit denser.");
					//(medium cum quantity) < 250
					else if (player.cumQ() < 250) {
						outputText("\n\nA ripple of discomfort runs through your " + player.ballsDescriptLight() + ", but it fades into a pleasant tingling.  You reach down to heft the orbs experimentally but they don't seem any larger.");
						if (player.hasCock()) outputText("  In the process, you brush " + player.sMultiCockDesc() + " and discover a bead of pre leaking at the tip.");
					}
					//(large cum quantity) < 750
					else if (player.cumQ() < 750) {
						outputText("\n\nA strong contraction passes through your " + player.sackDescript() + ", almost painful in its intensity.  ");
						if (player.hasCock()) outputText(player.sMultiCockDesc() + " leaks and dribbles pre-cum down your " + player.legs() + " as your body's cum production kicks up even higher.");
						else outputText("You wince, feeling pent up and yet unable to release.  You really wish you had a cock right about now.");
					}
					//(XL cum quantity) < 2000
					else if (player.cumQ() < 2000) {
						outputText("\n\nAn orgasmic contraction wracks your " + player.ballsDescriptLight() + ", shivering through the potent orbs and passing as quickly as it came.  ");
						if (player.hasCock()) outputText("A thick trail of slime leaks from " + player.sMultiCockDesc() + " down your " + player.leg() + ", pooling below you.");
						else outputText("You grunt, feeling terribly pent-up and needing to release.  Maybe you should get a penis to go with these balls...");
						outputText("  It's quite obvious that your cum production has gone up again.");
					}
					//(XXL cum quantity)
					else {
						outputText("\n\nA body-wrenching contraction thrums through your " + player.ballsDescriptLight() + ", bringing with it the orgasmic feeling of your body kicking into cum-production overdrive.  ");
						if (player.hasCock()) outputText("pre-cum explodes from " + player.sMultiCockDesc() + ", running down your " + player.leg() + " and splattering into puddles that would shame the orgasms of lesser " + player.mf("males", "persons") + ".  You rub yourself a few times, nearly starting to masturbate on the spot, but you control yourself and refrain for now.");
						else outputText("You pant and groan but the pleasure just turns to pain.  You're so backed up – if only you had some way to vent all your seed!");
					}
				}
				//NO BALLZ (guaranteed cock tho)
				else {
					//(Small cum quantity) < 50
					if (player.cumQ() < 50) outputText("\n\nA twinge of discomfort runs through your body, but passes before you have any chance to figure out exactly what it did.");
					//(Medium cum quantity) < 250)
					else if (player.cumQ() < 250) outputText("\n\nA ripple of discomfort runs through your body, but it fades into a pleasant tingling that rushes down to " + player.sMultiCockDesc() + ".  You reach down to heft yourself experimentally and smile when you see pre-beading from your maleness.  Your cum production has increased!");
					//(large cum quantity) < 750
					else if (player.cumQ() < 750) outputText("\n\nA strong contraction passes through your body, almost painful in its intensity.  " + player.SMultiCockDesc() + " leaks and dribbles pre-cum down your " + player.legs() + " as your body's cum production kicks up even higher!  Wow, it feels kind of... good.");
					//(XL cum quantity) < 2000
					else if (player.cumQ() < 2000) outputText("\n\nAn orgasmic contraction wracks your abdomen, shivering through your midsection and down towards your groin.  A thick trail of slime leaks from " + player.sMultiCockDesc() + "  and trails down your " + player.leg() + ", pooling below you.  It's quite obvious that your body is producing even more cum now.");
					//(XXL cum quantity)
					else outputText("\n\nA body-wrenching contraction thrums through your gut, bringing with it the orgasmic feeling of your body kicking into cum-production overdrive.  pre-cum explodes from " + player.sMultiCockDesc() + ", running down your " + player.legs() + " and splattering into puddles that would shame the orgasms of lesser " + player.mf("males", "persons") + ".  You rub yourself a few times, nearly starting to masturbate on the spot, but you control yourself and refrain for now.");
				}
			}
			//Bunny feet! - requirez earz
			if (player.lowerBody.type !== LowerBody.BUNNY && changes < changeLimit && rand(5) === 0 && player.ears.type == Ears.BUNNY) {
				//Taurs
				if (player.isTaur()) outputText("\n\nYour quadrupedal hind-quarters seizes, overbalancing your surprised front-end and causing you to stagger and fall to your side.  Pain lances throughout, contorting your body into a tightly clenched ball of pain while tendons melt and bones break, melt, and regrow.  When it finally stops, <b>you look down to behold your new pair of fur-covered rabbit feet</b>!");
				//Non-taurs
				else {
					outputText("\n\nNumbness envelops your " + player.legs() + " as they pull tighter and tighter.  You overbalance and drop on your " + player.assDescript());
					if (player.tail.type > Tail.NONE) outputText(", nearly smashing your tail flat");
					else outputText(" hard enough to sting");
					outputText(" while the change works its way through you.  Once it finishes, <b>you discover that you now have fuzzy bunny feet and legs</b>!");
				}
				changes++;
				player.lowerBody.type = LowerBody.BUNNY;
				player.lowerBody.legCount = 2;
			}
			//BUN FACE!  REQUIREZ EARZ
			if (player.ears.type == Ears.BUNNY && player.face.type !== Face.BUNNY && rand(3) === 0 && changes < changeLimit) {
				outputText("\n\n");
				changes++;
				//Human(ish) face
				if (player.face.type == Face.HUMAN || player.face.type == Face.SHARK_TEETH) outputText("You catch your nose twitching on its own at the bottom of your vision, but as soon as you focus on it, it stops.  A moment later, some of your teeth tingle and brush past your lips, exposing a white pair of buckteeth!  <b>Your face has taken on some rabbit-like characteristics!</b>");
				//Crazy furry TF shit
				else outputText("You grunt as your " + player.faceDescript() + " twists and reforms.  Even your teeth ache as their positions are rearranged to match some new, undetermined order.  When the process finishes, <b>you're left with a perfectly human looking face, save for your constantly twitching nose and prominent buck-teeth.</b>");
				player.face.type = Face.BUNNY;
			}
			//DAH BUNBUN EARZ - requires poofbutt!
			if (player.ears.type !== Ears.BUNNY && changes < changeLimit && rand(3) === 0 && player.tail.type == Tail.RABBIT) {
				outputText("\n\nYour ears twitch and curl in on themselves, sliding around on the flesh of your head.  They grow warmer and warmer before they finally settle on the top of your head and unfurl into long, fluffy bunny-ears.  <b>You now have a pair of bunny ears.</b>");
				player.ears.type = Ears.BUNNY;
				changes++;
			}
			//DAH BUNBUNTAILZ
			if (player.tail.type !== Tail.RABBIT && rand(2) === 0 && changes < changeLimit) {
				if (player.tail.type > Tail.NONE) outputText("\n\nYour tail burns as it shrinks, pulling tighter and tighter to your backside until it's the barest hint of a stub.  At once, white, poofy fur explodes out from it.  <b>You've got a white bunny-tail!  It even twitches when you aren't thinking about it.</b>");
				else outputText("\n\nA burning pressure builds at your spine before dissipating in a rush of relief. You reach back and discover a small, fleshy tail that's rapidly growing long, poofy fur.  <b>You have a rabbit tail!</b>");
				player.tail.type = Tail.RABBIT;
				changes++;
			}
			// Remove gills
			if (rand(4) === 0 && player.hasGills() && changes < changeLimit) updateGills();
			//Bunny Breeder Perk?
			//FAILSAAAAFE
			if (changes == 0) {
				if (player.lib100 < 100) changes++;
				dynStats("lib", 1, "lus", (5 + player.lib / 7));
				if (player.lib100 < 30) dynStats("lib", 1);
				if (player.lib100 < 40) dynStats("lib", 1);
				if (player.lib100 < 60) dynStats("lib", 1);
				//Lower ones are gender specific for some reason
				if (player.lib100 < 60) {
					//(Cunts or assholes!
					if (!player.hasCock() || (player.gender == 3 && rand(2) === 0)) {
						if (player.lib100 < 30) {
							outputText("\n\nYou squirm a little and find your eyes glancing down to your groin.  Strange thoughts jump to mind, wondering how it would feel to breed until you're swollen and pregnant.  ");
							if (player.cor < 25) outputText("You're repulsed by such shameful thoughts.");
							else if (player.cor < 60) outputText("You worry that this place is really getting to you.");
							else if (player.cor < 90) outputText("You pant a little and wonder where the nearest fertile male is.");
							else outputText("You grunt and groan with desire and disappointment.  You should get bred soon!");
						}
						else outputText("\n\nYour mouth rolls open as you start to pant with desire.  Did it get hotter?  Your hand reaches down to your " + player.assholeOrPussy() + ", and you're struck by just how empty it feels.  The desire to be filled, not by a hand or a finger but by a virile male, rolls through you like a wave, steadily increasing your desire for sex.");
					}
					//WANGS!
					if (player.hasCock()) {
						if (player.lib100 < 30) {
							outputText("\n\nYou squirm a little and find your eyes glancing down to your groin.  Strange thoughts jump to mind, wondering how it would feel to fuck a ");
							if (rand(2) === 0) outputText("female hare until she's immobilized by all her eggs");
							else outputText("herm rabbit until her sack is so swollen that she's forced to masturbate over and over again just to regain mobility");
							outputText(". ");
							if (player.cor < 25) outputText("You're repulsed by such shameful thoughts.");
							else if (player.cor < 50) outputText("You worry that this place is really getting to you.");
							else if (player.cor < 75) outputText("You pant a little and wonder where the nearest fertile female is.");
							else outputText("You grunt and groan with desire and disappointment.  Gods you need to fuck!");
						}
						else outputText("\n\nYour mouth rolls open as you start to pant with desire.  Did it get hotter?  Your hand reaches down to " + player.sMultiCockDesc() + ", and you groan from how tight and hard it feels.  The desire to have it squeezed, not with your hand but with a tight pussy or puckered asshole, runs through you like a wave, steadily increasing your desire for sex.");
					}
				}
				//Libido over 60? FUCK YEAH!
				else if (player.lib100 < 80) {
					outputText("\n\nYou fan your neck and start to pant as your " + player.skin.tone + " skin begins to flush red with heat");
					if (!player.hasPlainSkin()) outputText(" through your " + player.skin.desc);
					outputText(".  ");
					if (player.gender == 1) outputText("Compression tightens down on " + player.sMultiCockDesc() + " as it strains against your " + player.armorName + ".  You struggle to fight down your heightened libido, but it's hard – so very hard.");
					else if (player.gender == 0) outputText("Sexual hunger seems to gnaw at your " + player.assholeDescript() + ", demanding it be filled, but you try to resist your heightened libido.  It's so very, very hard.");
					else if (player.gender == 2) outputText("Moisture grows between your rapidly-engorging vulva, making you squish and squirm as you try to fight down your heightened libido, but it's hard – so very hard.");
					else outputText("Steamy moisture and tight compression war for your awareness in your groin as " + player.sMultiCockDesc() + " starts to strain against your " + player.armorName + ".  Your vulva engorges with blood, growing slicker and wetter.  You try so hard to fight down your heightened libido, but it's so very, very hard.  The urge to breed lingers in your mind, threatening to rear its ugly head.");
				}
				//MEGALIBIDO
				else {
					outputText("\n\nDelicious, unquenchable desire rises higher and higher inside you, until you're having trouble tamping it down all the time.  A little, nagging voice questions why you would ever want to tamp it down.  It feels so good to give in and breed that you nearly cave to the delicious idea on the spot.  Life is beginning to look increasingly like constant fucking or masturbating in a lust-induced haze, and you're having a harder and harder time finding fault with it.  ");
					if (player.cor < 33) outputText("You sigh, trying not to give in completely.");
					else if (player.cor < 66) outputText("You pant and groan, not sure how long you'll even want to resist.");
					else {
						outputText("You smile and wonder if you can ");
						if (player.lib100 < 100) outputText("get your libido even higher.");
						else outputText("find someone to fuck right now.");
					}
				}
			}
			player.refillHunger(20);
			flags[kFLAGS.TIMES_TRANSFORMED] += changes;
		}

//Miscellaneous
//ITEM GAINED FROM LUST WINS
//bottle of ectoplasm. Regular stat-stuff include higher speed, (reduced libido?), reduced sensitivity, and higher intelligence. First-tier effects include 50/50 chance of sable skin with bone-white veins or ivory skin with onyx veins. Second tier, \"wisp-like legs that flit back and forth between worlds,\" or \"wisp-like legs\" for short. Third tier gives an \"Ephemeral\" perk, makes you (10%, perhaps?) tougher to hit, and gives you a skill that replaces tease/seduce—allowing the PC to possess the creature and force it to masturbate to gain lust. Around the same effectiveness as seduce.
//Mouseover script: \"The green-tinted, hardly corporeal substance flows like a liquid inside its container. It makes you feel...uncomfortable, as you observe it.\"

		public function foxJewel(mystic:Boolean,player:Player):void
		{
			var tfSource:String = "foxJewel";
			if (mystic) tfSource += "-mystic";
			initTransformation([2, 2, 3], mystic ? 3 : 1);
			clearOutput();
			if (mystic) outputText("You examine the jewel for a bit, rolling it around in your hand as you ponder its mysteries.  You hold it up to the light with fascinated curiosity, watching the eerie purple flame dancing within.  Without warning, the gem splits down the center, dissolving into nothing in your hand.  As the pale lavender flames swirl around you, the air is filled with a sickly sweet scent that drips with the bitter aroma of licorice, filling you with a dire warmth.");
			else outputText("You examine the jewel for a bit, rolling it around in your hand as you ponder its mysteries.  You hold it up to the light with fascinated curiosity, watching the eerie blue flame dancing within.  Without warning, the gem splits down the center, dissolving into nothing in your hand.  As the pale azure flames swirl around you, the air is filled with a sweet scent that drips with the aroma of wintergreen, sending chills down your spine.");

			//**********************
			//BASIC STATS
			//**********************
			//[increase Intelligence, Libido and Sensitivity]
			if (player.inte100 < 100 && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(4) === 0))) {
				outputText("\n\nYou close your eyes, smirking to yourself mischievously as you suddenly think of several new tricks to try on your opponents; you feel quite a bit more cunning.  The mental image of them helpless before your cleverness makes you shudder a bit, and you lick your lips and stroke yourself as you feel your skin tingling from an involuntary arousal.");
				//Raise INT, Lib, Sens. and +10 LUST
				dynStats("int", 2, "lib", 1, "sen", 2, "lus", 10);
			}
			//[decrease Strength toward 15]
			if (player.str100 > 15 && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0))) {
				outputText("\n\nYou can feel your muscles softening as they slowly relax, becoming a tad weaker than before.  Who needs physical strength when you can outwit your foes with trickery and mischief?  You tilt your head a bit, wondering where that thought came from.");
				dynStats("str", -1);
				if (player.str100 > 70) dynStats("str", -1);
				if (player.str100 > 50) dynStats("str", -1);
				if (player.str100 > 30) dynStats("str", -1);
			}
			//[decrease Toughness toward 20]
			if (player.tou100 > 20 && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0))) {
				//from 66 or less toughness
				if (player.tou100 <= 66) outputText("\n\nYou feel your " + player.skinFurScales() + " becoming noticeably softer.  A gentle exploratory pinch on your arm confirms it - your " + player.skinFurScales() + " won't offer you much protection.");
				//from 66 or greater toughness
				else outputText("\n\nYou feel your " + player.skinFurScales() + " becoming noticeably softer.  A gentle exploratory pinch on your arm confirms it - your hide isn't quite as tough as it used to be.");
				dynStats("tou", -1);
				if (player.tou100 > 66) dynStats("tou", -1);
			}
			if (mystic && changes < changeLimit && rand(2) === 0 && player.cor < 100) {
				if (player.cor < 33) outputText("\n\nA sense of dirtiness comes over you, like the magic of this gem is doing some perverse impropriety to you.");
				else if (player.cor < 66) outputText("\n\nA tingling wave of sensation rolls through you, but you have no idea what exactly just changed.  It must not have been that important.");
				else outputText("\n\nThoughts of mischief roll across your consciousness, unbounded by your conscience or any concern for others.  You should really have some fun - who cares who it hurts, right?");
				dynStats("cor", 1);
			}


			//**********************
			//MEDIUM/SEXUAL CHANGES
			//**********************
			//[adjust Femininity toward 50]
			//from low to high
			//Your facial features soften as your body becomes more androgynous.
			//from high to low
			//Your facial features harden as your body becomes more androgynous.
			if (((mystic && rand(2) === 0) || (!mystic && rand(4) === 0)) && changes < changeLimit && player.femininity !== 50) {
				outputText(player.modFem(50, 2));
				changes++;
			}
			//[decrease muscle tone toward 40]
			if (player.tone >= 40 && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(4) === 0))) {
				outputText("\n\nMoving brings with it a little more jiggle than you're used to.  You don't seem to have gained weight, but your muscles seem less visible, and various parts of you are pleasantly softer.");
				player.tone -= 2 + rand(3);
				changes++;
			}

			//[Adjust hips toward 10 – wide/curvy/flared]
			//from narrow to wide
			if (player.hips.rating < 10 && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0)) && changes < changeLimit) {
				player.hips.rating++;
				if (player.hips.rating < 7) player.hips.rating++;
				if (player.hips.rating < 4) player.hips.rating++;
				outputText("\n\nYou stumble a bit as the bones in your pelvis rearrange themselves painfully.  Your hips have widened nicely!");
				changes++;
			}
			//from wide to narrower
			if (player.hips.rating > 10 && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0)) && changes < changeLimit) {
				player.hips.rating--;
				if (player.hips.rating > 14) player.hips.rating--;
				if (player.hips.rating > 19) player.hips.rating--;
				if (player.hips.rating > 24) player.hips.rating--;
				outputText("\n\nYou stumble a bit as the bones in your pelvis rearrange themselves painfully.  Your hips have narrowed.");
				changes++;
			}

			//[Adjust hair length toward range of 16-26 – very long to ass-length]
			if ((player.hair.length < 16 || player.hair.length > 26) && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0)) && changes < changeLimit) {
				//from short to long
				if (player.hair.length < 16) {
					player.hair.length += 3 + rand(3);
					outputText("\n\nYou experience a tingling sensation in your scalp.  Feeling a bit off-balance, you discover your hair has lengthened, becoming " + player.hairDescript() + ".");
				}
				//from long to short
				else {
					player.hair.length -= 3 + rand(3);
					outputText("\n\nYou experience a tingling sensation in your scalp.  Feeling a bit off-balance, you discover your hair has shed a bit of its length, becoming " + player.hairDescript() + ".");
				}
				changes++;
			}
			//[Increase Vaginal Capacity] - requires vagina, of course
			if (player.hasVagina() && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0)) && player.statusEffectv1(StatusEffects.BonusVCapacity) < 200 && changes < changeLimit) {
				outputText("\n\nA gurgling sound issues from your abdomen, and you double over as a trembling ripple passes through your womb.  The flesh of your stomach roils as your internal organs begin to shift, and when the sensation finally passes, you are instinctively aware that your " + player.vaginaDescript(0) + " is a bit deeper than it was before.");
				if (!player.hasStatusEffect(StatusEffects.BonusVCapacity)) {
					player.createStatusEffect(StatusEffects.BonusVCapacity, 0, 0, 0, 0);
				}
				player.addStatusValue(StatusEffects.BonusVCapacity, 1, 10 + rand(10));
				changes++;
			}
			else if (((mystic && rand(2) === 0) || (!mystic && rand(3) === 0)) && player.statusEffectv1(StatusEffects.BonusACapacity) < 150 && changes < changeLimit) {
				outputText("\n\nYou feel... more accommodating somehow.  Your " + player.assholeDescript() + " is tingling a bit, and though it doesn't seem to have loosened, it has grown more elastic.");
				if (!player.hasStatusEffect(StatusEffects.BonusACapacity)) {
					player.createStatusEffect(StatusEffects.BonusACapacity, 0, 0, 0, 0);
				}
				player.addStatusValue(StatusEffects.BonusACapacity, 1, 10 + rand(10));
				changes++;
			}
			//[Vag of Holding] - rare effect, only if PC has high vaginal looseness
			else if (player.hasVagina() && ((mystic) || (!mystic && rand(5) === 0)) && player.statusEffectv1(StatusEffects.BonusVCapacity) >= 200 && player.statusEffectv1(StatusEffects.BonusVCapacity) < 8000 && changes < changeLimit) {
				outputText("\n\nYou clutch your stomach with both hands, dropping to the ground in pain as your internal organs begin to twist and shift violently inside you.  As you clench your eyes shut in agony, you are overcome with a sudden calm.  The pain in your abdomen subsides, and you feel at one with the unfathomable infinity of the universe, warmth radiating through you from the vast swirling cosmos contained within your womb.");
				if (silly()) outputText("  <b>Your vagina has become a universe unto itself, capable of accepting colossal insertions beyond the scope of human comprehension!</b>");
				else outputText("  <b>Your vagina is now capable of accepting even the most ludicrously sized insertions with no ill effects.</b>");
				player.changeStatusValue(StatusEffects.BonusVCapacity, 1, 8000);
				changes++;
			}


			//**********************
			//BIG APPEARANCE CHANGES
			//**********************
			//Neck restore
			if (player.neck.type !== Neck.NORMAL && changes < changeLimit && rand(4) === 0) restoreNeck(tfSource);
			//Rear body restore
			if (player.hasNonSharkRearBody() && changes < changeLimit && rand(5) === 0) restoreRearBody(tfSource);
			//Ovi perk loss
			if (rand(5) === 0) updateOvipositionPerk(tfSource);
			//[Grow Fox Tail]
			if (player.tail.type !== Tail.FOX && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(4) === 0))) {
				//if PC has no tail
				if (player.tail.type == Tail.NONE) {
					outputText("\n\nA pressure builds on your backside.  You feel under your " + player.armorName + " and discover a strange nodule growing there that seems to be getting larger by the second.  With a sudden flourish of movement, it bursts out into a long and bushy tail that sways hypnotically, as if it has a mind of its own.  <b>You now have a fox-tail.</b>");
				}
				//if PC has another type of tail
				else if (player.tail.type !== Tail.FOX) {
					outputText("\n\nPain lances through your lower back as your tail shifts and twitches violently.  With one final aberrant twitch, it fluffs out into a long, bushy fox tail that whips around in an almost hypnotic fashion.  <b>You now have a fox-tail.</b>");
				}
				player.tail.type = Tail.FOX;
				player.tail.venom = 1;
				changes++;
			}
			if (!mystic && player.ears.type == Ears.FOX && player.tail.type == Tail.FOX && player.tail.venom == 8 && rand(3) === 0) {
				outputText("\n\nYou have the feeling that if you could grow a ninth tail you would be much more powerful, but you would need to find a way to enhance one of these gems or meditate with one to have a chance at unlocking your full potential.");
			}
			//[Grow Addtl. Fox Tail]
			//(rare effect, up to max of 8 tails, requires PC level and int*10 = number of tail to be added)
			else if (player.tail.type == Tail.FOX && player.tail.venom < 8 && player.tail.venom + 1 <= player.level && player.tail.venom + 1 <= player.inte / 10 && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0))) {
				//if PC has 1 fox tail
				if (player.tail.venom == 1) {
					outputText("\n\nA tingling pressure builds on your backside, and your bushy tail begins to glow with an eerie, ghostly light.  With a crackle of electrical energy, your tail splits into two!  <b>You now have a pair of fox-tails.</b>");
					//increment tail by 1
				}
				//else if PC has 2 or more fox tails
				else {
					outputText("\n\nA tingling pressure builds on your backside, and your bushy tails begin to glow with an eerie, ghostly light.  With a crackle of electrical energy, one of your tails splits in two, giving you " + num2Text(player.tail.venom + 1) + "!  <b>You now have a cluster of " + num2Text(player.tail.venom + 1) + " fox-tails.</b>");
					//increment tail by 1
				}
				player.tail.venom++;
				changes++;
			}
			//[Grow 9th tail and gain Corrupted Nine-tails perk]
			else if (mystic && rand(4) === 0 && changes < changeLimit && player.tail.type == Tail.FOX && player.tail.venom == 8 && player.level >= 9 && player.ears.type == Ears.FOX && player.inte >= 90 && player.findPerk(PerkLib.CorruptedNinetails) < 0 && (player.findPerk(PerkLib.EnlightenedNinetails) < 0 || player.perkv4(PerkLib.EnlightenedNinetails) > 0)) {
				outputText("Your bushy tails begin to glow with an eerie, ghostly light, and with a crackle of electrical energy, split into nine tails.  <b>You are now a nine-tails!  But something is wrong...  The cosmic power radiating from your body feels...  tainted somehow.  The corruption pouring off your body feels...  good.</b>");
				outputText("\n\nYou have the inexplicable urge to set fire to the world, just to watch it burn.  With your newfound power, it's a goal that is well within reach.");
				outputText("\n\n(Perk Gained: Corrupted Nine-tails - Grants two magical special attacks.)");
				player.createPerk(PerkLib.CorruptedNinetails, 0, 0, 0, 0);
				dynStats("lib", 2, "lus", 10, "cor", 10);
				player.tail.venom = 9;
				changes++;
			}

			//[Grow Fox Ears]
			if (player.tail.type == Tail.FOX && ((mystic && rand(2) === 0) || (!mystic && rand(4) === 0)) && player.ears.type !== Ears.FOX && changes < changeLimit) {
				//if PC has non-animal ears
				if (player.ears.type == Ears.HUMAN) outputText("\n\nThe sides of your face painfully stretch as your ears morph and begin to migrate up past your hairline, toward the top of your head.  They elongate, becoming large vulpine triangles covered in bushy fur.  You now have fox ears.");
				//if PC has animal ears
				else outputText("\n\nYour ears change shape, shifting from their current shape to become vulpine in nature.  You now have fox ears.");
				player.ears.type = Ears.FOX;
				changes++;
			}
			//[Change Hair Color: Golden-blonde, SIlver Blonde, White, Black, Red]
			if (((mystic && rand(2) === 0) || (!mystic && rand(4) === 0)) && changes < changeLimit && !InCollection(player.hair.color, ColorLists.BASIC_KITSUNE_HAIR) && !InCollection(player.hair.color, ColorLists.ELDER_KITSUNE)) {
				if (player.tail.type == Tail.FOX && player.tail.venom == 9) player.hair.color = randomChoice(ColorLists.ELDER_KITSUNE);
				else player.hair.color = randomChoice(ColorLists.BASIC_KITSUNE_HAIR);
				outputText("\n\nYour scalp begins to tingle, and you gently grasp a strand, pulling it forward to check it.  Your hair has become the same " + player.hair.color + " as a kitsune's!");
				changes++;
			}
			var tone:Array = mystic ? ColorLists.KITSUNE_SKIN_MYSTIC : ColorLists.KITSUNE_SKIN;
			//[Change Skin Type: remove fur or scales, change skin to Tan, Olive, or Light]
			var theFurColor:String = player.skin.furColor;
			if (player.hasFur() && player.underBody.type == UnderBody.FURRY && player.skin.furColor !== player.underBody.skin.furColor)
				theFurColor = player.skin.furColor + " and " + player.underBody.skin.furColor;

			if ((player.hasFur()
					&& player.face.type != Face.FOX
					&& !InCollection(theFurColor, convertMixedToStringArray(ColorLists.BASIC_KITSUNE_FUR))
					&& !InCollection(theFurColor, ColorLists.ELDER_KITSUNE)
					&& !InCollection(theFurColor, ["orange and white", "black and white", "red and white", "tan", "brown"])
					)
				|| player.hasScales() && ((mystic) || (!mystic && rand(2) === 0))) {
				outputText("\n\nYou begin to tingle all over your [skin], starting as a cool, pleasant sensation but gradually worsening until you are furiously itching all over.");
				if (player.hasFur()) outputText("  You stare in horror as you pull your fingers away holding a handful of " + player.skin.furColor + " fur!  Your fur sloughs off your body in thick clumps, falling away to reveal patches of bare, " + player.skin.tone + " skin.");
				else if (player.hasScales()) outputText("  You stare in horror as you pull your fingers away holding a handful of dried up scales!  Your scales continue to flake and peel off your skin in thick patches, revealing the tender " + player.skin.tone + " skin underneath.");
				outputText("  Your skin slowly turns raw and red under your severe scratching, the tingling sensations raising goosebumps across your whole body.  Over time, the itching fades, and your flushed skin resolves into a natural-looking ");
				player.skin.type = Skin.PLAIN;
				player.skin.adj = "";
				player.skin.desc = "skin";
				player.underBody.restore();
				if (!InCollection(player.skin.tone, tone)) player.skin.tone = randomChoice(tone);
				outputText(player.skin.tone + " complexion.");
				outputText("  <b>You now have [skin]!</b>");
				player.arms.updateClaws(player.arms.claws.type);
				changes++;
			}
			//Change skin tone if not changed you!
			else if (!InCollection(player.skin.tone, tone) && changes < changeLimit && ((mystic && rand(2) === 0) || (!mystic && rand(3) === 0))) {
				outputText("\n\nYou feel a crawling sensation on the surface of your skin, starting at the small of your back and spreading to your extremities, ultimately reaching your face.  Holding an arm up to your face, you discover that <b>you now have ");
				player.skin.tone = randomChoice(tone);
				outputText("[skin]!</b>");
				player.arms.updateClaws(player.arms.claws.type);
				changes++;
			}
			//[Change Skin Color: add "Tattoos"]
			//From Tan, Olive, or Light skin tones
			else if (9999 == 0 && InCollection(player.skin.tone, tone) && changes < changeLimit) {
				outputText("You feel a crawling sensation on the surface of your skin, starting at the small of your back and spreading to your extremities, ultimately reaching your face.  You are caught by surprise when you are suddenly assaulted by a blinding flash issuing from areas of your skin, and when the spots finally clear from your vision, an assortment of glowing tribal tattoos adorns your [skin].  The glow gradually fades, but the distinctive ");
				if (mystic) outputText("angular");
				else outputText("curved");
				outputText(" markings remain, as if etched into your skin.");
				changes++;
				//9999 - pending tats system
			}
			//Nipples Turn Back:
			if (!player.hasFur() && player.hasStatusEffect(StatusEffects.BlackNipples) && changes < changeLimit && rand(3) === 0) {
				removeBlackNipples(tfSource);
			}
			//Debugcunt
			if (!player.hasFur() && changes < changeLimit && rand(3) === 0 && player.vaginaType() == 5 && player.hasVagina()) {
				outputText("\n\nSomething invisible brushes against your sex, making you twinge.  Undoing your clothes, you take a look at your vagina and find that it has turned back to its natural flesh colour.");
				player.vaginaType(0);
				changes++;
			}
			// Kitsunes should have normal arms and legs. exspecially skinny arms with claws are somewhat weird (Stadler76).
			if (player.hasPlainSkin() && rand(4) === 0) restoreArms(tfSource);
			if (player.hasPlainSkin() && rand(4) === 0) restoreLegs(tfSource);

			if (changes == 0) {
				outputText("\n\nOdd.  You don't feel any different.");
			}
			flags[kFLAGS.TIMES_TRANSFORMED] += changes;
		}
	}
}
