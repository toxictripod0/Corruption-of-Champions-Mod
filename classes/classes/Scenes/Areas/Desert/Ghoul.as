// By Foxwells
// Ghouls! Cuz wynaut? We already have one spirit entity.
// Will first appear as a normal hyena, first damaging turns them into ghost form. Like a Zoroark.
// Can't be lusted because they're, well, flesh-hungry ghosts. They don't wanna fuck.
// If win: Ghoul eats them (I PROMISE I don't have a vore fetish), PC suffers stat drop
// If lose: They poof away.

package classes.Scenes.Areas.Desert {
	import classes.*;
	import classes.internals.*;
	import classes.internals.WeightedDrop;
	
	public class Ghoul extends Monster {
	
		public var spellCostBlind:int = 8;
		public var spellCostGhoulMagic:int = 12;
		public var ghoulReveal:Boolean = false;
	
		if (!monster.ghoulReveal && monster.HP < monster.eMaxHP()) {
			outputText("\n\nYour " + player.weaponName + "strikes the hyena, causing it to recoil and vanish in a cloud of sandy dust. You stumble back in surprise and look up to see a snarling, ghostly creature in the air. Your enemy wasn't a hyena. It was a ghoul!", false);
			if (silly()) outputText("\n\n<b>The wild Ghoul's illusion wore off!</b>", false);
			monster.ghoulReveal = true;
		}
	
		protected function hyenaBite():void {
			if(findStatusEffect(StatusEffects.Blind) >= 0) { //Blind
				outputText("The hyena lunges for you, aiming to bite you, but misses entirely due to its blindness!", false);
				combatRoundOver();
				return;
			}
			if (player.getEvasionRoll()) { //Evading
				outputText("The hyena lunges for you, aiming to bite you, but easily move out of the way.", false);
				combatRoundOver();
				return;
			}
			else { //Damage
				outputText("The hyena lunges for you, sinking its teeth into you.", false);
				var damage:int = (rand(10) + 5);
				damage = player.reduceDamage(damage);
				player.takeDamage(damage, true);
			}
			combatRoundOver();
		}
	
		protected function hyenaClaw():void {
			if(findStatusEffect(StatusEffects.Blind) >= 0) { //Blind
				outputText("The hyena slashes its paw at you, but misses due to its blindness!", false);
				combatRoundOver();
				return;
			}
			if (player.getEvasionRoll()) { //Evading
				outputText("The hyena slashes its paw at you, but you easily move out of the way.", false);
				combatRoundOver();
				return;
			}
			else { //Damage
				outputText("The hyena slashes its paw at you, raking down hard and causing you to yelp in pain.", false);
				var damage:int = (rand(5) + 5);
				damage = player.reduceDamage(damage);
				player.takeDamage(damage, true);
			}
			combatRoundOver();
		}
		
		protected function ghoulBlind():void {
			if (fatigue <= (100 - spellCostBlind)) {
				outputText("The ghoul glares and points at you! A bright flash erupts before you! ");
				if (rand(player.inte / 5) <= 4) {
					outputText("<b>You are blinded!</b>");
					player.createStatusEffect(StatusEffects.Blind, 1 + rand(3), 0, 0, 0);
				}
				else {
					outputText("You manage to blink in the nick of time!");
				}
				fatigue += spellCostBlind;
			}
			combatRoundOver();
		}
		
		protected function ghoulMagic():void {
			if (fatigue <= (100 - spellCostGhoulMagic)) {
				outputText("The ghoul chants out an incantation, and a dark alchemic circle forms around your feet. ", false);
				if (player.getEvasionRoll()) { //Evading
					outputText("You jump out of the circle before anything happens. Where you'd just been erupts in flames.", false);
					combatRoundOver();
					return;
				}
				else { //Damage
					outputText("Blackened flames burst from the circle, causing you to seize with pain as they scorch every inch of your body.", false);
					var damage:int = (rand(10) + 10);
					damage = player.reduceDamage(damage);
					player.takeDamage(damage, true);
				}
				fatigue += spellCostGhoulMagic;
			}
			combatRoundOver();
		}
		
		override protected function performCombatAction():void {
			var chooser:Number = 0;
			chooser = rand(10);
			if (!monster.ghoulReveal) {
				if (chooser <= 3) hyenaClaw();
				else if (chooser >= 8) hyenaBite();
				else eAttack();
			} else {
				if (chooser < 3) ghoulMagic();
				else if (chooser >= 8) ghoulBlind();
				else eAttack();
			}
		}

		override public function defeated(hpVictory:Boolean):void
		{
			outputText("\n\nThe ghoul lets out a furious screech as your attacks become too much to bear and vanishes in a dusty cloud of sand. You're left staring at the spot, wondering if you just hallucinated everything that happened.", false);
			game.combat.cleanupAfterCombat();
		}
		
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void
		{
			if(pcCameWorms){
				outputText("\n\nThe ghoul lets out a disgusted noise and vanishes without a word.", false);
				doNext(game.combat.endLustLoss);
			} else {
				game.desert.ghoulScene.ghoulWon();
			}
		}
		
		private const COCK_VARIATIONS:Array = [
			["HUMAN"],
			["HORSE"],
			["DOG"],
			["DEMON"],
			["TENTACLE"],
			["CAT"],
			["LIZARD"],
			["ANEMONE"],
			["KANGAROO"],
			["DRAGON"],
			["DISPLACER"],
			["FOX"],
			["BEE"],
			["PIG"],
			["AVIAN"],
			["RHINO"],
			["ECHIDNA"],
			["WOLF"]
		];
		
		private const VIRGIN_VARIATIONS:Array = [
			["true"],
			["false"]
		];
		
		private const ANALLOOSE_VARIATIONS:Array = [
			["VIRGIN"],
			["TIGHT"],
			["NORMAL"],
			["LOOSE"],
			["STRETCHED"],
			["GAPING"]
		];
		
		private const ANALWET_VARIATIONS:Array = [
			["DRY"],
			["NORMAL"],
			["MOIST"],
			["SLIMY"],
			["DROOLING"],
			["SLIME_DROOLING"]
		];
		
		private const HIP_VARIATIONS:Array = [
			["BOYISH"],
			["SLENDER"],
			["AVERAGE"],
			["AMPLE"],
			["CURVY"],
			["FERTILE"],
			["INHUMANLY_WIDE"]
		];
		
		private const BUTT_VARIATIONS:Array = [
			["BUTTLESS"],
			["TIGHT"],
			["AVERAGE"],
			["NOTICEABLE"],
			["LARGE"],
			["JIGGLY"],
			["EXPANSIVE"],
			["HUGE"],
			["INCONCEIVABLY_BIG"]
		];
		
		private const LEG_VARIATIONS:Array = [
			["HUMAN"],
			["HOOFED"],
			["DOG"],
			["NAGA"],
			["DEMONIC_HIGH_HEELS"],
			["DEMONIC_CLAWS"],
			["BEE"],
			["GOO"],
			["CAT"],
			["LIZARD"],
			["PONY"],
			["BUNNY"],
			["HARPY"],
			["KANGAROO"],
			["CHITINOUS_SPIDER_LEGS"],
			["DRIDER_LOWER_BODY"],
			["FOX"],
			["DRAGON"],
			["RACCOON"],
			["FERRET"],
			["CLOVEN_HOOFED"],
			["ECHIDNA"],
			["SALAMANDER"],
			["WOLF"]
		];
		
		private const ARM_VARIATIONS:Array = [
			["HUMAN"],
			["HARPY"],
			["SPIDER"],
			["PREDATOR"],
			["SALAMANDER"],
			["WOLF"]
		];
		
		private const SKINCOLOUR_VARIATIONS:Array = [
			["albino"],
			["aphotic blue-black"],
			["ashen grayish-blue"],
			["ashen"],
			["black"],
			["blue"],
			["brown"],
			["cerulean"],
			["dark green"],
			["dark"],
			["ebony"],
			["emerald"],
			["ghostly pale"],
			["gray"],
			["grayish-blue"],
			["green"],
			["indigo"],
			["light"],
			["milky white"],
			["olive"],
			["orange and black striped"],
			["orange"],
			["pale white"],
			["pale yellow"],
			["pale"],
			["pink"],
			["purple"],
			["red"],
			["rough gray"],
			["sable"],
			["sanguine"],
			["shiny black"],
			["silver"],
			["tan"],
			["white"]
		];
		
		private const SKINTYPE_VARIATIONS:Array = [
			["PLAIN"],
			["FUR"],
			["LIZARD_SCALES"],
			["GOO"],
			["DRAGON_SCALES"]
		];
		
		private const HAIRCOLOUR_VARIATIONS:Array = [
			["auburn"],
			["black and orange"],
			["black and white spotted"],
			["black and yellow"],
			["black"],
			["blond"],
			["blonde"],
			["blue"],
			["brown"],
			["cerulean"],
			["dark blue"],
			["deep red"],
			["emerald"],
			["golden blonde"],
			["golden-blonde"],
			["gray"],
			["green"],
			["light blonde"],
			["midnight black"],
			["orange"],
			["pink"],
			["platinum blonde"],
			["purple"],
			["red"],
			["reddish-orange"],
			["sandy blonde"],
			["sandy brown"],
			["shiny black"],
			["silver blonde"],
			["silver-white"],
			["silver"],
			["white and black"],
			["white"]
		];
		
		private const HAIRTYPE_VARIATIONS:Array = [
			["NORMAL"],
			["FEATHER"],
			["GHOST"],
			["GOO"],
			["ANEMONE"],
			["QUILL"],
			["BASILISK_SPINES"],
			["BASILISK_PLUME"]
		];
		
		private const FACE_VARIATIONS:Array = [
			["HUMAN"],
			["HORSE"],
			["DOG"],
			["COW_MINOTAUR"],
			["SHARK_TEETH"],
			["SNAKE_FANGS"],
			["CAT"],
			["LIZARD"],
			["BUNNY"],
			["KANGAROO"],
			["SPIDER_FANGS"],
			["FOX"],
			["DRAGON"],
			["RACCOON_MASK"],
			["RACCOON"],
			["BUCKTEETH"],
			["MOUSE"],
			["FERRET_MASK"],
			["FERRET"],
			["PIG"],
			["BOAR"],
			["RHINO"],
			["ECHIDNA"],
			["DEER"],
			["WOLF"]
		];
		
		private const EARS_VARIATIONS:Array = [
			["HUMAN"],
			["HORSE"],
			["DOG"],
			["COW"],
			["ELVIN"],
			["CAT"],
			["LIZARD"],
			["BUNNY"],
			["KANGAROO"],
			["FOX"],
			["DRAGON"],
			["RACCOON"],
			["MOUSE"],
			["FERRET"],
			["PIG"],
			["RHINO"],
			["ECHIDNA"],
			["DEER"],
			["WOLF"]
		];
		
		private const TONGUE_VARIATIONS:Array = [
			["HUMAN"],
			["SNAKE"],
			["DEMONIC"],
			["DRACONIC"],
			["ECHIDNA"],
			["LIZARD"]
		];
		
		private const EYES_VARIATIONS:Array = [
			["HUMAN"],
			["FOUR_SPIDER_EYES"],
			["BLACK_EYES_SAND_TRAP"],
			["LIZARD"],
			["DRAGON"],
			["BASILISK"],
			["WOLF"]
		];
		
		private const WEAPON_VARIATIONS:Array = [
			["sword"],
			["rapier"],
			["scimitar"],
			["katana"],
			["halberd"],
			["axe"],
			["dagger"]
		];
		
		private const ARMOR_VARIATIONS:Array = [
			["Bee Armor"],
			["Chainmail Armor"],
			["Dragonscale Armor"],
			["Gel Armor"],
			["Leather Armor"],
			["Platemail Armor"],
			["Samurai Armor"],
			["Scalemail Armor"],
			["Spider-Silk Armor"],
			["Ballroom Dress"],
			["Leather Robes"],
			["Bondage Straps"],
			["Chainmail Bikini"],
			["Classy Suitclothes"],
			["Comfortable Clothes"],
			["Green Adventurer's Clothes"],
			["Kimono"],
			["Nurse's Outfit"],
			["Overalls"],
			["Robes"],
			["Rubber Outfit"],
			["Bodysuit"],
			["Slutty Swimwear"],
			["Spider-Silk Robes"],
			["Scandalously Seductive Armor"],
			["Wizard's Robes"],
			["Birthday Suit"]
		];
		
		private const TAIL_VARIATIONS:Array = [
			["HORSE"],
			["DOG"],
			["DEMONIC"],
			["COW"],
			["SPIDER_ADBOMEN"],
			["BEE_ABDOMEN"],
			["SHARK"],
			["CAT"],
			["LIZARD"],
			["RABBIT"],
			["HARPY"],
			["KANGAROO"],
			["FOX"],
			["DRACONIC"],
			["RACCOON"],
			["MOUSE"],
			["FERRET"],
			["BEHEMOTH"],
			["PIG"],
			["SCORPION"],
			["GOAT"],
			["RHINO"],
			["ECHIDNA"],
			["DEER"],
			["SALAMANDER"],
			["WOLF"]
		];
		
		private const HORN_VARIATIONS:Array = [
			["DEMON"],
			["COW_MINOTAUR"],
			["DRACONIC_X2"],
			["DRACONIC_X4_12_INCH_LONG"],
			["ANTLERS"],
			["GOAT"],
			["UNICORN"],
			["RHINO"]
		];
		
		private const WING_VARIATIONS:Array = [
			["BEE_LIKE_SMALL"],
			["BEE_LIKE_LARGE"],
			["HARPY"],
			["IMP"],
			["IMP_LARGE"],
			["BAT_LIKE_TINY"],
			["BAT_LIKE_LARGE"],
			["SHARK_FIN"],
			["FEATHERED_LARGE"],
			["DRACONIC_SMALL"],
			["DRACONIC_LARGE"],
			["GIANT_DRAGONFLY"]
		];

		public function Ghoul() {
		if (!monster.ghoulReveal) {
			this.a = "the ";
			this.short = "hyena";
			this.imageName = "ghoulhyena";
			this.long = "The hyena appears to be a regular spotted hyena, with pale brown fur covered in dark brown spots. Its forequarters are strong and muscular while its hindquarters are notably underdeveloped in comparison. It has a flat snout ending in a black nose, and curved, erect ears tipped in black. Its eyes watch you closely in case you try any sudden movements. There seem to be no other hyenas in sight, and you can't stop thinking about how odd it is that there's even a hyena in a desert.";
			if (rand(2) == 0) {
				this.createCock(6,1,CockTypesEnum.DOG);
				this.balls = 2;
				this.ballSize = 1;
			} else {
				this.createVagina(false,2,2);
				this.createBreastRow(2,1);
				this.createBreastRow(2,1);
				this.createBreastRow(2,1);
			}
			this.ass.analLooseness = ANAL_LOOSENESS_NORMAL;
			this.ass.analWetness = ANAL_WETNESS_DRY;
			
			this.tallness = 36;
			this.hipRating = HIP_RATING_AVERAGE;
			this.buttRating = BUTT_RATING_AVERAGE;
			this.lowerBody = LOWER_BODY_TYPE_DOG;
			this.armType = ARM_TYPE_PREDATOR;

			this.skinTone = "tan";
			this.skinType = SKIN_TYPE_FUR;
			this.skinDesc = "spotted fur";

			this.hairColor = "tan";
			this.hairLength = 2;
			this.hairType = HAIR_NORMAL;

			this.faceType = FACE_DOG;
			this.earType = EARS_DOG;

			initStrTouSpeInte(45,30,55,25);
			initLibSensCor(0,0,50);

			this.weaponName = "teeth";
			this.weaponVerb = "bite";
			this.weaponAttack = 3;

			this.armorName = "fur";
			this.armorDef = 1;

			this.bonusHP = 100;
			this.lust = 0;
			this.lustVuln = 0;
			this.temperment = TEMPERMENT_AVOID_GRAPPLES;
			this.fatigue = 0;

			this.level = 4;
			this.gems = rand(25) + 5;

			this.drop = new WeightedDrop(consumables.ECTOPLS);

			this.special1 = hyenaBite;
			this.special2 = hyenaClaw;

			this.tailType = TAIL_TYPE_DOG;
			
			checkMonster();
		} else {
		var cockTypes:Array = randomChoice(COCK_VARIATIONS);
		var vaginaVirgin:Array = randomChoice(VIRGIN_VARIATIONS);
		var analLoose:Array = randomChoice(ANALLOOSE_VARIATIONS);
		var analWet:Array = randomChoice(ANALWET_VARIATIONS);
		var hipRate:Array = randomChoice(HIP_VARIATIONS);
		var buttRate:Array = randomChoice(BUTT_VARIATIONS);
		var legType:Array = randomChoice(LEG_VARIATIONS);
		var armsType:Array = randomChoice(ARM_VARIATIONS);
		var skinColour:Array = randomChoice(SKINCOLOUR_VARIATIONS);
		var skinsType:Array = randomChoice(SKINTYPE_VARIATIONS);
		var hairColours:Array = randomChoice(HAIRCOLOUR_VARIATIONS);
		var hairTypes:Array = randomChoice(HAIRTYPE_VARIATIONS);
		var faceTypes:Array = randomChoice(FACE_VARIATIONS);
		var earTypes:Array = randomChoice(EARS_VARIATIONS);
		var tongueTypes:Array = randomChoice(TONGUE_VARIATIONS);
		var eyeTypes:Array = randomChoice(EYES_VARIATIONS);
		var weaponTypes:Array = randomChoice(WEAPON_VARIATIONS);
		var armorTypes:Array = randomChoice(ARMOR_VARIATIONS);
		var tailTypes:Array = randomChoice(TAIL_VARIATIONS);
		var hornTypes:Array = randomChoice(HORN_VARIATIONS);
		var wingTypes:Array = randomChoice(WING_VARIATIONS);
			this.a = "the ";
			this.short = "ghoul";
			this.imageName = "ghoul";
			this.long = "The ghoul is one of the more bizarre things you've seen, with a " + faceTypes[0] + " face, " + armsType[0] + " arms, and a " + legType[0] + " lower body. Its face is complete with " + eyeTypes[0] + " eyes and a " + tongueTypes[0] + " tongue. It also has " + wingTypes[0] + " wings, " + hornTypes[0] + " horns, and a " + tailTypes[0] + " tail above its [ass]. It has " + hairColours[0] + " " + hairTypes[0] + "hair, " + skinColour[0] + " " + skinsType[0] + ", " + hipRate[0] + " hips, and a " + buttRate[0] + " butt. It weilds a " + weaponTypes[0] + " for a weapon and wears " + armorTypes[0] + " as armor.";
			if (rand(2) == 0) {
				this.createCock = (rand(4) + 5,rand(2) + 1,cockTypes[0]);
				this.balls = 2;
				this.ballSize = rand(2) + 1;
				this.createBreastRow = 0,1;
			} else {
				this.createVagina = (vaginaVirgin[0],rand(6) + 1,rand(7) + 1);
				this.createBreastRow = (rand(5) + 1,rand(2) + 1);
			}
			this.ass.analLooseness = ANAL_LOOSENESS_analLoose[0];
			this.ass.analWetness = ANAL_WETNESS_analWet[0];
			
			this.tallness = rand(18) + 59;
			this.hipRating = HIP_RATING_hipRate[0];
			this.buttRating = BUTT_RATING_buttRate[0];
			this.lowerBody = LOWER_BODY_TYPE_legType[0];
			this.armType = ARM_TYPE_armsType[0];

			this.skinTone = "skinColour[0]";
			this.skinType = SKIN_TYPE_skinsType[0];
			if (rand(2) == 0) {
				this.hairColor = hairColours[0];
				this.hairLength = rand(25) + 1;
				this.hairType = HAIR_hairTypes[0];
			} else {
				this.hairLength = 0;
				this.hairType = HAIR_hairTypes[0];
			}
			this.faceType = FACE_faceTypes[0];
			this.earType = EARS_earTypes[0];
			this.tongueType = TONGUE_tongueTypes[0];
			this.eyeType = EYES_eyeTypes[0];

			initStrTouSpeInte(45,30,55,25);
			initLibSensCor(0,0,50);

			this.weaponName = "weaponType[0]";
			this.weaponVerb = "slash";
			this.weaponAttack = rand(4) + 2;

			this.armorName = "armorTypes[0]";
			this.armorDef = rand(5) + 2;

			this.bonusHP = 100;
			this.lust = 0;
			this.lustVuln = 0;
			this.temperment = TEMPERMENT_AVOID_GRAPPLES;
			this.fatigue = 0;

			this.level = 4;
			this.gems = rand(25) + 5;

			this.drop = new WeightedDrop(consumables.ECTOPLS);

			this.special1 = ghoulBlind;
			this.special2 = ghoulMagic;

			if (rand(2) == 0) {
				this.tailType = TAIL_TYPE_tailTypes[0];
			} else {
				this.tailType = TAIL_TYPE_NONE;
			}

			if (rand(2) == 0) {
				this.hornType = HORNS_hornTypes[0];
				this.horns = rand(3) + 2;
			} else {
				this.hornType = HORNS_NONE;
			}

			if (rand(2) == 0) {
				this.wingType = WING_TYPE_wingTypes[0];
			} else {
				this.wingType = WING_TYPE_NONE;
			}

			if (rand(2) == 0) {
				this.antennae = ANTENNAE_BEE;
			} else {
				this.antennae = ANTENNAE_NONE;
			}
			
			checkMonster();
			}
		}
	}
}
asdsa
