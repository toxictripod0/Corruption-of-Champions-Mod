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
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Scenes.Areas.Desert.*;
	
	public class Ghoul extends Monster {
	
		public var spellCostBlind:int = 8;
		public var spellCostGhoulMagic:int = 12;
	
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
				outputText("The hyena lunges for you, sinking its teeth into you. ", false);
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
				outputText("The hyena slashes its paw at you, raking down hard and causing you to yelp in pain. ", false);
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
			if (!game.combat.ghoulReveal) {
				if (chooser <= 3) hyenaClaw();
				else if (chooser >= 8) hyenaBite();
				else eAttack();
			} else if (game.combat.ghoulReveal) {
				if (chooser < 3) ghoulMagic();
				else if (chooser >= 8) ghoulBlind();
				else eAttack();
			}
		}

		override public function defeated(hpVictory:Boolean):void
		{
			outputText("The ghoul lets out a furious screech as your attacks become too much to bear, and vanishes in a dusty cloud of sand. You're left staring at the spot, wondering if you just hallucinated everything that happened.", false);
			game.combat.cleanupAfterCombat();
			game.combat.ghoulReveal = false;
		}
		
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void
		{
			if(pcCameWorms){
				outputText("\nThe ghoul lets out a disgusted noise and vanishes without a word.", false);
				doNext(game.combat.endLustLoss);
			} else {
				game.desert.ghoulScene.ghoulWon();
			}
			game.combat.ghoulReveal = false;
		}
		
		private const VIRGIN_VARIATIONS:Array = [
			["true"],
			["false"]
		];
		
		private const HIP_VARIATIONS:Array = [
			["boyish"],
			["slender"],
			["average"],
			["ample"],
			["curvy"],
			["fertile"],
			["inhumanly wide"]
		];
		
		private const BUTT_VARIATIONS:Array = [
			["buttless"],
			["tight"],
			["average"],
			["noticeable"],
			["large"],
			["jiggly"],
			["expansive"],
			["huge"],
			["inconceivably big"]
		];
		
		private const LEG_VARIATIONS:Array = [
			["no"],
			["human"],
			["hoofed"],
			["dog"],
			["naga"],
			["demonic high heels"],
			["demonic claws"],
			["bee"],
			["goo"],
			["cat"],
			["lizard"],
			["pony"],
			["bunny"],
			["harpy"],
			["kangaroo"],
			["chitinous spider legs"],
			["drider lower body"],
			["fox"],
			["dragon"],
			["raccoon"],
			["ferret"],
			["cloven hoofed"],
			["echidna"],
			["salamander"],
			["wolf"]
		];
		
		private const ARM_VARIATIONS:Array = [
			["no"],
			["human"],
			["harpy"],
			["spider"],
			["predator"],
			["salamander"],
			["wolf"]
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
			["skin"],
			["fur"],
			["lizard scales"],
			["goo"],
			["dragon scales"]
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
			["transparent"],
			["white and black"],
			["white"]
		];
		
		private const HAIRTYPE_VARIATIONS:Array = [
			["no"],
			["normal"],
			["feather"],
			["ghost"],
			["goo"],
			["anemone"],
			["quill"],
			["basilisk spine"],
			["basilisk plume"]
		];
		
		private const FACE_VARIATIONS:Array = [
			["no"],
			["human"],
			["horse"],
			["dog"],
			["cow"],
			["minotaur"],
			["shark with shark teeth"],
			["snake with snake fangs"],
			["cat"],
			["lizard"],
			["bunny"],
			["kangaroo"],
			["spider with spider fangs"],
			["fox"],
			["dragon"],
			["raccoon mask"],
			["raccoon"],
			["mouse-like with buckteeth"],
			["mouse"],
			["ferret mask"],
			["ferret"],
			["pig"],
			["boar"],
			["rhino"],
			["echidna"],
			["deer"],
			["wolf"]
		];
		
		private const EARS_VARIATIONS:Array = [
			["no"],
			["human"],
			["horse"],
			["dog"],
			["cow"],
			["elvin"],
			["cat"],
			["lizard"],
			["bunny"],
			["kangaroo"],
			["fox"],
			["dragon"],
			["raccoon"],
			["mouse"],
			["ferret"],
			["pig"],
			["rhino"],
			["echidna"],
			["deer"],
			["wolf"]
		];
		
		private const TONGUE_VARIATIONS:Array = [
			["no"],
			["human"],
			["snake"],
			["demonic"],
			["draconic"],
			["echidna"],
			["lizard"]
		];
		
		private const EYES_VARIATIONS:Array = [
			["no"],
			["human"],
			["four spider"],
			["black Sand Trap"],
			["lizard"],
			["dragon"],
			["basilisk"],
			["wolf"]
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
			["no"],
			["horse"],
			["dog"],
			["demonic"],
			["cow"],
			["spider adbomen"],
			["bee abdomen"],
			["shark"],
			["cat"],
			["lizard"],
			["rabbit"],
			["harpy"],
			["kangaroo"],
			["fox"],
			["draconic"],
			["raccoon"],
			["mouse"],
			["ferret"],
			["behemoth"],
			["pig"],
			["scorpion"],
			["goat"],
			["rhino"],
			["echidna"],
			["deer"],
			["salamander"],
			["wolf"]
		];
		
		private const HORN_VARIATIONS:Array = [
			["demon"],
			["cow"]
			["minotaur"],
			["2 draconic"],
			["4, 12-inch long draconic"],
			["antlers"],
			["goat"],
			["unicorn"],
			["rhino"]
		];
		
		private const WING_VARIATIONS:Array = [
			["no"],
			["small, bee-like"],
			["large, bee-like"],
			["harpy"],
			["imp"],
			["large imp"],
			["tiny bat-like"],
			["large bat-like"],
			["shark fin"],
			["large, feathered"],
			["small, draconic"],
			["large, draconic"],
			["giant dragonfly"]
		];
		
		public function Ghoul() {
			if (game.combat.ghoulReveal) {
					var vaginaVirgin:Array = randomChoice(VIRGIN_VARIATIONS);
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
				this.long = "The ghoul is one of the more bizarre things you've seen, with a " + faceTypes[0] + " face, " + armsType[0] + " arms, and a " + legType[0] + " lower body. Its face is complete with " + eyeTypes[0] + " eyes and a " + tongueTypes[0] + " tongue. It also has " + wingTypes[0] + " wings, " + hornTypes[0] + " horns, and a " + tailTypes[0] + " tail above its [ass]. It has " + hairColours[0] + " " + hairTypes[0] + " hair, " + skinColour[0] + " " + skinsType[0] + ", " + hipRate[0] + " hips, and a " + buttRate[0] + " butt. It weilds a " + weaponTypes[0] + " for a weapon and wears " + armorTypes[0] + " as armor.";
				if (rand(2) == 0) {
					this.createCock(rand(4) + 5, rand(2) + 1, CockTypesEnum.DISPLACER);
					this.balls = 2;
					this.ballSize = rand(2) + 1;
					this.createBreastRow();
				} else {
					this.createVagina(vaginaVirgin[0], rand(6) + 1, rand(7) + 1);
					this.createBreastRow(rand(5) + 1, rand(2) + 1);
				}
				this.ass.analLooseness = rand(5);
				this.ass.analWetness = rand(5);
				
				this.pronoun1 = "it";
				this.pronoun2 = "it";
				this.pronoun3 = "its";
				
				this.tallness = rand(18) + 59;
				this.hipRating = rand(20);
				this.buttRating = rand(20);
				this.lowerBody = rand(26);
				this.armType = rand(6);

				this.skinTone = "skinColour[0]";
				this.skinType = rand(5);
				this.hairLength = rand(25) + 0;
					if (this.hairLength > 0) {
						this.hairColor = "hairColours[0]";
						this.hairType = rand(7) + 1;
					} else {
						this.hairType = HAIR_NORMAL;
					}
				this.faceType = rand(24);
				this.earType = rand(18);
				this.tongueType = rand(5);
				this.eyeType = rand(6);

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

				this.tailType = rand(26);
				this.horns = rand(4);
					if (this.horns > 0) {
						this.hornType = rand(8);
					} else {
						this.hornType = HORNS_NONE;
					}
				this.wingType = rand(13);
				this.antennae = rand(2);
				
				checkMonster();
			} else if (!game.combat.ghoulReveal) {
				this.a = "the ";
				this.short = "hyena";
				this.imageName = "ghoulhyena";
				this.long = "The hyena appears to be a regular spotted hyena, with pale brown fur covered in dark brown spots. Its forequarters are strong and muscular while its hindquarters are notably underdeveloped in comparison. It has a flat snout ending in a black nose, and curved, erect ears tipped in black. Its eyes watch you closely in case you try any sudden movements. There seem to be no other hyenas in sight, and you can't stop thinking about how odd it is that there's even a hyena in a desert.";
				if (rand(2) == 0) {
					this.createCock(6,1,CockTypesEnum.DOG);
					this.balls = 2;
					this.ballSize = 1;
					this.createBreastRow();
				} else {
					this.createVagina(false,2,2);
					this.createBreastRow(2,1);
					this.createBreastRow(2,1);
					this.createBreastRow(2,1);
				}
				this.ass.analLooseness = ANAL_LOOSENESS_NORMAL;
				this.ass.analWetness = ANAL_WETNESS_DRY;
				
				this.pronoun1 = "it";
				this.pronoun2 = "it";
				this.pronoun3 = "its";
				
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
				}
			}
	}
}
