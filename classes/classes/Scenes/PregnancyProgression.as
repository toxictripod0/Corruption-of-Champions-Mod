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
		 * the vaginal birth code has been called. This is used for pregnancies
		 * that do not provide any other means of detection (e.g. counter variables).
		 */
		public var senseVaginalBirth:Vector.<int>;
		
		/**
		 * This sensing variable is used by tests to detect if
		 * the anal birth code has been called. This is used for pregnancies
		 * that do not provide any other means of detection (e.g. counter variables).
		 */
		public var senseAnalBirth:Vector.<int>;
		
		
		/**
		 * Map pregnancy type to the class that contains the matching scenes.
		 * Currently only stores player pregnancies.
		 */
		private var vaginalPregnancyScenes:Dictionary;
		
		/**
		 * Map pregnancy type to the class that contains the matching scenes.
		 * Currently only stores player pregnancies.
		 */
		private var analPregnancyScenes:Dictionary;
		
		public function PregnancyProgression() {
			this.senseVaginalBirth = new Vector.<int>();
			this.senseAnalBirth = new Vector.<int>();
			
			this.vaginalPregnancyScenes = new Dictionary();
			this.analPregnancyScenes = new Dictionary();
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
		 * Record a call to a anal birth function.
		 * This method is used for testing.
		 * @param	pregnancyType to record
		 */
		public function detectAnalBirth(pregnancyType:int):void
		{
			senseAnalBirth.push(pregnancyType);
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
		 * Register a scene for anal pregnancy. The registered scene will be used for pregnancy
		 * progression and birth.
		 * <b>Note:</b> Currently only the player is supported as the mother.
		 * 
		 * @param	pregnancyTypeMother The creature that is the mother
		 * @param	pregnancyTypeFather The creature that is the father
		 * @param	scenes The scene to register for the combination
		 * @return true if an existing scene was overwritten
		 * @throws ArgumentError If the mother is not the player
		 */
		public function registerAnalPregnancyScene(pregnancyTypeMother:int, pregnancyTypeFather:int, scenes:AnalPregnancy):Boolean
		{
			if (pregnancyTypeMother !== PregnancyStore.PREGNANCY_PLAYER) {
				LOGGER.error("Currently only the player is supported as mother");
				throw new ArgumentError("Currently only the player is supported as mother");
			}
			
			var previousReplaced:Boolean = false;
			
			if (hasRegisteredAnalScene(pregnancyTypeMother, pregnancyTypeFather)) {
				previousReplaced = true;
				LOGGER.warn("Anal scene registration for mother {0}, father {1} will be replaced.", pregnancyTypeMother, pregnancyTypeFather);
			}
			
			analPregnancyScenes[pregnancyTypeFather] = scenes;
			LOGGER.debug("Mapped anal pregancy scene {0} to mother {1}, father {2}", scenes, pregnancyTypeMother, pregnancyTypeFather);
			
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
		
		/**
		 * Check if the given anal pregnancy combination has a registered scene.
		 * @param	pregnancyTypeMother The creature that is the mother
		 * @param	pregnancyTypeFather The creature that is the father
		 * @return true if a scene is registered for the combination
		 */
		public function hasRegisteredAnalScene(pregnancyTypeMother:int, pregnancyTypeFather:int):Boolean
		{
			// currently only player pregnancies are supported
			if (pregnancyTypeMother !== PregnancyStore.PREGNANCY_PLAYER) {
				return false;
			}
			
			return pregnancyTypeFather in analPregnancyScenes;
		}
		
		/**
		 * Update the current vaginal and anal pregnancies (if any). Updates player status and outputs messages related to pregnancy or birth. 
		 * @return true if the output needs to be updated
		 */
		public function updatePregnancy():Boolean
		{
			var displayedUpdate:Boolean = false;
			var pregText:String = "";
			if ((player.pregnancyIncubation <= 0 && player.buttPregnancyIncubation <= 0) ||
				(player.pregnancyType === 0 && player.buttPregnancyType === 0)) {
				return false;
			}

			displayedUpdate = cancelHeat();
			
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
			
			if (player.pregnancyIncubation === 1) {
				displayedUpdate = updateVaginalBirth(displayedUpdate);
			}
			
			if (player.buttPregnancyIncubation === 1) {
				displayedUpdate = updateAnalBirth(displayedUpdate);
			}

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
		
		private function updateVaginalPregnancy(displayedUpdate:Boolean):Boolean
		{
			if (hasRegisteredVaginalScene(PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType)) {
				var scene:VaginalPregnancy = vaginalPregnancyScenes[player.pregnancyType] as VaginalPregnancy;
				LOGGER.debug("Updating pregnancy for mother {0}, father {1} by using class {2}", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType, scene);
				return scene.updateVaginalPregnancy();
			} else {
				LOGGER.debug("Could not find a mapped vaginal pregnancy for mother {0}, father {1} - using legacy pregnancy progression", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType);;
			}
			
			return displayedUpdate;
		}
		
		private function updateAnalPregnancy(displayedUpdate:Boolean):Boolean 
		{
			var analPregnancyType:int = player.buttPregnancyType;
			
			if (hasRegisteredAnalScene(PregnancyStore.PREGNANCY_PLAYER, analPregnancyType)) {
				var scene:AnalPregnancy = analPregnancyScenes[analPregnancyType] as AnalPregnancy;
				LOGGER.debug("Updating anal pregnancy for mother {0}, father {1} by using class {2}", PregnancyStore.PREGNANCY_PLAYER, analPregnancyType, scene);
				return scene.updateAnalPregnancy() || displayedUpdate;
			} else {
				LOGGER.debug("Could not find a mapped anal pregnancy for mother {0}, father {1} - using legacy pregnancy progression", PregnancyStore.PREGNANCY_PLAYER, analPregnancyType);
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
				
				// TODO find a cleaner way to solve this
				// ignores Benoit pregnancy because that is a special case
				if (player.pregnancyType !== PregnancyStore.PREGNANCY_BENOIT) {
					giveBirth();
				}
			} else {
				LOGGER.debug("Could not find a mapped vaginal pregnancy scene for mother {0}, father {1} - using legacy pregnancy progression", PregnancyStore.PREGNANCY_PLAYER, player.pregnancyType);;
			}
			
			// TODO find a better way to do this
			// due to non-conforming pregancy code
			if (player.pregnancyType === PregnancyStore.PREGNANCY_BENOIT && player.pregnancyIncubation === 3) {
				return displayedUpdate;
			}
			
			player.knockUpForce();
			
			return true;
		}
		
		/**
		 * Updates fertility and tracks number of births. If the player has birthed
		 * enough children, gain the broodmother perk.
		 */
		public function giveBirth():void
		{
			//TODO remove this once new Player calls have been removed
			var player:Player = kGAMECLASS.player;
			
			if (player.fertility < 15) {
				player.fertility++;
			}
			
			if (player.fertility < 25) {
				player.fertility++;
			}
			
			if (player.fertility < 40) {
				player.fertility++;
			}
			
			if (!player.hasStatusEffect(StatusEffects.Birthed)) {
				player.createStatusEffect(StatusEffects.Birthed,1,0,0,0);
			} else {
				player.addStatusValue(StatusEffects.Birthed,1,1);
				
				if (player.findPerk(PerkLib.BroodMother) < 0 && player.statusEffectv1(StatusEffects.Birthed) >= 10) {
					output.text("\n<b>You have gained the Brood Mother perk</b> (Pregnancies progress twice as fast as a normal woman's).\n");
					player.createPerk(PerkLib.BroodMother,0,0,0,0);
				}
			}
		}

		private function updateAnalBirth(displayedUpdate:Boolean):Boolean 
		{
			var analPregnancyType:int = player.buttPregnancyType;
			
			if (hasRegisteredAnalScene(PregnancyStore.PREGNANCY_PLAYER, analPregnancyType)) {
				var scene:AnalPregnancy = analPregnancyScenes[analPregnancyType] as AnalPregnancy;
				LOGGER.debug("Updating anal birth for mother {0}, father {1} by using class {2}", PregnancyStore.PREGNANCY_PLAYER, analPregnancyType, scene);
				scene.analBirth();
				displayedUpdate = true;
			} else {
				LOGGER.debug("Could not find a mapped anal pregnancy scene for mother {0}, father {1} - using legacy pregnancy progression", PregnancyStore.PREGNANCY_PLAYER, analPregnancyType);
			}
			
			//GIVE BIRF TO TRAPS
			if (player.buttPregnancyType === PregnancyStore.PREGNANCY_SANDTRAP_FERTILE) {
				getGame().desert.sandTrapScene.birfSandTarps();
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
				detectAnalBirth(PregnancyStore.PREGNANCY_SANDTRAP_FERTILE);
			}	
			
			player.buttKnockUpForce();
			
			return displayedUpdate;
		}
	}
}
