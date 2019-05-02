package classes.Scenes.NPCs
{
	import classes.DefaultDict;
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	import org.hamcrest.collection.*;
	
	import classes.helper.StageLocator;
	
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Player;
	import classes.CoC;
	import classes.Cock;
	import classes.PregnancyStore;
	import classes.Scenes.NPCs.IsabellaFollowerScene;
	import classes.PerkLib;
	import classes.CockTypesEnum;
	import classes.helper.FireButtonEvent;
	import classes.CoC;
	import classes.Output;
	
	public class IsabellaFollowerSceneTest 
	{
		private var isabellaScene : IsabellaScene;
		private var cut:IsabellaFollowerSceneForTest;
		private var player:Player;
		private var fireButon:FireButtonEvent;
		
		private static const INCUBATION_DELTA : int = 10;
		/**
		 * This is used to skip time to the last pregnancy stage
		 */
		private static const ADVANCE_PREGNANCY : int = PregnancyStore.INCUBATION_ISABELLA - (IsabellaScene.ISABELLA_PREGNANCY_LAST_STAGE - INCUBATION_DELTA);
		
		public function IsabellaFollowerSceneTest() 
		{
		}
		
		[BeforeClass]
		public static function setUpClass():void {
			kGAMECLASS = new CoC(StageLocator.stage);
		}
		
		private function setUpIsabella() : void {
			isabellaScene = new IsabellaScene();
			cut = new IsabellaFollowerSceneForTest();
		}
		
		[Before]
        public function setUp():void {
			setUpIsabella();
			
			isabellaScene.pregnancy.knockUpForce();
			
			// preggers time!
			isabellaScene.pregnancy.knockUpForce(PregnancyStore.PREGNANCY_PLAYER, PregnancyStore.INCUBATION_ISABELLA)
			
			player = new Player();
			kGAMECLASS.player = player;
			
			fireButon = new FireButtonEvent(kGAMECLASS.mainView, Output.MAX_BUTTON_INDEX);
        }
		
		[Test]
		public function isabellaAppearance_withUnsupportedPregnancyType() : void 
		{
			isabellaScene.pregnancy.knockUpForce()
			isabellaScene.pregnancy.knockUpForce(PregnancyStore.PREGNANCY_IMP, PregnancyStore.INCUBATION_ISABELLA)
			
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_NO_EVENTS_FOR_PREG_TYPE)));
		}
		
		[Test]
		public function isabellaAppearance_playerLowCumQuantity() : void 
		{
			isabellaScene.pregnancy.knockUpForce()
			isabellaScene.pregnancy.knockUpForce(PregnancyStore.PREGNANCY_IMP, PregnancyStore.INCUBATION_ISABELLA)
			
			player.cocks = new Vector.<Cock>();
			assertThat(player.cumQ(), equalTo(0)); // guard assert 

			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, not(hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_PLAYER_HIGH_CUMQ))));
		}
		
		[Test]
		public function isabellaAppearance_playerHighCumQuantity() : void 
		{
			isabellaScene.pregnancy.knockUpForce()
			isabellaScene.pregnancy.knockUpForce(PregnancyStore.PREGNANCY_IMP, PregnancyStore.INCUBATION_ISABELLA)
			//TODO Use mocking library so we can avoid stuff like this
			player.createPerk(PerkLib.FerasBoonSeeder, 0, 0, 0, 0);
			player.createCock(6, 1, CockTypesEnum.HUMAN);
			assertThat(player.cumQ(), greaterThan(500)); // guard assert 
			
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_PLAYER_HIGH_CUMQ)));
		}
		
		[Test]
		public function isabellaAppearance_whenNotPregnant() : void 
		{
			isabellaScene.pregnancy.knockUpForce();
			
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_EVENT_NOT_PREGNANT)));
		}
		
		[Test]
		public function isabellaAppearance_firstStageOfPregnancy() : void 
		{
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_EVENT_FIRST_STAGE_PREGNANT)));
		}
		
		[Test]
		public function isabellaAppearance_playerLowLibido() : void 
		{
			player.lib = 0;
			
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, not(hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_PLAYER_HIGH_LIBIDO))));
		}
		
		[Test]
		public function isabellaAppearance_playerHighLibido() : void 
		{
			player.lib = 100;
			
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, hasItem(equalTo(IsabellaFollowerScene.DESC_APPEAR_PLAYER_HIGH_LIBIDO)));
		}
		
		[Test]
		public function isabellaAppearance_lastStageOfPregnancy() : void 
		{
			for (var i : int = 0; i < ADVANCE_PREGNANCY; i++ ) {
				isabellaScene.pregnancy.pregnancyAdvance();
			}
			
			cut.isaAppearance();
			
			assertThat(cut.collectedOutput, hasItem(containsString(IsabellaFollowerScene.DESC_APPEAR_EVENT_LAST_STAGE_PREGNANT)));
		}
		
		private function createTentaCocks(count:int, length:Number) :void {
			for (var i:int = 0; i < count; i++){
				player.createCock(length, 1, CockTypesEnum.TENTACLE);
			}
		}
		
		[Test]
		public function isabellaTentacleSexNotAvailableWithShortCocks() : void {
			player.lust = 70;
			createTentaCocks(3, 23);
		
			cut.campSexMenu();
			

			assertThat(cut.collectedOutput, not(hasItem(containsString("numerous tentacles"))));
		}
		
		[Test]
		public function isabellaTentacleSex() : void {
			player.lust = 70;
			
			createTentaCocks(3, 24);
		
			cut.campSexMenu();
			fireButon.fireButtonClick(6);

			assertThat(cut.collectedOutput, hasItem(containsString("numerous tentacles")));
			assertThat(cut.collectedOutput, hasItem(containsString("exposing your monstrous tentacle-cocks")));
		}
		
		[Test]
		public function isabellaTentacleSexNotAvailableWithTooFewTentacles() : void {
			player.lust = 70;
			createTentaCocks(2, 24);
		
			cut.campSexMenu();
			

			assertThat(cut.collectedOutput, not(hasItem(containsString("numerous tentacles"))));
		}
	}
}

import classes.Scenes.NPCs.IsabellaFollowerScene;

/**
 * Class to collect scene text output so the test can compare it to expected values.
 */
class IsabellaFollowerSceneForTest extends IsabellaFollowerScene {
	public var collectedOutput:Vector.<String> = new Vector.<String>(); 
	
	override protected function outputText(output:String):void {
		collectedOutput.push(output);
	}
	
	/**
	 * This is to avoid making the appearance function public
	 */
	public function isaAppearance() : void {
		this.isabellasAppearance();
	}
	
	public function campSexMenu() : void {
		this.campIzzySexMenu();	
	}
	
	override protected function isabellasAppearance():void {
		super.isabellasAppearance();
	}
	
	override protected function campIzzySexMenu() : void {
		super.campIzzySexMenu();
	}
 }
