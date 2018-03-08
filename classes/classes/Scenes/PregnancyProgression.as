package classes.Scenes 
{
	import classes.*;
	import classes.GlobalFlags.*;
	import classes.Items.ArmorLib;
	import classes.internals.PregnancyUtils;
	import flash.utils.Dictionary;
	import classes.internals.LoggerFactory;
	import mx.logging.ILogger;
	
	public class PregnancyProgression extends BaseContent
	{
		private static const LOGGER:ILogger = LoggerFactory.getLogger(PregnancyProgression);
		
		/**
		 * This sensing variable is used by tests to detect if
		 * the vaginal birth code has been called.
		 */
		public var senseVaginalBirth:Vector.<int>;
		
		/**
		 * Map pregnancy type to the class that contains the matching scenes.
		 * Currently only stores player pregnancies.
		 */
		private var vaginalPregnancyScenes:Dictionary;
		
		public function PregnancyProgression() {
			this.senseVaginalBirth = new Vector.<int>();
			this.vaginalPregnancyScenes = new Dictionary();
		}
		
		/**
		 * Record a call to a vaginal birth function.
		 * This method is used for testing.
		 * @param	pregnancyType to record
		 */
		public function detectVaginalBirth(pregnancyType:int):void {
			senseVaginalBirth.push(pregnancyType);
		}
		
		/**
		 * Register a scene for vaginal pregnancy. The registered scene will be used for pregnancy
		 * progression and birth.
		 * <b>Note:</b> Currently only the player is supported as the mother.
		 * 
		 * @param	pregnancyTypeMother The creature that is the mother
		 * @param	pregnancyTypeFather The creature that is the father
		 * @param	scenes The scene to register for the combination
		 * @return true if an existing scene was overwritten
		 * @throws ArgumentError If the mother is not the player
		 */
		public function registerVaginalPregnancyScene(pregnancyTypeMother:int, pregnancyTypeFather:int, scenes:VaginalPregnancy):Boolean {
			if (pregnancyTypeMother !== PregnancyStore.PREGNANCY_PLAYER) {
				LOGGER.error("Currently only the player is supported as mother");
				throw new ArgumentError("Currently only the player is supported as mother");
			}
			
			var previousReplaced:Boolean = false;
			
			if (hasRegisteredVaginalScene(pregnancyTypeMother, pregnancyTypeFather)) {
				previousReplaced = true;
				LOGGER.warn("Vaginal scene registration for mother {0}, father {1} will be replaced.", pregnancyTypeMother, pregnancyTypeFather);
			}
			
			vaginalPregnancyScenes[pregnancyTypeFather] = scenes;
			LOGGER.debug("Mapped pregancy scene {0} to mother {1}, father {2}", scenes, pregnancyTypeMother, pregnancyTypeFather);
			
			return previousReplaced;
		}
		
		/**
		 * Check if the given vaginal pregnancy combination has a registered scene.
		 * @param	pregnancyTypeMother The creature that is the mother
		 * @param	pregnancyTypeFather The creature that is the father
		 * @return true if a scene is registered for the combination
		 */
		public function hasRegisteredVaginalScene(pregnancyTypeMother:int, pregnancyTypeFather:int):Boolean {
			// currently only player pregnancies are supported
			if (pregnancyTypeMother !== PregnancyStore.PREGNANCY_PLAYER) {
				return false;
			}
			
			return pregnancyTypeFather in vaginalPregnancyScenes;
		}
		
		private function giveBirth():void
		{
			if (player.fertility < 15) player.fertility++;
			if (player.fertility < 25) player.fertility++;
			if (player.fertility < 40) player.fertility++;
			if (!player.hasStatusEffect(StatusEffects.Birthed)) player.createStatusEffect(StatusEffects.Birthed,1,0,0,0);
			else {
				player.addStatusValue(StatusEffects.Birthed,1,1);
				if (player.findPerk(PerkLib.BroodMother) < 0 && player.statusEffectv1(StatusEffects.Birthed) >= 10) {
					output.text("\n<b>You have gained the Brood Mother perk</b> (Pregnancies progress twice as fast as a normal woman's).\n");
					player.createPerk(PerkLib.BroodMother,0,0,0,0);
				}
			}
		}
		
		public function updatePregnancy():Boolean
		{
			var displayedUpdate:Boolean = false;
			var pregText:String = "";
			if ((player.pregnancyIncubation <= 0 && player.buttPregnancyIncubation <= 0) ||
				(player.pregnancyType === 0 && player.buttPregnancyType === 0)) {
				return false;
			}

			displayedUpdate = cancelHeat();
			
			if (player.pregnancyIncubation === 1 && player.pregnancyType !== PregnancyStore.PREGNANCY_BENOIT) giveBirth();

			if (player.pregnancyIncubation > 0 && player.pregnancyIncubation < 2) player.knockUpForce(player.pregnancyType, 1);
			//IF INCUBATION IS VAGINAL
			if (player.pregnancyIncubation > 1) {
				displayedUpdate = updateVaginalPregnancy(displayedUpdate);
			}
			//IF INCUBATION IS ANAL
			if (player.buttPregnancyIncubation > 1) {
				displayedUpdate = updateAnalPregnancy(displayedUpdate);
			}
			
			amilyPregnancyFailsafe();
			displayedUpdate = benoitBirth(displayedUpdate);
			if (player.pregnancyIncubation === 1) {
				displayedUpdate = updateVaginalBirth(displayedUpdate);
			}
			
			displayedUpdate = updateAnalBirth(displayedUpdate);

			return displayedUpdate;
		}
		
		private function cancelHeat():Boolean 
		{
			if (player.inHeat) {
				outputText("\nYou calm down a bit and realize you no longer fantasize about getting fucked constantly.  It seems your heat has ended.\n");
				//Remove bonus libido from heat
				dynStats("lib", -player.statusEffectv2(StatusEffects.Heat));
				
				if (player.lib < 10) {
					player.lib = 10;
				}
				
				statScreenRefresh();
				player.removeStatusEffect(StatusEffects.Heat);
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Benoit birth or incubation reset code.
		 * Extracted because it does not behave like other birth code. 
		 * @param	displayUpdate current display update variable state 
		 * @return true if something in this function updates the displayed text,
		 * 				otherwise returns the state that was passed as parameter
		 */
		private function benoitBirth(displayUpdate:Boolean):Boolean 
		{
			if (player.pregnancyType === PregnancyStore.PREGNANCY_BENOIT && player.pregnancyIncubation <= 2) {
				if (getGame().time.hours !== 5 && getGame().time.hours !== 6) {
					player.knockUpForce(player.pregnancyType, 3); //Make sure eggs are only birthed early in the morning
				}
				else {
					player.knockUpForce(); //Clear Pregnancy
					giveBirth();
					getGame().bazaar.benoit.popOutBenoitEggs();
					
					return true;
				}
			}
			
			return displayUpdate;
		}
		
		private function updateVaginalPregnancy(displayedUpdate:Boolean):Boolean
		{
			if (hasRegisteredVaginalScene(PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType)) {
				var scene:VaginalPregnancy = vaginalPregnancyScenes[player.pregnancyType] as VaginalPregnancy;
				LOGGER.debug("Updating pregnancy for mother {0}, father {1} by using class {2}", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType, scene);
				return scene.updateVaginalPregnancy();
			} else {
				LOGGER.debug("Could not find a mapped vaginal pregnancy for mother {0}, father {1} - using legacy pregnancy progression", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType);;
			}
			
			if (player.pregnancyType === PregnancyStore.PREGNANCY_SAND_WITCH) {
				displayedUpdate = getGame().dungeons.desertcave.sandPregUpdate();
			}

			//Shark Pregnancy!
			if (player.pregnancyType === PregnancyStore.PREGNANCY_IZMA) {
				if (player.pregnancyIncubation === 275) {
					if (flags[kFLAGS.IZMA_FOLLOWER_STATUS] === 1) outputText("\n<b>You wake up feeling kind of nauseous.  Izma insists that you stay in bed and won't hear a word otherwise, tending to you in your sickened state.  When you finally feel better, she helps you up.  \"<i>You know, " + player.short + "... I think you might be pregnant.</i>\" Izma says, sounding very pleased at the idea. You have to admit, you do seem to have gained some weight...</b>\n");
					else outputText("\n<b>You wake up feeling bloated, and your belly is actually looking a little puffy. At the same time, though, you have the oddest cravings... you could really go for some fish.</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 250) {
					outputText("\n<b>Your belly is getting more noticeably distended and squirming around.  You are probably pregnant.</b>\n");
					displayedUpdate = true;	
				}
				if (player.pregnancyIncubation === 216) {
					if (flags[kFLAGS.IZMA_FOLLOWER_STATUS] === 1) outputText("\n<b>Your stomach is undeniably swollen now, and you feel thirsty all the time. Izma is always there to bring you water, even anticipating your thirst before you recognize it yourself. She smiles all the time now, and seems to be very pleased with herself.");
					else outputText("\n<b>There is no question you're pregnant; your belly is getting bigger and for some reason, you feel thirsty ALL the time.");
					outputText("</b>");
					outputText("\n");
					dynStats("spe", -1, "lib", 1, "sen", 1, "lus", 2);
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 180) {
					if (flags[kFLAGS.IZMA_FOLLOWER_STATUS] === 1) outputText("\n<b>There is no denying your pregnancy, and Izma is head-over-heels with your 'beautifully bountiful new body', as she puts it. She is forever finding an excuse to touch your bulging stomach, and does her best to coax you to rest against her. However, when you do sit against her, she invariably starts getting hard underneath you.</b>\n");
					else outputText("\n<b>There is no denying your pregnancy.  Your belly bulges and occasionally squirms as your growing offspring shifts position.</b>\n");
					displayedUpdate = true;				
				}
				if (player.pregnancyIncubation === 120) {
					if (flags[kFLAGS.IZMA_FOLLOWER_STATUS] === 1) outputText("\n<b>Your stomach is swollen and gravid; you can feel the baby inside you kicking and wriggling. Izma is always on hand now, it seems, and she won't dream of you fetching your own food or picking up anything you've dropped. She's always dropping hints about how you should try going around naked for comfort's sake. While you are unwilling to do so, you find yourself dreaming about sinking into cool, clean water, and take many baths and swims. Whatever is inside you always seems to like it; they get so much more active when you're in the water.</b>\n");
					else outputText("\n<b>Your stomach is swollen and gravid; you can feel the baby inside you kicking and wriggling.  You find yourself dreaming about sinking into cool, clean water, and take many baths and swims. Whatever is inside you always seems to like it; they get so much more active when you're in the water.</b>\n");
					dynStats("spe", -2, "lib", 1, "sen", 1, "lus", 4);
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 72) {
					if (flags[kFLAGS.IZMA_FOLLOWER_STATUS] === 1) outputText("\n<b>You dream of the water, of a life under the waves, where it's cool and wet and you are free. You spend as much time in the river as possible now, the baby inside you kicking and squirming impatiently, eager to be free of the confines of your womb and have much greater depths to swim and play in. Izma makes no secret of her pleasure and informs you that you should deliver soon.</b>\n");
					else outputText("\n<b>You dream of the water, of a life under the waves, where it's cool and wet and you are free. You spend as much time in the river as possible now, the baby inside you kicking and squirming impatiently, eager to be free of the confines of your womb and have much greater depths to swim and play in.  The time for delivery will probably come soon.</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 32 || player.pregnancyIncubation === 64 || player.pregnancyIncubation === 85 || player.pregnancyIncubation === 150) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
						displayedUpdate = true;
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
				}
			}
			//SPOIDAH Pregnancy!
			if (player.pregnancyType === PregnancyStore.PREGNANCY_SPIDER || player.pregnancyType === PregnancyStore.PREGNANCY_DRIDER_EGGS) {	
				if (player.pregnancyIncubation === 399) {
					outputText("\n<b>After your session with the spider, you feel much... fuller.  There is no outward change on your body as far as you can see but your womb feels slightly tingly whenever you move.  Hopefully it's nothing to be alarmed about.</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 275) {
					outputText("\n<b>Your belly grumbles as if empty, even though you ate not long ago.  Perhaps with all the exercise you're getting you just need to eat a little bit more.</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 250) {
					outputText("\n<b>Your belly looks a little pudgy");
					if (player.thickness > 60 && player.tone < 40) outputText(" even for you");
					outputText(", maybe you should cut back on all the food you've been consuming lately?</b>\n");
					displayedUpdate = true;	
				}
				if (player.pregnancyIncubation === 216) {
					outputText("\n<b>Your belly is definitely getting bigger, and no matter what you do, you can't seem to stop yourself from eating at the merest twinge of hunger.  The only explanation you can come up with is that you've gotten pregnant during your travels.  Hopefully it won't inconvenience your adventuring.</b>\n");
					displayedUpdate = true;				
				}
				if (player.pregnancyIncubation === 180) {
					outputText(images.showImage("spidermorph-male-loss-vag"));
					outputText("\n<b>A hot flush works its way through you, and visions of aroused ");
					if (player.pregnancyType === PregnancyStore.PREGNANCY_SPIDER) outputText("spider-morphs ");
					else outputText("driders ");
					outputText("quickly come to dominate your thoughts.  You start playing with a nipple while you lose yourself in the fantasy, imagining being tied up in webs and mated with over and over, violated by a pack of horny males, each hoping to father your next brood.  You shake free of the fantasy and notice your hands rubbing over your slightly bloated belly.  Perhaps it wouldn't be so bad?</b>\n");
					dynStats("lib", 1, "sen", 1, "lus", 20);
					displayedUpdate = true;				
				}
				if (player.pregnancyIncubation === 120) {
					outputText("\n<b>Your belly has gotten nice and big, perhaps as big as you remember the bellies of the pregnant women back home being.  The elders always did insist on everyone doing their part to keep the population high enough to sustain the loss of a champion every year.  You give yourself a little hug, getting a surge of happiness from your hormone-addled body.  Pregnancy sure is great!</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 72) {
					outputText("\n<b>The huge size of your pregnant belly constantly impedes your movement, but the constant squirming and shaking of your unborn offspring makes you pretty sure you won't have to carry them much longer.  A sense of motherly pride wells up in your breast - you just know you'll have such wonderful babies.");
					if (player.cor < 50) outputText("  You shudder and shake your head, wondering why you're thinking such unusual things.");
					outputText("</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 32 || player.pregnancyIncubation === 64 || player.pregnancyIncubation === 85 || player.pregnancyIncubation === 150) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
						displayedUpdate = true;
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
				}
			}
			//Goo Pregnancy!
			if (player.pregnancyType === PregnancyStore.PREGNANCY_GOO_GIRL) {	
				if (player.pregnancyIncubation === 72) {
					outputText("\n<b>The huge size of your pregnant belly constantly impedes your movement, but the constant squirming and shaking of your slime-packed belly is reassuring in its own way.  You can't wait to see how it feels to have the slime flowing and gushing through your lips, stroking you intimately as you birth new life into this world.");
					if (player.cor < 50) outputText("  You shudder and shake your head, wondering why you're thinking such unusual things.");
					outputText("</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 32 || player.pregnancyIncubation === 64 || player.pregnancyIncubation === 82 || player.pregnancyIncubation === 16) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
						displayedUpdate = true;
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
				}
			}

			//Pregnancy 4 Satyrs
			if (player.pregnancyType === PregnancyStore.PREGNANCY_SATYR) {
				//Stage 1: 
				if (player.pregnancyIncubation === 150) {
					outputText("\n<b>You find that you're feeling quite sluggish these days; you just don't have as much energy as you used to.  You're also putting on weight.</b>\n");
					displayedUpdate = true;
				}
				//Stage 2: 
				if (player.pregnancyIncubation === 125) {
					outputText("\n<b>Your belly is getting bigger and bigger.  Maybe your recent urges are to blame for this development?</b>\n");
					displayedUpdate = true;
				}
				//Stage 3: 
				if (player.pregnancyIncubation === 100) {
					outputText("\n<b>You can feel the strangest fluttering sensations in your distended belly; it must be a pregnancy.  You should eat more and drink plenty of wine so your baby can grow properly.  Wait, wine...?</b>\n");
					displayedUpdate = true;
				}
				//Stage 4: 
				if (player.pregnancyIncubation === 75) {
					outputText("\n<b>Sometimes you feel a bump in your pregnant belly.  You wonder if it's your baby complaining about your moving about.</b>\n");
					displayedUpdate = true;
				}
				//Stage 5: 
				if (player.pregnancyIncubation === 50) {
					outputText("\n<b>With your bloating gut, you are loathe to exert yourself in any meaningful manner; you feel horny and hungry all the time...</b>\n");
					displayedUpdate = true;
					//temp min lust up +5
				}
				//Stage 6: 
				if (player.pregnancyIncubation === 30) {
					outputText("\n<b>The baby you're carrying constantly kicks your belly in demand for food and wine, and you feel sluggish and horny.  You can't wait to birth this little one so you can finally rest for a while.</b>\n");
					displayedUpdate = true;
					//temp min lust up addl +5
				}
			}
			//BASILISK Pregnancy!
			if (player.pregnancyType === PregnancyStore.PREGNANCY_BASILISK || player.pregnancyType === PregnancyStore.PREGNANCY_BENOIT) {	
				if (player.pregnancyIncubation === 185) {
					outputText("\n<b>Your belly grumbles as if empty, even though you ate not long ago.  Perhaps with all the exercise you're getting you just need to eat a little bit more.</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 160) {
					outputText("\n<b>Your belly looks a little pudgy");
					if (player.thickness > 60 && player.tone < 40) outputText(" even for you");
					outputText(", maybe you should cut back on all the food you've been consuming lately?</b>\n");
					displayedUpdate = true;	
				}
				if (player.pregnancyIncubation === 140) {
					outputText("\n<b>Your belly is definitely getting bigger, and no matter what you do, you can't seem to stop yourself from eating at the merest twinge of hunger.  The only explanation you can come up with is that you've gotten pregnant during your travels.  Hopefully it won't inconvenience your adventuring.</b>\n");
					displayedUpdate = true;				
				}
				if (player.pregnancyIncubation === 110) {
					outputText("\n<b>Your belly has gotten nice and big, perhaps as big as you remember the bellies of the pregnant women back home being.  The elders always did insist on everyone doing their part to keep the population high enough to sustain the loss of a champion every year.  You give yourself a little hug, getting a surge of happiness from your hormone-addled body.  Pregnancy sure is great!</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 72) {
					outputText("\n<b>The huge size of your pregnant belly constantly impedes your movement, but the constant squirming and shaking of your unborn offspring makes you pretty sure you won't have to carry them much longer.  A sense of motherly pride wells up in your breast - you just know you'll have such wonderful babies.");
					if (player.cor < 50) outputText("  You shudder and shake your head, wondering why you're thinking such unusual things.");
					outputText("</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 32 || player.pregnancyIncubation === 64 || player.pregnancyIncubation === 85 || player.pregnancyIncubation === 150) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
						displayedUpdate = true;
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
				}
			}
			//COCKATRICE Pregnancy!
			if (player.pregnancyType === PregnancyStore.PREGNANCY_COCKATRICE) {	
				if (player.pregnancyIncubation === 185) {
					outputText("\n<b>Your belly grumbles as if empty, even though you ate not long ago.  Perhaps with all the exercise you're getting you just need to eat a little bit more.</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 160) {
					outputText("\n<b>Your belly looks a little pudgy");
					if (player.thickness > 60 && player.tone < 40) outputText(" even for you");
					outputText(", maybe you should cut back on all the food you've been consuming lately?</b>\n");
					displayedUpdate = true;	
				}
				if (player.pregnancyIncubation === 140) {
					outputText("\n<b>Your belly is definitely getting bigger, and no matter what you do, you can't seem to stop yourself from eating at the merest twinge of hunger.  The only explanation you can come up with is that you've gotten pregnant during your travels.  Hopefully it won't inconvenience your adventuring.</b>\n");
					displayedUpdate = true;				
				}
				if (player.pregnancyIncubation === 110) {
					outputText("\n<b>Your belly has gotten nice and big, perhaps as big as you remember the bellies of the pregnant women back home being.  The elders always did insist on everyone doing their part to keep the population high enough to sustain the loss of a champion every year.  You give yourself a little hug, getting a surge of happiness from your hormone-addled body.  Pregnancy sure is great!</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 72) {
					outputText("\n<b>The huge size of your pregnant belly constantly impedes your movement, but the constant squirming and shaking of your unborn offspring makes you pretty sure you won't have to carry them much longer.  A sense of motherly pride wells up in your breast - you just know you'll have such wonderful babies.");
					if (player.cor < 50) outputText("  You shudder and shake your head, wondering why you're thinking such unusual things.");
					outputText("</b>\n");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 32 || player.pregnancyIncubation === 64 || player.pregnancyIncubation === 85 || player.pregnancyIncubation === 150) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
						displayedUpdate = true;
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
						displayedUpdate = true;
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
						displayedUpdate = true;
					}
				}
			}

			//Minerva Pregnancy
			if (player.pregnancyType === PregnancyStore.PREGNANCY_MINERVA) {
				if (player.pregnancyIncubation === 216) {
					outputText("<b>You realize your belly has gotten slightly larger.  You could go for some peaches around now.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 144) {
					outputText("<b>Your belly is distended with pregnancy. You wish you could spend all day bathing.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 72) {
					outputText("<b>Your belly has grown enough for it to be twins.  Well, you <em>did</em> want to restore sirens to the world.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 24) {
					outputText("<b>Your belly is as big as it can get.  Your unborn children shuffle relentlessly, calming only when you try singing lullabys.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 144 || player.pregnancyIncubation === 72 || player.pregnancyIncubation === 85 || player.pregnancyIncubation === 150) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.  You wonder just what kind of creature they're getting ready to feed.\n");
						player.boostLactation(.5);
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
					}
				}
			}
			//Behemoth Pregnancy
			else if (player.pregnancyType === PregnancyStore.PREGNANCY_BEHEMOTH) {
				if (player.pregnancyIncubation === 1152) {
					outputText("<b>You realize your belly has gotten slightly larger.  Maybe you need to cut back on the strange food.  However, you have a feel that it's going to be a very long pregnancy.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 864) {
					outputText("<b>Your distended belly has grown noticeably, but you still have a long way to go.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 576) {
					outputText("<b>Your belly has yet to betray the sheer size of your expected offspring, but it's certainly making an attempt.  At this rate, you'll need to visit the father more just to keep your strength up.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 288) {
					outputText("<b>Your belly can't grow much larger than it already is; you hope you'll give birth soon.</b>");
					displayedUpdate = true;
				}
				if (player.pregnancyIncubation === 1024 || player.pregnancyIncubation === 768 || player.pregnancyIncubation === 512 || player.pregnancyIncubation === 256) {
					//Increase lactation!
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() >= 1 && player.biggestLactation() < 2) {
						outputText("\nYour breasts feel swollen with all the extra milk they're accumulating.  You hope it'll be enough for the coming birth.\n");
						player.boostLactation(.5);
					}
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() > 0 && player.biggestLactation() < 1) {
						outputText("\nDrops of breastmilk escape your nipples as your body prepares for the coming birth.\n");
						player.boostLactation(.5);
					}				
					//Lactate if large && not lactating
					if (player.biggestTitSize() >= 3 && player.mostBreastsPerRow() > 1 && player.biggestLactation() === 0) {
						outputText("\n<b>You realize your breasts feel full, and occasionally lactate</b>.  It must be due to the pregnancy.\n");
						player.boostLactation(1);
					}
					//Enlarge if too small for lactation
					if (player.biggestTitSize() === 2 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have swollen to C-cups,</b> in light of your coming pregnancy.\n");
						player.growTits(1, 1, false, 3);
					}
					//Enlarge if really small!
					if (player.biggestTitSize() === 1 && player.mostBreastsPerRow() > 1) {
						outputText("\n<b>Your breasts have grown to B-cups,</b> likely due to the hormonal changes of your pregnancy.\n");
						player.growTits(1, 1, false, 3);
					}
				}
			}
			
			return displayedUpdate;
		}
		
		private function updateAnalPregnancy(displayedUpdate:Boolean):Boolean 
		{
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_FROG_GIRL) {
				if (player.buttPregnancyIncubation === 8) {
					//Egg Maturing
					outputText("\nYour gut churns, and with a squelching noise, a torrent of transparent slime gushes from your ass.  You immediately fall to your knees, landing wetly amidst the slime.  The world around briefly flashes with unbelievable colors, and you hear someone giggling.\n\nAfter a moment, you realize that it’s you.");
					//pussy:
					if (player.hasVagina()) outputText("  Against your [vagina], the slime feels warm and cold at the same time, coaxing delightful tremors from your [clit].");
					//[balls:
					else if (player.balls > 0) outputText("  Slathered in hallucinogenic frog slime, your balls tingle, sending warm pulses of pleasure all the way up into your brain.");
					//[cock:
					else if (player.hasCock()) outputText("  Splashing against the underside of your " + player.multiCockDescriptLight() + ", the slime leaves a warm, oozy sensation that makes you just want to rub [eachCock] over and over and over again.");
					//genderless: 
					else outputText("  Your asshole begins twitching, aching for something to push through it over and over again.");
					outputText("  Seated in your own slime, you moan softly, unable to keep your hands off yourself.");
					dynStats("lus=", player.maxLust(), "scale", false);
					displayedUpdate = true;
				}
			}
			//Pregnancy 4 Satyrs
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_SATYR) {
				//Stage 1: 
				if (player.buttPregnancyIncubation === 150) {
					outputText("\n<b>You find that you're feeling quite sluggish these days; you just don't have as much energy as you used to.  You're also putting on weight.</b>\n");
					displayedUpdate = true;
				}
				//Stage 2: 
				if (player.buttPregnancyIncubation === 125) {
					outputText("\n<b>Your belly is getting bigger and bigger.  Maybe your recent urges are to blame for this development?</b>\n");
					displayedUpdate = true;
				}
				//Stage 3: 
				if (player.buttPregnancyIncubation === 100) {
					outputText("\n<b>You can feel the strangest fluttering sensations in your distended belly; it must be a pregnancy.  You should eat more and drink plenty of wine so your baby can grow properly.  Wait, wine...?</b>\n");
					displayedUpdate = true;
				}
				//Stage 4: 
				if (player.buttPregnancyIncubation === 75) {
					outputText("\n<b>Sometimes you feel a bump in your pregnant belly.  You wonder if it's your baby complaining about your moving about.</b>\n");
					displayedUpdate = true;
				}
				//Stage 5: 
				if (player.buttPregnancyIncubation === 50) {
					outputText("\n<b>With your bloating gut, you are loathe to exert yourself in any meaningful manner; you feel horny and hungry all the time...</b>\n");
					displayedUpdate = true;
					//temp min lust up +5
				}
				//Stage 6: 
				if (player.buttPregnancyIncubation === 30) {
					outputText("\n<b>The baby you're carrying constantly kicks your belly in demand for food and wine, and you feel sluggish and horny.  You can't wait to birth this little one so you can finally rest for a while.</b>\n");
					displayedUpdate = true;
					//temp min lust up addl +5
				}
			}
			//DRIDAH BUTT Pregnancy!
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_DRIDER_EGGS) {	
				if (player.buttPregnancyIncubation === 199) {
					outputText("\n<b>After your session with the drider, you feel so nice and... full.  There is no outward change on your body, aside from the egg-packed bulge of your belly, but your " + player.assholeDescript() + " tingles slightly and leaks green goop from time to time. Hopefully it's nothing to be alarmed about.</b>\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 180) {
					outputText(images.showImage("cDrider-loss-butt"));
					outputText("\n<b>A hot flush works its way through you, and visions of aroused driders quickly come to dominate your thoughts.  You start playing with a nipple while you lose yourself in the fantasy, imagining being tied up in webs and packed completely full of eggs, stuffing your belly completely with burgeoning spheres of love.  You shake free of the fantasy and notice your hands rubbing over your slightly bloated belly.  Perhaps it wouldn't be so bad?</b>\n");
					dynStats("lib", 1, "sen", 1, "lus", 20);
					displayedUpdate = true;				
				}
				if (player.buttPregnancyIncubation === 120) {
					outputText("\n<b>Your belly is bulging from the size of the eggs growing inside you and gurgling just about any time you walk.  Green goo runs down your " + player.legs() + " frequently, drooling out of your pregnant asshole.</b>\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 72) {
					outputText("\n<b>The huge size of your pregnant belly constantly impedes your movement, but the constant squirming and shaking of your unborn offspring makes you pretty sure you won't have to carry them much longer.");
					outputText("</b>\n");
					displayedUpdate = true;
				}
			}
			//Bee Egg's in butt pregnancy
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_BEE_EGGS) {
				if (player.buttPregnancyIncubation === 36) {
					outputText("<b>\nYou feel bloated, your bowels shifting uncomfortably from time to time.</b>\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 20) {
					outputText("<b>\nA honey-scented fluid drips from your rectum.</b>  At first it worries you, but as the smell fills the air around you, you realize anything with such a beautiful scent must be good.  ");
					if (player.cockTotal() > 0) outputText("The aroma seems to permeate your very being, slowly congregating in your ");
					if (player.cockTotal() === 1) {
						outputText(player.cockDescript(0));
						if (player.countCocksOfType(CockTypesEnum.HORSE) === 1) outputText(", each inhalation making it bigger, harder, and firmer.  You suck in huge lungfuls of air, until your " + player.cockDescript(0) + " is twitching and dripping, the flare swollen and purple.  ");
						if (player.dogCocks() === 1) outputText(", each inhalation making it thicker, harder, and firmer.  You suck in huge lungfuls of air, desperate for more, until your " + player.cockDescript(0) + " is twitching and dripping, its knot swollen to the max.  ");
						if (player.countCocksOfType(CockTypesEnum.HUMAN) === 1) outputText(", each inhalation making it bigger, harder, and firmer.  You suck in huge lungfuls of air, until your " + player.cockDescript(0) + " is twitching and dripping, the head swollen and purple.  ");
						//FAILSAFE FOR NEW COCKS
						if (player.countCocksOfType(CockTypesEnum.HUMAN) === 0 && player.dogCocks() === 0 && player.countCocksOfType(CockTypesEnum.HORSE) === 0) outputText(", each inhalation making it bigger, harder, and firmer.  You suck in huge lungfuls of air until your " + player.cockDescript(0) + " is twitching and dripping.  ");
					}
					if (player.cockTotal() > 1) outputText("groin.  Your " + player.multiCockDescriptLight() + " fill and grow with every lungful of the stuff you breathe in.  You suck in great lungfuls of the tainted air, desperate for more, your cocks twitching and dripping with need.  ");
					outputText("You smile knowing you couldn't stop from masturbating if you wanted to.\n");
					dynStats("int", -.5, "lus", 500);
					displayedUpdate = true;
				}
			}
			//Sand Traps in butt pregnancy
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_SANDTRAP || player.buttPregnancyType === PregnancyStore.PREGNANCY_SANDTRAP_FERTILE) {
				if (player.buttPregnancyIncubation === 36) {
					//(Eggs take 2-3 days to lay)
					outputText("<b>\nYour bowels make a strange gurgling noise and shift uneasily.  You feel ");
					if (player.buttPregnancyType === PregnancyStore.PREGNANCY_SANDTRAP_FERTILE) outputText(" bloated and full; the sensation isn't entirely unpleasant.");
					else {
						outputText("increasingly empty, as though some obstructions inside you were being broken down.");
						player.buttKnockUpForce(); //Clear Butt Pregnancy
					}
					outputText("</b>\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 20) {
					//end eggpreg here if unfertilized
					outputText("\nSomething oily drips from your sphincter, staining the ground.  You suppose you should feel worried about this, but the overriding emotion which simmers in your gut is one of sensual, yielding calm.  The pressure in your bowels which has been building over the last few days feels right somehow, and the fact that your back passage is dribbling lubricant makes you incredibly, perversely hot.  As you stand there and savor the wet, soothing sensation a fantasy pushes itself into your mind, one of being on your hands and knees and letting any number of beings use your ass, of being bred over and over by beautiful, irrepressible insect creatures.  With some effort you suppress these alien emotions and carry on, trying to ignore the oil which occasionally beads out of your " + player.assholeDescript() + " and stains your [armor].\n");
					dynStats("int", -.5, "lus", 500);
					displayedUpdate = true;
				}
			}
			//Bunny TF buttpreggoz
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_BUNNY) {
				if (player.buttPregnancyIncubation === 800) {
					outputText("\nYour gut gurgles strangely.\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 785) {
					getGame().mutations.neonPinkEgg(true,player);
					outputText("\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 776) {
					outputText("\nYour gut feels full and bloated.\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 765) {
					getGame().mutations.neonPinkEgg(true,player);
					outputText("\n");
					displayedUpdate = true;
				}
				if (player.buttPregnancyIncubation === 745) {
					outputText("\n<b>After dealing with the discomfort and bodily changes for the past day or so, you finally get the feeling that the eggs in your ass have dissolved.</b>\n");
					displayedUpdate = true;
					player.buttKnockUpForce(); //Clear Butt Pregnancy
				}
			}
			
			return displayedUpdate;
		}

		/**
		 * Changes pregnancy type to Mouse if Amily is in a invalid state.
		 */
		private function amilyPregnancyFailsafe():void 
		{
			//Amily failsafe - converts PC with pure babies to mouse babies if Amily is corrupted
			if (player.pregnancyIncubation === 1 && player.pregnancyType === PregnancyStore.PREGNANCY_AMILY) 
			{
				if (flags[kFLAGS.AMILY_FOLLOWER] === 2 || flags[kFLAGS.AMILY_CORRUPTION] > 0) {
					player.knockUpForce(PregnancyStore.PREGNANCY_MOUSE, player.pregnancyIncubation);
				}
			}
			
			//Amily failsafe - converts PC with pure babies to mouse babies if Amily is with Urta
			if (player.pregnancyIncubation === 1 && player.pregnancyType === PregnancyStore.PREGNANCY_AMILY) 
			{
				if (flags[kFLAGS.AMILY_VISITING_URTA] === 1 || flags[kFLAGS.AMILY_VISITING_URTA] === 2) {
					player.knockUpForce(PregnancyStore.PREGNANCY_MOUSE, player.pregnancyIncubation);
				}
			}
			
			//Amily failsafe - converts PC with pure babies to mouse babies if PC is in prison.
			if (player.pregnancyIncubation === 1 && player.pregnancyType === PregnancyStore.PREGNANCY_AMILY) 
			{
				if (prison.inPrison) {
					player.knockUpForce(PregnancyStore.PREGNANCY_MOUSE, player.pregnancyIncubation);
				}
			}
		}
		
		/**
		 * Check is the player has a vagina and create one if missing.
		 */
		private function createVaginaIfMissing(): void {
			PregnancyUtils.createVaginaIfMissing(output, player);
		}
		
		private function updateVaginalBirth(displayedUpdate:Boolean):Boolean 
		{
			if (hasRegisteredVaginalScene(PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType)) {
				var scene:VaginalPregnancy = vaginalPregnancyScenes[player.pregnancyType] as VaginalPregnancy;
				LOGGER.debug("Updating vaginal birth for mother {0}, father {1} by using class {2}", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType, scene);
				scene.vaginalBirth();
			} else {
				LOGGER.debug("Could not find a mapped vaginal pregnancy scene for mother {0}, father {1} - using legacy pregnancy progression", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType);;
			}

			if (player.pregnancyType === PregnancyStore.PREGNANCY_SAND_WITCH) {
				detectVaginalBirth(PregnancyStore.PREGNANCY_SAND_WITCH);
				getGame().dungeons.desertcave.birthAWitch();
			}
			if (player.pregnancyType === PregnancyStore.PREGNANCY_IZMA) {
				detectVaginalBirth(PregnancyStore.PREGNANCY_IZMA);
				getGame().izmaScene.pcPopsOutASharkTot();
				
			}
			
			//SPOIDAH BIRF
			if (player.pregnancyType === PregnancyStore.PREGNANCY_SPIDER) {
				detectVaginalBirth(PregnancyStore.PREGNANCY_SPIDER);
				getGame().swamp.maleSpiderMorphScene.spiderPregVagBirth();
			}
			//DRIDER BIRF
			if (player.pregnancyType === PregnancyStore.PREGNANCY_DRIDER_EGGS) {
				detectVaginalBirth(PregnancyStore.PREGNANCY_DRIDER_EGGS);
				getGame().swamp.corruptedDriderScene.driderPregVagBirth();
			}

			//GOO BIRF
			if (player.pregnancyType === PregnancyStore.PREGNANCY_GOO_GIRL) {
				getGame().lake.gooGirlScene.gooPregVagBirth();
			}
			
			if (player.pregnancyType === PregnancyStore.PREGNANCY_BASILISK) {
				detectVaginalBirth(PregnancyStore.PREGNANCY_BASILISK);
				getGame().highMountains.basiliskScene.basiliskBirth();
			}
			if (player.pregnancyType === PregnancyStore.PREGNANCY_COCKATRICE) {
				detectVaginalBirth(PregnancyStore.PREGNANCY_COCKATRICE);
				getGame().highMountains.cockatriceScene.cockatriceBirth();
			}
			//Satyr vag preg
			if (player.pregnancyType === PregnancyStore.PREGNANCY_SATYR) {
				getGame().plains.satyrScene.satyrBirth(true);
			}
			
			//Give birth to sirens.
			if (player.pregnancyType === PregnancyStore.PREGNANCY_MINERVA) {
				if (prison.prisonLetter.deliverChildWhileInPrison()) return displayedUpdate;
				createVaginaIfMissing();
				kGAMECLASS.highMountains.minervaScene.minervaPurification.playerGivesBirth();
				if (player.hips.rating < 10) {
					player.hips.rating++;
					outputText("\n\nAfter the birth your " + player.armorName + " fits a bit more snugly about your " + player.hipDescript() + ".");
				}
				outputText("\n");
			}
			
			//Give birth to behemoth.
			if (player.pregnancyType === PregnancyStore.PREGNANCY_BEHEMOTH) {
				if (prison.prisonLetter.deliverChildWhileInPrison()) return displayedUpdate;
				createVaginaIfMissing();
				kGAMECLASS.volcanicCrag.behemothScene.giveBirthToBehemoth();
				if (player.hips.rating < 10) {
					player.hips.rating++;
					outputText("\n\nAfter the birth your " + player.armorName + " fits a bit more snugly about your " + player.hipDescript() + ".");
				}
				outputText("\n");
			}
			
			//Egg status messages
			if (player.pregnancyType === PregnancyStore.PREGNANCY_OVIELIXIR_EGGS && player.pregnancyIncubation > 0) {
				if (player.vaginas.length === 0) {
					player.removeStatusEffect(StatusEffects.Eggs);
					outputText("\n<b>Your pregnant belly suddenly begins shrinking, until it disappears.</b>\n");
					player.knockUpForce(); //Clear Pregnancy
				}			
				//Birth scenes
				if (player.pregnancyIncubation === 1) {
					createVaginaIfMissing();
					var oviMaxOverdoseGainedOviPerk:Boolean = false;
					if (!player.hasPerk(PerkLib.Oviposition) && flags[kFLAGS.OVIMAX_OVERDOSE] > 0 && rand(3) < flags[kFLAGS.OVIMAX_OVERDOSE]) {
						outputText("You instantly feel your body seize up and you know something is wrong."
						          +" [if (hasWeapon)You let go of your [weapon] before your|Your] legs completely give out from under you and"
						          +" a high pitched, death curdle escapes your lips as you fall to your knees. Clutching your stomach,"
						          +" you bury your face into the ground, your screaming turning into a violent high pitched wail."
						          +" Deep inside your uterus you feel a shuddering, inhuman change as your womb violently and painfully,"
						          +" shifts and warps around your unfertilized eggs, becoming a more accommodating, cavernous home for them."
						          +" Your wails quieted down and became a mess of heaving sighs and groans. Your eyes weakly register as your belly"
						          +" trembles with a vengeance, and you realize there is still more to come.\n\n");
						if (player.armor !== ArmorLib.NOTHING) {
							outputText("Realizing you're about to give birth, you rip off your [armor] before it can be ruined by what's coming.\n\n");
						}
						oviMaxOverdoseGainedOviPerk = true;
					}
					flags[kFLAGS.OVIMAX_OVERDOSE] = 0;
					//Small egg scenes
					if (player.statusEffectv2(StatusEffects.Eggs) === 0) {
						//light quantity
						if (player.statusEffectv3(StatusEffects.Eggs) < 10) {
							outputText("You are interrupted as you find yourself overtaken by an uncontrollable urge to undress and squat.   You berate yourself for giving in to the urge for a moment before feeling something shift.  You hear the splash of fluid on the ground and look down to see a thick greenish fluid puddling underneath you.  There is no time to ponder this development as a rounded object passes down your birth canal, spreading your feminine lips apart and forcing a blush to your cheeks.  It plops into the puddle with a splash, and you find yourself feeling visibly delighted to be laying such healthy eggs.   Another egg works its way down and you realize the process is turning you on more and more.   In total you lay ");
							outputText(eggDescript()); 
							outputText(", driving yourself to the very edge of orgasm.");
							dynStats("lus=", player.maxLust(), "scale", false);
						}
						//High quantity
						else {
							outputText("A strange desire overwhelms your sensibilities, forcing you to shed your " + player.armorName + " and drop to your hands and knees.   You manage to roll over and prop yourself up against a smooth rock, looking down over your pregnant-looking belly as green fluids leak from you, soaking into the ground.   A powerful contraction rips through you and your legs spread instinctively, opening your " + player.vaginaDescript(0) + " to better deposit your precious cargo.   You see the rounded surface of an egg peek through your lips, mottled with strange colors.   You push hard and it drops free with an abrupt violent motion.  The friction and slimy fluids begin to arouse you, flooding your groin with heat as you feel the second egg pushing down.  It slips free with greater ease than the first, arousing you further as you bleat out a moan from the unexpected pleasure.  Before it stops rolling on the ground, you feel the next egg sliding down your slime-slicked passage, rubbing you perfectly as it slides free.  You lose count of the eggs and begin to masturbate, ");
							if (player.getClitLength() > 5) outputText("jerking on your huge clitty as if it were a cock, moaning and panting as each egg slides free of your diminishing belly.  You lubricate it with a mix of your juices and the slime until ");
							if (player.getClitLength() > 2 && player.getClitLength() <= 5) outputText("playing with your over-large clit as if it were a small cock, moaning and panting as the eggs slide free of your diminishing belly.  You spread the slime and cunt juice over it as you tease and stroke until ");
							if (player.getClitLength() <= 2) outputText("pulling your folds wide and playing with your clit as another egg pops free from your diminishing belly.  You make wet 'schlick'ing sounds as you spread the slime around, vigorously frigging yourself until "); 
							outputText("you quiver in orgasm, popping out the last of your eggs as your body twitches nervelessly on the ground.   In total you lay " + eggDescript() + ".");
							player.orgasm('Vaginal');
							dynStats("scale", false);
						}
					}
					//Large egg scene
					else {
						outputText("A sudden shift in the weight of your pregnant belly staggers you, dropping you to your knees.  You realize something is about to be birthed, and you shed your " + player.armorName + " before it can be ruined by what's coming.  A contraction pushes violently through your midsection, ");
						if (player.vaginas[0].vaginalLooseness < VaginaClass.LOOSENESS_LOOSE) outputText("stretching your tight cunt painfully, the lips opening wide ");
						if (player.vaginas[0].vaginalLooseness >= VaginaClass.LOOSENESS_LOOSE && player.vaginas[0].vaginalLooseness <= VaginaClass.LOOSENESS_GAPING_WIDE) outputText("temporarily stretching your cunt-lips wide-open ");
						if (player.vaginas[0].vaginalLooseness > VaginaClass.LOOSENESS_GAPING_WIDE) outputText("parting your already gaping lips wide ");
						outputText("as something begins sliding down your passage.  A burst of green slime soaks the ground below as the birthing begins in earnest, and the rounded surface of a strangely colored egg peaks between your lips.  You push hard and the large egg pops free at last, making you sigh with relief as it drops into the pool of slime.  The experience definitely turns you on, and you feel your clit growing free of its hood as another big egg starts working its way down your birth canal, rubbing your sensitive vaginal walls pleasurably.   You pant and moan as the contractions stretch you tightly around the next, slowly forcing it out between your nether-lips.  The sound of a gasp startles you as it pops free, until you realize it was your own voice responding to the sudden pressure and pleasure.  Aroused beyond reasonable measure, you begin to masturbate ");
						if (player.getClitLength() > 5) outputText("your massive cock-like clit, jacking it off with the slimy birthing fluids as lube.   It pulses and twitches in time with your heartbeats, its sensitive surface overloading your fragile mind with pleasure.  ");
						if (player.getClitLength() > 2 && player.getClitLength() <= 5) outputText("your large clit like a tiny cock, stroking it up and down between your slime-lubed thumb and fore-finger.  It twitches and pulses with your heartbeats, the incredible sensitivity of it overloading your fragile mind with waves of pleasure.  ");
						if (player.getClitLength() <= 2) outputText("your " + player.vaginaDescript(0) + " by pulling your folds wide and playing with your clit.  Another egg pops free from your diminishing belly, accompanied by an audible burst of relief.  You make wet 'schlick'ing sounds as you spread the slime around, vigorously frigging yourself.  ");
						outputText("You cum hard, the big eggs each making your cunt gape wide just before popping free.  You slump down, exhausted and barely conscious from the force of the orgasm.  ");
						if (player.statusEffectv3(StatusEffects.Eggs) >= 11) outputText("Your swollen belly doesn't seem to be done with you, as yet another egg pushes its way to freedom.   The stimulation so soon after orgasm pushes you into a pleasure-stupor.  If anyone or anything discovered you now, they would see you collapsed next to a pile of eggs, your fingers tracing the outline of your " + player.vaginaDescript(0) + " as more and more eggs pop free.  In time your wits return, leaving you with the realization that you are no longer pregnant.  ");
						outputText("\n\nYou gaze down at the mess, counting " + eggDescript() + ".");
						player.orgasm('Vaginal');
						dynStats("scale", false);
					}
					if (oviMaxOverdoseGainedOviPerk) {
						outputText("\n\n(<b>Perk Gained: Oviposition</b>)");
						player.createPerk(PerkLib.Oviposition, 0, 0, 0, 0);
					}
					outputText("\n\n<b>You feel compelled to leave the eggs behind, ");
					if (player.hasStatusEffect(StatusEffects.AteEgg)) outputText("but you remember the effects of the last one you ate.\n</b>");
					else outputText("but your body's intuition reminds you they shouldn't be fertile, and your belly rumbles with barely contained hunger.\n</b>");
					player.cuntChange(20, true);
					player.createStatusEffect(StatusEffects.LootEgg,0,0,0,0);
					player.knockUpForce(); //Clear Pregnancy
				}
			}
			
			player.knockUpForce();
			
			return true;
		}

		private function updateAnalBirth(displayedUpdate:Boolean):Boolean 
		{
			//Give birf if its time... to ANAL EGGS
			if (player.buttPregnancyIncubation === 1 && player.buttPregnancyType === PregnancyStore.PREGNANCY_FROG_GIRL) {
				getGame().bog.frogGirlScene.birthFrogEggsAnal();
				displayedUpdate = true;
				player.buttKnockUpForce(); //Clear Butt Pregnancy
			}
			//Give birf if its time... to ANAL EGGS
			if (player.buttPregnancyIncubation === 1 && player.buttPregnancyType === PregnancyStore.PREGNANCY_DRIDER_EGGS) {
				getGame().swamp.corruptedDriderScene.birthSpiderEggsFromAnusITSBLEEDINGYAYYYYY();
				displayedUpdate = true;
				player.buttKnockUpForce(); //Clear Butt Pregnancy
			}
			//GIVE BIRF TO TRAPS
			if (player.buttPregnancyIncubation === 1 && player.buttPregnancyType === PregnancyStore.PREGNANCY_SANDTRAP_FERTILE) {
				getGame().desert.sandTrapScene.birfSandTarps();
				player.buttKnockUpForce(); //Clear Butt Pregnancy
				if (player.butt.rating < 17) {
					//Guaranteed increase up to level 10
					if (player.butt.rating < 13) {
						player.butt.rating++;
						outputText("\nYou notice your " + player.buttDescript() + " feeling larger and plumper after the ordeal.\n");
					}
					//Big butts only increase 50% of the time.
					else if (rand(2) === 0){
						player.butt.rating++;
						outputText("\nYou notice your " + player.buttDescript() + " feeling larger and plumper after the ordeal.\n");				
					}
				}
				displayedUpdate = true;
			}	
			//Give birth (if it's time) to beeeeeeez
			if (player.buttPregnancyIncubation === 1 && player.buttPregnancyType === PregnancyStore.PREGNANCY_BEE_EGGS) {
				outputText("\n");
				outputText(images.showImage("birth-beegirl"));
				outputText("There is a sudden gush of honey-colored fluids from your ass.  Before panic can set in, a wonderful scent overtakes you, making everything ok.  ");
				if (player.cockTotal() > 0) outputText("The muzzy feeling that fills your head seems to seep downwards, making your equipment hard and tight.  ");
				if (player.vaginas.length > 0) outputText("Your " + player.vaginaDescript(0) + " becomes engorged and sensitive.  ");
				outputText("Your hand darts down to the amber, scooping up a handful of the sticky stuff.  You wonder what your hand is doing as it brings it up to your mouth, which instinctively opens.  You shudder in revulsion as you swallow the sweet-tasting stuff, your mind briefly wondering why it would do that.  The stuff seems to radiate warmth, quickly pushing those nagging thoughts away as you scoop up more.\n\n");
				outputText("A sudden slip from below surprises you; a white sphere escapes from your anus along with another squirt of honey.  Your drugged brain tries to understand what's happening, but it gives up, your hands idly slathering honey over your loins.  The next orb pops out moments later, forcing a startled moan from your mouth.  That felt GOOD.  You begin masturbating to the thought of laying more eggs... yes, that's what those are.  You nearly cum as egg number three squeezes out.  ");
				if (player.averageLactation() >= 1 && player.biggestTitSize() > 2) outputText("Seeking even greater sensation, your hands gather the honey and massage it into your " + player.breastDescript(0) + ", slowly working up to your nipples.  Milk immediately begins pouring out from the attention, flooding your chest with warmth.  ");
				outputText("Each egg seems to come out closer on the heels of the one before, and each time your conscious mind loses more of its ability to do anything but masturbate and wallow in honey.\n\n");
				outputText("Some time later, your mind begins to return, brought to wakefulness by an incredibly loud buzzing...  You sit up and see a pile of dozens of eggs resting in a puddle of sticky honey.  Most are empty, but a few have hundreds of honey-bees emptying from them, joining the massive swarms above you.  ");
				if (player.cor < 35) outputText("You are disgusted, but glad you were not stung during the ordeal.  You stagger away and find a brook to wash out your mouth with.");
				if (player.cor >= 35 && player.cor < 65) outputText("You are amazed you could lay so many eggs, and while the act was strange there was something definitely arousing about it.");
				if (player.cor >= 65 && player.cor < 90) outputText("You stretch languidly, noting that most of the drugged honey is gone.  Maybe you can find the Bee again and remember to bottle it next time.");
				if (player.cor >= 90) outputText("You lick your lips, savoring the honeyed residue on them as you admire your thousands of children.  If only every night could be like this...\n");
				player.buttKnockUpForce(); //Clear Butt Pregnancy
				player.orgasm('Anal');
				dynStats("int", 1, "lib", 4, "sen", 3);
				if (player.buttChange(20, true)) outputText("\n");
				if (player.butt.rating < 17) {
					//Guaranteed increase up to level 10
					if (player.butt.rating < 13) {
						player.butt.rating++;
						outputText("\nYou notice your " + player.buttDescript() + " feeling larger and plumper after the ordeal.");
					}
					//Big butts only increase 50% of the time.
					else if (rand(2) === 0){
						player.butt.rating++;
						outputText("\nYou notice your " + player.buttDescript() + " feeling larger and plumper after the ordeal.");				
					}
				}
				outputText("\n");
				displayedUpdate = true;
			}

			//Satyr butt preg
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_SATYR && player.buttPregnancyIncubation === 1) {
				player.buttKnockUpForce(); //Clear Butt Pregnancy
				displayedUpdate = true;
				getGame().plains.satyrScene.satyrBirth(false);
			}
			
			return displayedUpdate;
		}
		
		public function eggDescript(plural:Boolean = true):String
		{
			var descript:String = "";
			if (player.hasStatusEffect(StatusEffects.Eggs)) {
				descript += num2Text(player.statusEffectv3(StatusEffects.Eggs)) + " ";
				//size descriptor
				if (player.statusEffectv2(StatusEffects.Eggs) === 1) descript += "large ";
				/*color descriptor
				0 - brown - ass expansion
				1 - purple - hip expansion
				2 - blue - vaginal removal and/or growth of existing maleness
				3 - pink - dick removal and/or fertility increase.
				4 - white - breast growth.  If lactating increases lactation.
				5 - rubbery black - 
				*/
				if (player.statusEffectv1(StatusEffects.Eggs) === 0) descript += "brown ";
				if (player.statusEffectv1(StatusEffects.Eggs) === 1) descript += "purple ";
				if (player.statusEffectv1(StatusEffects.Eggs) === 2) descript += "blue ";
				if (player.statusEffectv1(StatusEffects.Eggs) === 3) descript += "pink ";
				if (player.statusEffectv1(StatusEffects.Eggs) === 4) descript += "white ";
				if (player.statusEffectv1(StatusEffects.Eggs) === 5) descript += "rubbery black ";
				//EGGS
				if (plural) descript += "eggs";
				else descript += "egg";
				return descript;
			}
			CoC_Settings.error("");
			return "EGG ERRORZ";
		}
		
	}

}
