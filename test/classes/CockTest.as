package classes{
    import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	
	import classes.Cock;
	import classes.CockTypesEnum;
	
	public class CockTest {
		private static const DEFAULT_COCK_TYPE:CockTypesEnum = CockTypesEnum.HUMAN;
		private static const DEFAULT_COCK_LENGTH:Number = 5.5;
		private static const DEFAULT_COCK_THICKNESS:Number = 1;
		private static const DEFAULT_KNOT_MULTIPLIER:Number = 1;
		
		private var cut:Cock;
		private var serializedClass:*;

		[Before]
		public function setUp():void {
			cut = new Cock();
			
			serializedClass = [];
		}
		
		[Test] 
		public function testDefaultHumanCockType():void {
			assertThat(cut.cockType, equalTo(DEFAULT_COCK_TYPE));
		}
		
		[Test] 
		public function testDefaultLength():void {
			assertThat(cut.cockLength, equalTo(DEFAULT_COCK_LENGTH));
		}
		
		[Test] 
		public function testDefaultThickness():void {
			assertThat(cut.cockThickness, equalTo(DEFAULT_COCK_THICKNESS));
		}
		
		[Test] 
		public function testDefaultNotPierced():void {
			assertThat(cut.isPierced, equalTo(false));
		}
		
		[Test] 
		public function testDefaultKnotMultiplier():void {
			assertThat(cut.knotMultiplier, equalTo(DEFAULT_KNOT_MULTIPLIER));
		}
	}
}
