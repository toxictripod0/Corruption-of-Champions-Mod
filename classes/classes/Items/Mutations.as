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
	}
}
