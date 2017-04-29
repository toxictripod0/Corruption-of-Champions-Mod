package classes.Scenes.Areas.HighMountains
{
	import classes.*;
	import classes.internals.ChainedDrop;
	import classes.GlobalFlags.*
	
	/**
	 * ...
	 * @author ...
	 */
	public class Cockatrice extends Monster 
	{
		public var omgItsPeenkee:Boolean = false;

		public function wingify():void
		{
			wingType = WING_TYPE_FEATHERED_LARGE;
			wingDesc = "large, feathered";
		}

		public function basiliskSpeed(player:Player, amount:Number = 0):void
		{
			if (player.spe - amount < 1) {
				amount = player.spe - 1;
				if (amount < 0) amount = 0;
			}
			player.spe -= amount;
			if (player.hasStatusEffect(StatusEffects.BasiliskSlow)) player.addStatusValue(StatusEffects.BasiliskSlow,1,amount);
			else player.createStatusEffect(StatusEffects.BasiliskSlow,amount,0,0,0);
			showStatDown( 'spe' );
		}

		//special 1: basilisk mental compulsion attack
		//(Check vs. Intelligence/Sensitivity, loss = recurrent speed loss each
		//round, one time lust increase):
		private function compulsion():void {
			outputText("The basilisk opens its mouth and, staring at you, utters words in its strange, dry, sibilant tongue.  The sounds bore into your mind, working and buzzing at the edges of your resolve, suggesting, compelling, then demanding you look into the basilisk's eyes.  ", false);
			//Success:
			if (player.inte / 5 + rand(20) < 24 + player.newGamePlusMod() * 5) {
				//Immune to Basilisk?
				if (player.findPerk(PerkLib.BasiliskResistance) >= 0 || player.canUseStare()) {
					outputText("You can't help yourself... you glimpse the reptile's grey, slit eyes. However, no matter how much you look into the eyes, you do not see anything wrong. All you can see is the basilisk. The basilisk curses as he finds out that you're immune!", false);
				}
				else {
					outputText("You can't help yourself... you glimpse the reptile's grey, slit eyes. You look away quickly, but you can picture them in your mind's eye, staring in at your thoughts, making you feel sluggish and unable to coordinate. Something about the helplessness of it feels so good... you can't banish the feeling that really, you want to look in the basilisk's eyes forever, for it to have total control over you.", false);
					game.dynStats("lus", 3);
					//apply status here
					basiliskSpeed(player,20);
					player.createStatusEffect(StatusEffects.BasiliskCompulsion,0,0,0,0);
					flags[kFLAGS.BASILISK_RESISTANCE_TRACKER] += 2;
				}
			}
			//Failure:
			else {
				outputText("You concentrate, focus your mind and resist the basilisk's psychic compulsion.", false);
			}
			game.combat.combatRoundOver();
		}



		//Special 3: basilisk tail swipe (Small physical damage):
		private function basiliskTailSwipe():void {
			outputText("The basilisk suddenly whips its tail at you, swiping your " + player.feet() + " from under you!  You quickly stagger upright, being sure to hold the creature's feet in your vision.  ", false);
			if (damage == 0) outputText("The fall didn't harm you at all.  ", false);
			var damage:Number = int((str + 20) - Math.random()*(player.tou+player.armorDef));
			damage = player.takeDamage(damage, true);			
			game.combat.combatRoundOver();
		}

		//basilisk physical attack: With lightning speed, the basilisk slashes you with its index claws!
		//Noun: claw

		override protected function performCombatAction():void
		{
			if (!player.hasStatusEffect(StatusEffects.BasiliskCompulsion) && rand(3) == 0 && !hasStatusEffect(StatusEffects.Blind)) compulsion();
			else if (rand(3) == 0) basiliskTailSwipe();
			else eAttack();
		}

		override public function defeated(hpVictory:Boolean):void
		{
			game.highMountains.basiliskScene.defeatBasilisk();
		}

		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void
		{
			if (pcCameWorms){
				outputText("\n\nThe basilisk smirks, but waits for you to finish...");
				doNext(game.combat.endLustLoss);
			} else {
				game.highMountains.basiliskScene.loseToBasilisk();
			}
		}

		public function Cockatrice()
		{
			this.a = "the ";
			this.short = "cockatrice";
			this.imageName = "cockatrice";
			this.long = "The cockatrice before you stands at about 6 foot 2. The harpy/basilisk hybrid hops from one clawed foot to the other,"
			           +" its turquoise neck ruff puffed out. From the creatures flat chest and tight butt, you assume that it must be male."
			           +" He watches you, his electric blue eyes glinting as his midnight blue tail swishes behind him. Every so often he lunges"
			           +" forward, beak open before revealing it was a feint. He is wielding his sharp claws as a weapon and is shielded only by his"
			           +" exotic plumage and cream scaled belly."
			           +" [if (monster.canFly) Every so often he spreads his large feathered wings in an attempt to intimidate you.]"
			           +" His lizard like feet occasionally gouge into the rubble of the plateau, flinging it up as he shifts his stance. ";
			// this.plural = false;
			this.createCock(6,2);
			this.balls = 2;
			this.ballSize = 2;
			createBreastRow(0);
			this.ass.analLooseness = ANAL_LOOSENESS_TIGHT;
			this.ass.analWetness = ANAL_WETNESS_DRY;
			this.createStatusEffect(StatusEffects.BonusACapacity,30,0,0,0);
			this.tallness = 6*12+2;
			this.hipRating = HIP_RATING_SLENDER+1;
			this.buttRating = BUTT_RATING_AVERAGE;
			this.lowerBody = LOWER_BODY_TYPE_LIZARD;
			this.faceType = FACE_LIZARD;
			this.earType = EARS_LIZARD;
			this.eyeType = EYES_BASILISK;
			this.hairType = HAIR_BASILISK_SPINES;
			this.skinTone = "grey-green";
			this.skinType = SKIN_TYPE_LIZARD_SCALES;
			//this.skinDesc = Appearance.Appearance.DEFAULT_SKIN_DESCS[SKIN_TYPE_LIZARD_SCALES];
			this.hairColor = "grey-green";
			this.hairLength = 2;
			/*
			// Bassy:
			initStrTouSpeInte(85, 70, 35, 70);
			initLibSensCor(50, 35, 60);
			// Harpy:
			initStrTouSpeInte(60, 40, 90, 40);
			initLibSensCor(70, 30, 80);
			*/
			initStrTouSpeInte(65, 50, 85, 70);
			initLibSensCor(50, 25, 20);
			this.weaponName = "claws";
			this.weaponVerb = "claw";
			this.weaponAttack = 30;
			this.armorName = "feathers";
			this.armorDef = 0;
			this.armorPerk = "";
			this.armorValue = 70;
			this.bonusHP = 200;
			this.lust = 30;
			this.lustVuln = .5;
			this.temperment = TEMPERMENT_RANDOM_GRAPPLES;
			this.level = 12;
			this.gems = rand(10) + 10;
			this.drop = new ChainedDrop().add(consumables.REPTLUM,0.9);
			this.tailType = TAIL_TYPE_LIZARD;
			this.tailRecharge = 0;
			this.createPerk(PerkLib.BasiliskResistance, 0, 0, 0, 0);
			checkMonster();
		}
		
	}

}