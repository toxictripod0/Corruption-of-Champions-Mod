package classes
{
	import classes.internals.SerializationUtils;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;
	
	public class KeyItemTest
	{
		
		private static const KEYNAME:String = "one";
		private static const VALUE1:Number = 2;
		private static const VALUE2:Number = 3;
		private static const VALUE3:Number = 4;
		private static const VALUE4:Number = 5;
		
		private var deserialized:KeyItem;
		private var serializedClass:*;
		private var cut:KeyItem;
		
		[Before]
		public function setUp():void
		{
			cut = new KeyItem();
			cut.keyName = KEYNAME;
			cut.value1 = VALUE1;
			cut.value2 = VALUE2;
			cut.value3 = VALUE3;
			cut.value4 = VALUE4;
			
			deserialized = new KeyItem();
			serializedClass = [];
			
			SerializationUtils.serialize(serializedClass, cut);
			SerializationUtils.deserialize(serializedClass, deserialized);
		}
		
		[Test]
		public function serializeKeyname():void
		{
			assertThat(serializedClass, hasProperty("keyName", KEYNAME));
		}
		
		[Test]
		public function serializeValue1():void
		{
			assertThat(serializedClass, hasProperty("value1", VALUE1));
		}
		
		[Test]
		public function serializeValue2():void
		{
			assertThat(serializedClass, hasProperty("value2", VALUE2));
		}
		
		[Test]
		public function serializeValue3():void
		{
			assertThat(serializedClass, hasProperty("value3", VALUE3));
		}
		
		[Test]
		public function serializeValue4():void
		{
			assertThat(serializedClass, hasProperty("value4", VALUE4));
		}
		
		[Test]
		public function deserializeKeyname():void
		{
			assertThat(deserialized.keyName, equalTo(KEYNAME));
		}
		
		[Test]
		public function deserializeValue1():void
		{
			assertThat(deserialized.value1, equalTo(VALUE1));
		}
		
		[Test]
		public function deserializeValue2():void
		{
			assertThat(deserialized.value2, equalTo(VALUE2));
		}
		
		[Test]
		public function deserializeValue3():void
		{
			assertThat(deserialized.value3, equalTo(VALUE3));
		}
		
		[Test]
		public function deserializeValue4():void
		{
			assertThat(deserialized.value4, equalTo(VALUE4));
		}
	}
}