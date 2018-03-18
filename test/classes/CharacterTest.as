package classes 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	
	public class CharacterTest 
	{
		private var cut:Character;
		
		[Before]
		public function setUp():void 
		{
			cut = new Character();
			
			cut.knockUpForce(PregnancyStore.PREGNANCY_IMP, PregnancyStore.INCUBATION_IMP);
			cut.buttKnockUpForce(PregnancyStore.PREGNANCY_DRIDER_EGGS, PregnancyStore.INCUBATION_DRIDER);
		}
		
		[Test]
		public function hasVaginalPregnancy():void {
			assertThat(cut.isPregnant(), equalTo(true));
		}
		
		[Test]
		public function hasAnalPregnancy():void {
			assertThat(cut.isButtPregnant(), equalTo(true));
		}
		
		[Test]
		public function clearVaginalPregnancy():void {
			cut.clearPregnancy();
			
			assertThat(cut.isPregnant(), equalTo(false));
		}
	}
}
