package classes
{
	import classes.BodyParts.*;
	import classes.CoC;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.PerkLib;
	import classes.Player;
	import classes.helper.StageLocator;
	import classes.internals.IRandomNumber;
	import classes.internals.RandomNumber;
	import classes.lists.BreastCup;
	import classes.lists.Gender;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;

	public class PlayerTest 
	{
		private const MAX_SUPPORTED_VAGINAS:Number = 2;

		private var impPlayer:Player;
		private var minoPlayer:Player;
		private var cowPlayer:Player;

		private function createVaginas(numberOfVaginas:Number, instance:Player):void
		{
			for(var i:Number = 0; i < numberOfVaginas; i++) {
				instance.createVagina();
			}
		}

		private function createMaxVaginas(instance:Player):void
		{
			createVaginas(MAX_SUPPORTED_VAGINAS, instance);
		}

		private function removeExtraBreastRows(instance:Player):void
		{
			if (instance.breastRows.length <= 1)
				return;

			instance.removeBreastRow(1, instance.breastRows.length - 1);
		}

		private function removeAllBreasts(instance:Player):void
		{
			if (instance.breastRows.length === 0) {
				instance.createBreastRow();
				return;
			}

			removeExtraBreastRows(instance);
			instance.breastRows[0].breastRating = BreastCup.FLAT;
		}

		private function removeAllVags(instance:Player):void
		{
			if (instance.vaginas.length === 0)
				return;

			instance.removeVagina(0, instance.vaginas.length);
		}

		private function createPerk(perk:PerkType, instance:Player):void
		{
			instance.createPerk(perk, 1, 1, 1, 1);
		}

		private function createStatusEffect(stype:StatusEffectType, instance:Player):void
		{
			if (!instance.hasStatusEffect(stype))
				instance.createStatusEffect(stype, 1, 1, 1, 1);
		}

		[BeforeClass]
		public static function setUpClass():void
		{
			/* Hidden dependencies on global variables can cause tests to fail spectacularly.
			 * 
			 * Seriously people, DONT use global variables.
			 */

			kGAMECLASS = new CoC(StageLocator.stage);
		}

		[Before]
		public function setUp():void
		{
			impPlayer = new Player();
			impPlayer.createBreastRow();
			impPlayer.ears.type = Ears.IMP;
			impPlayer.tail.type = Tail.IMP;
			impPlayer.wings.type = Wings.IMP;
			impPlayer.wings.type = Wings.IMP_LARGE;
			impPlayer.lowerBody.type = LowerBody.IMP;
			impPlayer.skin.type = Skin.PLAIN;
			impPlayer.skin.tone = "red";
			impPlayer.horns.type = Horns.IMP;
			impPlayer.arms.type = Arms.PREDATOR;
			impPlayer.claws.type = Claws.IMP;

			minoPlayer = new Player();
			minoPlayer.face.type = Face.COW_MINOTAUR;
			minoPlayer.ears.type = Ears.COW;
			minoPlayer.tail.type = Tail.COW;
			minoPlayer.horns.type = Horns.COW_MINOTAUR;
			minoPlayer.lowerBody.type = LowerBody.HOOFED;
			minoPlayer.tallness = 100;
			minoPlayer.createCock(5.5, 1, CockTypesEnum.HORSE);

			cowPlayer = new Player();
			cowPlayer.ears.type = Ears.COW;
			cowPlayer.tail.type = Tail.COW;
			cowPlayer.horns.type = Horns.COW_MINOTAUR;
			cowPlayer.lowerBody.type = LowerBody.HOOFED;
			cowPlayer.tallness = 73;
			cowPlayer.createVagina();
			cowPlayer.createBreastRow(5);
			cowPlayer.breastRows[0].lactationMultiplier = 3;
		}

		[Test]
		public function testRedPandaScore():void
		{
			var redPandaPlayer:Player = new Player();
			redPandaPlayer.ears.type = Ears.RED_PANDA;
			redPandaPlayer.tail.type = Tail.RED_PANDA;
			redPandaPlayer.arms.type = Arms.RED_PANDA;
			redPandaPlayer.face.type = Face.RED_PANDA;
			redPandaPlayer.lowerBody.type = LowerBody.RED_PANDA;
			redPandaPlayer.skin.type = Skin.FUR;
			redPandaPlayer.underBody.type = UnderBody.FURRY;
			redPandaPlayer.underBody.skin.type = Skin.FUR;

			assertThat(redPandaPlayer.redPandaScore(), greaterThan(0));
		}

		[Test]
		public function testCockatriceScore():void
		{
			var cockatricePlayer:Player = new Player();
			cockatricePlayer.ears.type = Ears.COCKATRICE;
			cockatricePlayer.tail.type = Tail.COCKATRICE;
			cockatricePlayer.lowerBody.type = LowerBody.COCKATRICE;
			cockatricePlayer.face.type = Face.COCKATRICE;
			cockatricePlayer.eyes.type = Eyes.COCKATRICE;
			cockatricePlayer.arms.type = Arms.COCKATRICE;
			cockatricePlayer.antennae.type = Antennae.COCKATRICE;
			cockatricePlayer.neck.type = Neck.COCKATRICE;
			cockatricePlayer.tongue.type = Tongue.LIZARD;
			cockatricePlayer.wings.type = Wings.FEATHERED_LARGE;
			cockatricePlayer.skin.type = Skin.LIZARD_SCALES;
			cockatricePlayer.underBody.type = UnderBody.COCKATRICE;
			cockatricePlayer.createCock(5.5, 1, CockTypesEnum.LIZARD);

			assertThat(cockatricePlayer.cockatriceScore(), greaterThan(0));
		}

		[Test]
		public function testNormalImpScore():void
		{
			removeAllBreasts(impPlayer);
			impPlayer.tallness = 30;

			assertThat(impPlayer.impScore(), greaterThan(0));
		}

		[Test]
		public function testTitsImpScore():void
		{
			removeAllBreasts(impPlayer);
			impPlayer.tallness = 50;
			impPlayer.breastRows[0].breastRating = 5;
			impPlayer.createBreastRow(5);
			impPlayer.createBreastRow(5);
			impPlayer.createBreastRow(5);

			assertThat(impPlayer.impScore(), greaterThan(0));
		}

		[Test]
		public function testDemonScore():void
		{
			var demonPlayer:Player = new Player();
			demonPlayer.horns.type = Horns.DEMON;
			demonPlayer.horns.value = 12;
			demonPlayer.tail.type = Tail.DEMONIC;
			demonPlayer.wings.type = Wings.BAT_LIKE_LARGE;
			demonPlayer.skin.type = Skin.PLAIN;
			demonPlayer.cor = 100;
			demonPlayer.face.type = Face.HUMAN;
			demonPlayer.lowerBody.type = LowerBody.DEMONIC_CLAWS;
			demonPlayer.createCock(5.5, 1, CockTypesEnum.DEMON);

			assertThat(demonPlayer.demonScore(), greaterThan(0));
		}

		[Test]
		public function testHumanScore():void
		{
			var humanPlayer:Player = new Player();
			humanPlayer.face.type = Face.HUMAN;
			humanPlayer.skin.type = Skin.PLAIN;
			humanPlayer.horns.type = Horns.NONE;
			humanPlayer.tail.type = Tail.NONE;
			humanPlayer.wings.type = Wings.NONE;
			humanPlayer.lowerBody.type = LowerBody.HUMAN;
			humanPlayer.skin.type = Skin.PLAIN;
			humanPlayer.createCock(5.5, 1, CockTypesEnum.HUMAN);
			removeAllBreasts(humanPlayer); // auto-creates a breast row, if none exists

			assertThat(humanPlayer.humanScore(), greaterThan(0));
		}

		[Test]
		public function testMinoScore():void
		{
			removeAllVags(minoPlayer);

			assertThat(minoPlayer.minoScore(), greaterThan(0));
		}


		[Test]
		public function testVagMinoScore():void
		{
			minoPlayer.createVagina();

			assertThat(minoPlayer.minoScore(), greaterThan(0));
		}

		[Test]
		public function testCowScore():void
		{
			cowPlayer.face.type = Face.HUMAN;

			assertThat(cowPlayer.cowScore(), greaterThan(0));
		}

		[Test]
		public function testCowFaceCowScore():void
		{
			cowPlayer.face.type = Face.COW_MINOTAUR;

			assertThat(cowPlayer.cowScore(), greaterThan(0));
		}

		[Test]
		public function testSandTrapScore():void
		{
			var sandTrapPlayer:Player = new Player();
			createStatusEffect(StatusEffects.BlackNipples, sandTrapPlayer);
			createStatusEffect(StatusEffects.Uniball, sandTrapPlayer);
			sandTrapPlayer.createVagina();
			sandTrapPlayer.vaginaType(5);
			sandTrapPlayer.eyes.type = Eyes.BLACK_EYES_SAND_TRAP;
			sandTrapPlayer.wings.type = Wings.GIANT_DRAGONFLY;

			assertThat(sandTrapPlayer.sandTrapScore(), greaterThan(0));
		}

		[Test]
		public function testLizardScore():void
		{
			var lizardPlayer:Player = new Player();
			lizardPlayer.face.type = Face.LIZARD;
			lizardPlayer.ears.type = Ears.LIZARD;
			lizardPlayer.tail.type = Tail.LIZARD;
			lizardPlayer.lowerBody.type = LowerBody.LIZARD;
			lizardPlayer.horns.type = Horns.DRACONIC_X4_12_INCH_LONG;
			lizardPlayer.arms.type = Arms.PREDATOR;
			lizardPlayer.claws.type = Claws.LIZARD;
			lizardPlayer.tongue.type = Tongue.LIZARD;
			lizardPlayer.createCock(5.5, 1, CockTypesEnum.LIZARD);
			lizardPlayer.createCock(5.5, 1, CockTypesEnum.LIZARD);
			lizardPlayer.eyes.type = Eyes.LIZARD;
			lizardPlayer.skin.type = Skin.LIZARD_SCALES;

			assertThat(lizardPlayer.lizardScore(), greaterThan(0));
		}
	}
}
