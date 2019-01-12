package classes 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	
	public class PerkTest 
	{
		private var cut:Perk;
		
		[Before]
		public function setUp():void
		{
			cut = new Perk();
		}
		
		[Test]
		public function defaultPerkTypeIsNothing():void
		{
			assertThat(cut.ptype.id, equalTo(Perk.NOTHING.id));
		}
		
		[Test]
		public function defaultPerkValue1():void
		{
			assertThat(cut.value1, equalTo(0));
		}
		
		[Test]
		public function defaultPerkValue2():void
		{
			assertThat(cut.value2, equalTo(0));
		}
		
		[Test]
		public function defaultPerkValue3():void
		{
			assertThat(cut.value3, equalTo(0));
		}
		
		[Test]
		public function defaultPerkValue4():void
		{
			assertThat(cut.value4, equalTo(0));
		}
	}
}
