package classes{
	import classes.BodyParts.LowerBody;
	import classes.CoC;
	import classes.Creature;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.PerkLib;
	import classes.helper.StageLocator;
	import classes.internals.RandomNumberGenerator;
	import classes.internals.ActionScriptRNG;
	import classes.internals.SerializationUtils;
	import classes.lists.Gender;
	import classes.lists.BreastCup;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	
     
    public class CreatureTest {
		private const MAX_SUPPORTED_VAGINAS:Number = 2;
		private const DEFAULT_CLIT_LENGTH:Number = 0.5;
		private const TEST_CLIT_LENGTH:Number = 3;
		private const CUNT_CHANGE_VALUE:Number = 5;
		private const VAGINAL_LOOSENESS_VALUE:Number = Vagina.LOOSENESS_LOOSE;
		private const VAGINAL_CAPCITY_OFFSET:Number = 2;
		private const VAGINAL_CAPCITY_TEST_DELTA:Number = 2;
		private const RECOVERY_COUNT:Number = 5;
		private const ANAL_LOOSENESS:Number = 1;
		private const ANAL_CAPACITY:Number = 6;
		
		private static const MAX_HP:Number = 370;
		
		private static const XP:int = 7;
		private static const LEVEL:int = 8;
		private static const GEMS:int = 9;
		private static const LUST:int = 10;
		
		private static const FEMININITY:int = 11;
		private static const TALLNESS:int = 12;
		
		private static const BALLS:int = 13;
		private static const CUMMULTIPLIER:int = 14;
		private static const BALLSIZE:int = 15;
		private static const HOURSSINCECUM:int = 16;
		private static const FERTILITY:int = 17;
		private static const NIPPLE_LENGTH:int = 18;
			
		private var cut:Creature;
		private var noVagina:Creature;
		private var oneVagina:Creature;
		private var maxVagina:Creature;
		private var fullEquip:Creature;
		private var alwaysZero:RandomNumberGenerator;
		
		private var deserialized: Creature;
		private var serializedClass: *;
		
		private function createVaginas(numberOfVaginas:Number, instance:Creature):void {
			var i:Number;
			
			for(i=0; i<numberOfVaginas; i++) {
				instance.createVagina();
			}
		}
		
		private function createCocks(cockType:CockTypesEnum, count:int, instance:Creature):void
		{
			var i:int;
			for (i = 0; i < count; i++) {
				instance.createCock(5, 1, cockType);
			}
		}
		
		private function createMaxVaginas(instance:Creature):void {
			createVaginas(MAX_SUPPORTED_VAGINAS, instance);
		}
		
		private function createPerk(perk:PerkType, instance:Creature): void {
			instance.createPerk(perk, 1, 1, 1, 1);
		}
		
		[BeforeClass]
		public static function setUpClass():void {
		 /* Hidden dependencies on global variables can cause tests to fail spectacularly.
		  * 
		  * Seriously people, DONT use global variables.
		  */
		  
			kGAMECLASS = new CoC(StageLocator.stage);
		}
         
        [Before]
        public function setUp():void {
			alwaysZero = new AlwaysZeroRNG();
			
			cut = new Creature();
			cut.rng = alwaysZero;
			cut.ass.analLooseness = ANAL_LOOSENESS;
						cut.tou = 100;
			cut.HP = 1;
			cut.XP = XP;
			cut.level = LEVEL;
			cut.gems = GEMS;
			cut.lust = LUST;
			cut.femininity = FEMININITY;
			cut.tallness = TALLNESS;
			
			cut.balls = BALLS;
			cut.cumMultiplier = CUMMULTIPLIER;
			cut.ballSize = BALLSIZE;
			cut.hoursSinceCum = HOURSSINCECUM;
			cut.fertility = FERTILITY;
			cut.nippleLength = NIPPLE_LENGTH;
			
			deserialized = new Creature();
			serializedClass = [];

			SerializationUtils.serialize(serializedClass, cut);
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			noVagina = new Creature();
			
			oneVagina = new Creature();
			oneVagina.createVagina();
			oneVagina.vaginas[0].recoveryProgress = RECOVERY_COUNT;
			
			maxVagina = new Creature();
			createMaxVaginas(maxVagina);

			for each (var vag:Vagina in maxVagina.vaginas){
				vag.recoveryProgress = RECOVERY_COUNT;		
			}
			
			fullEquip = new Creature();
			fullEquip.createCock();
			fullEquip.createCock();
			fullEquip.createVagina();
			fullEquip.createVagina();
			fullEquip.createBreastRow(BreastCup.B);
			fullEquip.createBreastRow(BreastCup.B);
			fullEquip.balls = 4;
			
			
			// verify created test instances
			assertThat(noVagina.hasVagina(), equalTo(false));
			
			assertThat(oneVagina.hasVagina(), equalTo(true));
			assertThat(oneVagina.vaginas, arrayWithSize(1));
			
			assertThat(maxVagina.hasVagina(),equalTo(true));
			assertThat(maxVagina.vaginas, arrayWithSize(MAX_SUPPORTED_VAGINAS));
			
			assertThat(fullEquip.isHerm(), equalTo(true));
        }  
		
		[Test] 
        public function testValidation():void {
            assertThat(noVagina.validate(), equalTo("Empty 'weaponName'. Empty 'weaponVerb'. Empty 'armorName'. "));  
        }
        	
		[Test] 
        public function testWetnessWithNoVagina():void {
			assertThat(noVagina.wetness(), equalTo(0));
        }
		
		[Test] 
        public function testWetnessWithVagina():void {
			assertThat(oneVagina.wetness(), equalTo(1));
        }
		
		[Test] 
        public function testVaginaTypeWithNoVagina():void {
			assertThat(noVagina.vaginaType(), equalTo(-1));
        }
		
		[Test] 
        public function testVaginaTypeWithVagina():void {
			assertThat(oneVagina.vaginaType(), equalTo(Vagina.HUMAN));
        }
		
		[Test] 
        public function testSetVaginaTypeWithNoVagina():void {
			assertThat(noVagina.vaginaType(Vagina.EQUINE), equalTo(-1));
        }
		
		[Test] 
        public function testSetVaginaTypeWithVagina():void {
			assertThat(oneVagina.vaginaType(Vagina.EQUINE), equalTo(Vagina.EQUINE));
        }
		
		[Test] 
        public function testReadVaginaTypeAfterSet():void {
			oneVagina.vaginaType(Vagina.EQUINE);
			
			assertThat(oneVagina.vaginaType(), equalTo(Vagina.EQUINE));
        }
		
		[Test] 
        public function testLoosenessVaginaWithNoVagina():void {
			assertThat(noVagina.looseness(), equalTo(0));
        }
		
		[Test] 
        public function testLoosenessVaginaWithVagina():void {
			assertThat(oneVagina.looseness(), equalTo(0));
        }
		
		[Test] 
        public function testLoosenessAnus():void {
			assertThat(noVagina.looseness(false), equalTo(0));
        }
		
		[Test] 
        public function testVaginalCapacityNoVagina():void {
			assertThat(noVagina.vaginalCapacity(), equalTo(0));
        }
		
		[Test] 
        public function testVaginalCapacityWithVagina():void {
			assertThat(oneVagina.vaginalCapacity(), equalTo(0));
        }
		
		[Test]
		public function testVaginalCapacityTaurBodyBonus():void {
			oneVagina.lowerBody.legCount = 4;
			assertThat(oneVagina.isTaur(), equalTo(true)); //guard assert
			
			assertThat(oneVagina.vaginalCapacity(), closeTo(55, 0.001));
		}
		
		[Test]
		public function testVaginalCapacityNagaBodyBonus():void {
			oneVagina.lowerBody.type = LowerBody.NAGA;
			assertThat(oneVagina.isNaga(), equalTo(true)); //guard assert
			
			assertThat(oneVagina.vaginalCapacity(), equalTo(22));
		}
		
		[Test]
		public function testVaginalCapacityWetPussyPerkBonus():void {
			oneVagina.createPerk(PerkLib.WetPussy, 1, 1, 1, 1);
			
			assertThat(oneVagina.vaginalCapacity(), equalTo(22));
		}
		
		[Test]
		public function testVaginalCapacityHistorySlutPerkBonus():void {
			oneVagina.createPerk(PerkLib.HistorySlut, 1, 1, 1, 1);
			
			assertThat(oneVagina.vaginalCapacity(), equalTo(22));
		}
		
		[Test]
		public function testVaginalCapacityOneTrackMindPerkBonus():void {
			oneVagina.createPerk(PerkLib.OneTrackMind, 1, 1, 1, 1);
			
			assertThat(oneVagina.vaginalCapacity(), closeTo(10 + VAGINAL_CAPCITY_OFFSET, VAGINAL_CAPCITY_TEST_DELTA));
		}
		
		
		[Test]
		public function testVaginalCapacityCornucopiaPerkBonus():void {
			oneVagina.createPerk(PerkLib.Cornucopia, 1, 1, 1, 1);
			
			assertThat(oneVagina.vaginalCapacity(), closeTo(30 + VAGINAL_CAPCITY_OFFSET, VAGINAL_CAPCITY_TEST_DELTA));
		}
		
		[Test]
		public function testVaginalCapacityFerasBoonWideOpenPerkBonus():void {
			oneVagina.createPerk(PerkLib.FerasBoonWideOpen, 1, 1, 1, 1);
			
			assertThat(oneVagina.vaginalCapacity(), closeTo(25 + VAGINAL_CAPCITY_OFFSET, VAGINAL_CAPCITY_TEST_DELTA));
		}
		
		[Test]
		public function testVaginalCapacityFerasBoonMilkingTwatPerkBonus():void {
			oneVagina.createPerk(PerkLib.FerasBoonMilkingTwat, 1, 1, 1, 1);
			
			assertThat(oneVagina.vaginalCapacity(), closeTo(40 + VAGINAL_CAPCITY_OFFSET, VAGINAL_CAPCITY_TEST_DELTA));
		}
		
		[Test]
		public function testVaginalCapacityBonusVCapacityStatusEffect():void {
			noVagina.createVagina(true, 1, 4);
			noVagina.createStatusEffect(StatusEffects.BonusVCapacity, 1, 1, 1, 1);
			
			assertThat(noVagina.vaginalCapacity(), equalTo(141.9));
		}
		
		[Test]
		public function testVaginalCapacityBasedOnLooseness():void {
			noVagina.createVagina(true, 0, 4);
			
			assertThat(noVagina.vaginalCapacity(), equalTo(128));
		}
		
		[Test]
		public function testVaginalCapacityBasedOnWetness():void {
			noVagina.createVagina(true, 4, 1);
			
			assertThat(noVagina.vaginalCapacity(), equalTo(11.2));
		}
		
		[Test] 
        public function testVaginalCapacityWithVaginaAfterStrech():void {
			oneVagina.cuntChangeNoDisplay(CUNT_CHANGE_VALUE)
			
			assertThat(oneVagina.vaginalCapacity(), equalTo(8.8));
        }
		
		[Test] 
        public function testHasVaginaWithNoVagina():void {
            assertThat(noVagina.hasVagina(), equalTo(false));  
        }
		
		[Test] 
        public function testHasVaginaWithVagina():void {
            assertThat(oneVagina.hasVagina(), equalTo(true));  
        }
		
		[Test] 
        public function testHasVirginVaginaWithNoVagina():void {
            assertThat(noVagina.hasVirginVagina(), equalTo(false));  
        }
		
		[Test] 
        public function testHasVirginVaginaWithVirginVagina():void {
            assertThat(oneVagina.hasVirginVagina(), equalTo(true));  
        }
		
		[Test] 
        public function testHasVirginVaginaWithNonVirginVagina():void {
			assertThat(noVagina.createVagina(false), equalTo(true));
			
            assertThat(noVagina.hasVirginVagina(), equalTo(false));  
        }
		
		[Test] 
        public function testCreateVaginaVirgin():void {
			assertThat(noVagina.createVagina(), equalTo(true));
			
            assertThat(noVagina.hasVirginVagina(), equalTo(true));  
        }
		
		[Test] 
        public function testCreateVaginaNonVirgin():void {
			assertThat(noVagina.createVagina(false), equalTo(true));
			
            assertThat(noVagina.hasVirginVagina(), equalTo(false));  
        }
		
		[Test] 
        public function testCreateVaginaWetness():void {
			assertThat(noVagina.createVagina(true, 3), equalTo(true));
			
            assertThat(noVagina.wetness(), equalTo(3));  
        }
		
		[Test] 
        public function testCreateVaginaLooseness():void {
			assertThat(noVagina.createVagina(true, 1, 3), equalTo(true));
			
            assertThat(noVagina.looseness(), equalTo(3));  
        }
		
		[Test] 
        public function testCreateVaginaMaxVaginas():void {
			assertThat(maxVagina.createVagina(), equalTo(false));
        }
		
		[Test] 
        public function testCreateVaginaMaxVaginasArraySize():void {
			maxVagina.createVagina();
			
			assertThat(maxVagina.vaginas, arrayWithSize(MAX_SUPPORTED_VAGINAS));
        }

		[Test] 
        public function testRemoveVaginaNegativeIndex():void {
			maxVagina.removeVagina(-2);
			
			assertThat(maxVagina.vaginas, arrayWithSize(MAX_SUPPORTED_VAGINAS));
        }
		
		[Test] 
        public function testRemoveVaginaNegativeRemoveCount():void {
			maxVagina.removeVagina(0, -1);
			
			assertThat(maxVagina.vaginas, arrayWithSize(MAX_SUPPORTED_VAGINAS));
        }
		
		[Test] 
        public function testRemoveVaginaIndexToLarge():void {
			maxVagina.removeVagina(MAX_SUPPORTED_VAGINAS + 1);
			
			assertThat(maxVagina.vaginas, arrayWithSize(MAX_SUPPORTED_VAGINAS));
        }
		
		[Test] 
        public function testRemoveVaginaSpecificIndexFirst():void {
			assertThat(noVagina.createVagina(true, 1, 2), equalTo(true));
			assertThat(noVagina.createVagina(true, 1, 3), equalTo(true));
			
			noVagina.removeVagina(0);
			
			assertThat(noVagina.looseness(), equalTo(3));
        }
		
		[Test] 
        public function testRemoveVaginaRemoveLastWithMinusOne():void {
			assertThat(noVagina.createVagina(true, 1, 2), equalTo(true));
			assertThat(noVagina.createVagina(true, 1, 3), equalTo(true));
			
			noVagina.removeVagina(-1);
			
			assertThat(noVagina.looseness(), equalTo(2));
			assertThat(noVagina.vaginas, arrayWithSize(1));
        }
		
		[Test] 
        public function testRemoveVaginaSpecificIndexLast():void {
			assertThat(noVagina.createVagina(true, 1, 2), equalTo(true));
			assertThat(noVagina.createVagina(true, 1, 3), equalTo(true));
			
			noVagina.removeVagina(1);
			
			assertThat(noVagina.looseness(), equalTo(2));
			assertThat(noVagina.vaginas, arrayWithSize(1));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayLoosnessChanged():void {
			assertThat(oneVagina.looseness(), equalTo(0)); // guard assert
			
			oneVagina.cuntChangeNoDisplay(CUNT_CHANGE_VALUE);
			
			assertThat(oneVagina.looseness(), equalTo(1));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayIsStretched():void {
			assertThat(oneVagina.cuntChangeNoDisplay(CUNT_CHANGE_VALUE), equalTo(true)); 
        }
		
		[Test] 
        public function testCuntChangeNoDisplayWithFeraMilkingTwatAndAboveNormalLooseness():void {
			oneVagina.vaginas[0].vaginalLooseness = VAGINAL_LOOSENESS_VALUE;
			oneVagina.createPerk(PerkLib.FerasBoonMilkingTwat, 1, 1, 1, 1);
			
			assertThat(oneVagina.cuntChangeNoDisplay(Number.MAX_VALUE), equalTo(false));
        }
			
		[Test] 
        public function testCuntChangeNoDisplayWithNoFeraMilkingTwatAndAboveNormalLooseness():void {
			oneVagina.vaginas[0].vaginalLooseness = VAGINAL_LOOSENESS_VALUE;
			
			assertThat(oneVagina.cuntChangeNoDisplay(Number.MAX_VALUE), equalTo(true));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayWithFeraMilkingTwatAndNormalLooseness():void {
			oneVagina.createPerk(PerkLib.FerasBoonMilkingTwat, 1, 1, 1, 1);
			
			assertThat(oneVagina.cuntChangeNoDisplay(Number.MAX_VALUE), equalTo(true));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayWithNoFeraMilkingTwatAndNormalLooseness():void {
			assertThat(oneVagina.cuntChangeNoDisplay(Number.MAX_VALUE), equalTo(true));
        }
				
		[Test] 
        public function testFeraMilkingTwatPerkCheck():void {
			oneVagina.createPerk(PerkLib.FerasBoonMilkingTwat, 1, 1, 1, 1);
			
			assertThat(oneVagina.findPerk(PerkLib.FerasBoonMilkingTwat), equalTo(0));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayLooseVaginaNotStretched():void {
			assertThat(noVagina.createVagina(true,1,4), equalTo(true));
			
			assertThat(noVagina.cuntChangeNoDisplay(CUNT_CHANGE_VALUE), equalTo(false)); 
        }
		
		[Test] 
        public function testCuntChangeNoDisplayLoseVirginity():void {
			oneVagina.cuntChangeNoDisplay(CUNT_CHANGE_VALUE);
			
			assertThat(oneVagina.hasVirginVagina(), equalTo(false));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayWithNoVagina():void {
			assertThat(noVagina.cuntChangeNoDisplay(CUNT_CHANGE_VALUE), equalTo(false));
        }
		
		[Test] 
        public function testCuntChangeNoDisplayCuntStretchedRecoveryProgress():void {
			oneVagina.cuntChangeNoDisplay(Number.MAX_VALUE);
			
			assertThat(oneVagina.vaginas[0].recoveryProgress, equalTo(0));
        }
		
		[Test] 

        public function testCuntChangeNoDisplayNoRecoveryProgressIncrease():void {
			oneVagina.cuntChangeNoDisplay(0);
			
			assertThat(oneVagina.vaginas[0].recoveryProgress, equalTo(RECOVERY_COUNT));
        }
		
		[Test] 
        public function testAverageVaginalLoosenessNoVagina():void {
			assertThat(noVagina.averageVaginalLooseness(), equalTo(2));
        }
		
		[Test] 
        public function testAverageVaginalLooseness():void {
			noVagina.createVagina(false, 1, 2);
			noVagina.createVagina(false, 1, 4);
			
			assertThat(noVagina.averageVaginalLooseness(), equalTo(3));
        }
		
		[Test] 
        public function testAverageVaginalWetnessNoVagina():void {
			assertThat(noVagina.averageVaginalWetness(), equalTo(2));
        }
		
		[Test] 
        public function testAverageVaginalWetness():void {
			noVagina.createVagina(false, 2, 1);
			noVagina.createVagina(false, 4, 1);
			
			assertThat(noVagina.averageVaginalWetness(), equalTo(3));
        }
		
		[Test] 
        public function testAllVaginaDescriptOnlyOneVagina():void {
			assertThat(oneVagina.allVaginaDescript(), not(endsWith("s")));
        }
		
		[Test] 
        public function testAllVaginaDescriptOnlyMultipleVaginas():void {
			assertThat(maxVagina.allVaginaDescript(), endsWith("s"));
        }
		
		[Test(expected="flash.errors.IllegalOperationError")] 
        public function setClitLength_noVagina():void {
			noVagina.setClitLength(TEST_CLIT_LENGTH);
        }
		
		[Test(expected="flash.errors.IllegalOperationError")] 
        public function getClitLength_noVagina():void {
			noVagina.getClitLength(TEST_CLIT_LENGTH);
        }
		
		[Test] 
        public function setClitLength_oneVagina():void {
			oneVagina.setClitLength(TEST_CLIT_LENGTH);
			
			assertThat(oneVagina.getClitLength(), equalTo(TEST_CLIT_LENGTH));
        }
		
		[Test] 
        public function getClitLength_oneVagina():void {
			assertThat(oneVagina.getClitLength(), equalTo(Vagina.DEFAULT_CLIT_LENGTH));
        }
		
		[Test] 
        public function setClitLength_multiVagina():void {
			maxVagina.setClitLength(TEST_CLIT_LENGTH, 1);
			
			assertThat(maxVagina.getClitLength(1), equalTo(TEST_CLIT_LENGTH));
        }
		
		[Test] 
        public function getClitLength_multiVagina():void {
			assertThat(maxVagina.getClitLength(1), equalTo(Vagina.DEFAULT_CLIT_LENGTH));
        }
		
				
		[Test(expected="flash.errors.IllegalOperationError")] 
        public function changeClitLength_noVagina():void {
			noVagina.changeClitLength(1);
		}
		
		[Test] 
        public function changeClitLength_increase():void {
			assertThat(oneVagina.changeClitLength(1), equalTo(Vagina.DEFAULT_CLIT_LENGTH + 1));
        }
		
		[Test] 
        public function changeClitLength_decrease():void {
			assertThat(oneVagina.changeClitLength(-0.2), equalTo(Vagina.DEFAULT_CLIT_LENGTH - 0.2));
        }
		
		[Test] 
        public function changeClitLength_noNegativeValues():void {
			assertThat(oneVagina.changeClitLength(-Number.MAX_VALUE), equalTo(0));
        }
		
		[Test(expected="RangeError")] 
        public function changeClitLength_invalid_vagina_index():void {
			oneVagina.changeClitLength(1, int.MAX_VALUE);
        }
		
		[Test]
		public function noGender():void {
			assertThat(noVagina.gender, equalTo(Gender.NONE));
		}
		
		[Test]
		public function genderIsFemale():void {
			assertThat(oneVagina.gender, equalTo(Gender.FEMALE));
		}
		
		[Test]
		public function genderIsMale():void {
			noVagina.createCock(5, 1, CockTypesEnum.HUMAN);
			
			assertThat(noVagina.gender, equalTo(Gender.MALE));
		}
		
		[Test]
		public function genderIsHerm():void {
			noVagina.createCock(5, 1, CockTypesEnum.HUMAN);
			noVagina.createVagina();
			
			assertThat(noVagina.gender, equalTo(Gender.HERM));
		}
		
		[Test]
		public function setNewRng():void {
			var rng:RandomNumberGenerator = new ActionScriptRNG();
			
			cut.rng = rng;
			
			assertThat(cut.rng, strictlyEqualTo(rng))
		}
		
		
		[Test(expected="ArgumentError")]
		public function setNullForRng():void {
			cut.rng = null;
		}
		
		[Test]
		public function analStretchWithAreaGreaterThanCapacity(): void {
			assertThat(cut.buttChangeNoDisplay(ANAL_CAPACITY), equalTo(true));
		}
		
		[Test]
		public function analStretchWithArea80PercentOfCapacity(): void {
			assertThat(cut.buttChangeNoDisplay(ANAL_CAPACITY * 0.8), equalTo(true));
		}
		
		[Test]
		public function analStretchWithArea90PercentOfCapacity(): void {
			assertThat(cut.buttChangeNoDisplay(ANAL_CAPACITY * 0.9), equalTo(true));
		}
		
		[Test]
		public function clearGenderRemovesCock(): void {
			fullEquip.clearGender();
			
			assertThat(fullEquip.hasCock(), equalTo(false));
		}
		
		[Test]
		public function clearGenderRemovesVagina(): void {
			fullEquip.clearGender();
			
			assertThat(fullEquip.hasVagina(), equalTo(false));
		}
		
		[Test]
		public function clearGenderRemovesBreasts(): void {
			fullEquip.clearGender();
			
			assertThat(fullEquip.hasBreasts(), equalTo(false));
		}
		
		[Test]
		public function clearGenderRemovesBalls(): void {
			fullEquip.clearGender();
			
			assertThat(fullEquip.balls, equalTo(0));
		}
		
		[Test]
		public function clearGenderNoBreasts(): void {
			cut.clearGender();
			
			assertThat(cut.hasBreasts(), equalTo(false));
		}
		
		[Test]
		public function healToMaxHP():void {
			cut.restoreHP();

			assertThat(cut.HP, equalTo(MAX_HP));
		}

		[Test]
		public function healByAmount():void {
			cut.restoreHP(1);

			assertThat(cut.HP, equalTo(2));
		}

		[Test]
		public function healOverflowCheck():void {
			cut.HP = 1000;
			
			cut.restoreHP();

			assertThat(cut.HP, equalTo(MAX_HP));
		}
		
		[Test(expected="RangeError")]
		public function healByNegativeAmount():void {
			cut.restoreHP(-1);
		}
		
		[Test]
		public function hasCockNotOfTypeWithNoCock(): void
		{
			assertThat(cut.hasCockNotOfType(CockTypesEnum.HUMAN), equalTo(false));
		}
		
		[Test]
		public function hasCockNotOfTypeWithOneMatchingCock(): void
		{
			cut.createCock(5, 1, CockTypesEnum.HUMAN);
			
			assertThat(cut.hasCockNotOfType(CockTypesEnum.HUMAN), equalTo(false));
		}
		
		[Test]
		public function hasCockNotOfTypeWithManyMatchingCocks(): void
		{
			createCocks(CockTypesEnum.HUMAN, 3, cut);
			
			assertThat(cut.hasCockNotOfType(CockTypesEnum.HUMAN), equalTo(false));
		}
		
		[Test]
		public function hasCockNotOfTypeWithNonMatchingCock(): void
		{
			createCocks(CockTypesEnum.HORSE, 1, cut);
			
			assertThat(cut.hasCockNotOfType(CockTypesEnum.HUMAN), equalTo(true));
		}
		
		[Test]
		public function findFirstCockNotOfTypeWithNoCock(): void
		{
			assertThat(cut.findFirstCockNotOfType(CockTypesEnum.HUMAN), equalTo(-1));
		}
		
		[Test]
		public function findFirstCockNotOfTypeWithMatchingCock(): void
		{
			createCocks(CockTypesEnum.HUMAN, 1, cut);
			
			assertThat(cut.findFirstCockNotOfType(CockTypesEnum.HUMAN), equalTo(-1));
		}
		
		[Test]
		public function findFirstCockNotOfTypeWithNonMatchingCock(): void
		{
			createCocks(CockTypesEnum.HUMAN, 1, cut);
			createCocks(CockTypesEnum.HORSE, 1, cut);
			
			assertThat(cut.findFirstCockNotOfType(CockTypesEnum.HUMAN), equalTo(1));
		}
		
		[Test]
		public function setFirstCockNotOfTypeWithNoCock(): void
		{
			assertThat(cut.setFirstCockNotOfType(CockTypesEnum.HORSE), equalTo(false));
		}
		
		[Test]
		public function setFirstCockNotOfTypeWithMatchingCock(): void
		{
			createCocks(CockTypesEnum.HUMAN, 1, cut);
			
			assertThat(cut.setFirstCockNotOfType(CockTypesEnum.HUMAN), equalTo(false));
		}
		
		[Test]
		public function setFirstCockNotOfTypeWithNonMatchingCockReturnValue(): void
		{
			createCocks(CockTypesEnum.HUMAN, 1, cut);
			
			assertThat(cut.setFirstCockNotOfType(CockTypesEnum.HORSE), equalTo(true));
		}
		
		[Test]
		public function setFirstCockNotOfTypeWithNonMatchingCockType(): void
		{
			createCocks(CockTypesEnum.HUMAN, 1, cut);
			
			cut.setFirstCockNotOfType(CockTypesEnum.HORSE);
			
			assertThat(cut.cocks[0].cockType, equalTo(CockTypesEnum.HORSE));
		}
		
		[Test]
		public function setFirstCockNotOfTypeWithDifferingTypes(): void
		{
			createCocks(CockTypesEnum.HUMAN, 2, cut);
			createCocks(CockTypesEnum.DOG, 2, cut);
			
			cut.setFirstCockNotOfType(CockTypesEnum.HUMAN, CockTypesEnum.HORSE);
			
			assertThat(cut.cocks[0].cockType, equalTo(CockTypesEnum.HUMAN));
			assertThat(cut.cocks[1].cockType, equalTo(CockTypesEnum.HUMAN));
			assertThat(cut.cocks[2].cockType, equalTo(CockTypesEnum.HORSE));
			assertThat(cut.cocks[3].cockType, equalTo(CockTypesEnum.DOG));
		}

		[Test]
		public function findFirstCocktOfTypeFoundType(): void
		{
			createCocks(CockTypesEnum.HUMAN, 2, cut);
			createCocks(CockTypesEnum.DOG, 2, cut);
			
			assertThat(cut.findFirstCockType(CockTypesEnum.DOG), equalTo(2));
		}

		[Test]
		public function findFirstCocktOfTypeNotFound(): void
		{
			createCocks(CockTypesEnum.HUMAN, 2, cut);
			
			assertThat(cut.findFirstCockType(CockTypesEnum.HORSE), equalTo(-1));
		}

		[Test]
		public function serializeLevel():void
		{
			assertThat(serializedClass, hasProperty("level", LEVEL));
		}

		[Test]
		public function serializeGems():void
		{
			assertThat(serializedClass, hasProperty("gems", GEMS));
		}

		[Test]
		public function deserializeXp():void
		{
			assertThat(deserialized.XP, equalTo(XP));
		}

		[Test]
		public function deserializeLevel():void
		{
			assertThat(deserialized.level, equalTo(LEVEL));
		}

		[Test]
		public function deserializeGems():void
		{
			assertThat(deserialized.gems, equalTo(GEMS));
		}

		[Test]
		public function serializeXp():void
		{
			assertThat(serializedClass, hasProperty("XP", XP));
		}

		[Test]
		public function serializeLust():void
		{
			assertThat(serializedClass, hasProperty("lust", LUST));
		}

		[Test]
		public function deserializeLust():void
		{
			assertThat(deserialized.lust, equalTo(LUST));
		}
		
		[Test]
		public function serializeFemininity():void
		{
			assertThat(serializedClass, hasProperty("femininity", FEMININITY));
		}

		[Test]
		public function serializeTallness():void
		{
			assertThat(serializedClass, hasProperty("tallness", TALLNESS));
		}

		[Test]
		public function deserializeFemininity():void
		{
			assertThat(deserialized.femininity, equalTo(FEMININITY));
		}
		
		[Test]
		public function deserializeFemininityUndefined():void
		{
			delete(serializedClass.femininity);
			deserialized = new Creature();
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.femininity, equalTo(50));
		}

		[Test]
		public function deserializeTallness():void
		{
			assertThat(deserialized.tallness, equalTo(TALLNESS));
		}
		
		[Test]
		public function serializeBalls():void
		{
			assertThat(serializedClass, hasProperty("balls", BALLS));
		}

		[Test]
		public function serializeCummultiplier():void
		{
			assertThat(serializedClass, hasProperty("cumMultiplier", CUMMULTIPLIER));
		}

		[Test]
		public function serializeBallsize():void
		{
			assertThat(serializedClass, hasProperty("ballSize", BALLSIZE));
		}

		[Test]
		public function serializeHourssincecum():void
		{
			assertThat(serializedClass, hasProperty("hoursSinceCum", HOURSSINCECUM));
		}

		[Test]
		public function serializeFertility():void
		{
			assertThat(serializedClass, hasProperty("fertility", FERTILITY));
		}

		[Test]
		public function deserializeBalls():void
		{
			assertThat(deserialized.balls, equalTo(BALLS));
		}

		[Test]
		public function deserializeCummultiplier():void
		{
			assertThat(deserialized.cumMultiplier, equalTo(CUMMULTIPLIER));
		}

		[Test]
		public function deserializeBallsize():void
		{
			assertThat(deserialized.ballSize, equalTo(BALLSIZE));
		}

		[Test]
		public function deserializeHourssincecum():void
		{
			assertThat(deserialized.hoursSinceCum, equalTo(HOURSSINCECUM));
		}

		[Test]
		public function deserializeFertility():void
		{
			assertThat(deserialized.fertility, equalTo(FERTILITY));
		}
		
		[Test]
		public function serializeNippleLength():void
		{
			assertThat(serializedClass, hasProperty("nippleLength", NIPPLE_LENGTH));
		}
		
		[Test]
		public function deserializeNippleLength():void
		{
			assertThat(deserialized.nippleLength, equalTo(NIPPLE_LENGTH));
		}
		
		[Test]
		public function deserializeNippleLengthUndefined():void
		{
			delete(serializedClass.nippleLength);
			deserialized = new Creature();
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.nippleLength, equalTo(0.25));
		}
	}
}

import classes.internals.RandomNumberGenerator;

class AlwaysZeroRNG implements RandomNumberGenerator {
	public function random(max:int):int 
	{
		return 0;
	}
	
	public function randomCorrected(max:int):int 
	{
		return 0;
	}
}
