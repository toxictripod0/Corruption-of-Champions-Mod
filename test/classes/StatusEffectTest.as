package classes
{
	import classes.StatusEffects.CombatStatusEffect;
	import classes.internals.SerializationUtils;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.nullValue;
	
	public class StatusEffectTest
	{
		
		private static const VALUE1:int = 1;
		private static const VALUE2:int = 2;
		private static const VALUE3:int = 3;
		private static const VALUE4:int = 4;
		private static const DATASTORE:Object = {};
		private static const STATUSAFFECTNAME:String = "foo";
		
		private var deserialized:StatusEffect;
		private var serializedClass:*;
		private var cut:StatusEffect;
		
		[Before]
		public function setUp():void
		{
			cut = new StatusEffect(new StatusEffectType(STATUSAFFECTNAME, CombatStatusEffect, 1));
			cut.value1 = VALUE1;
			cut.value2 = VALUE2;
			cut.value3 = VALUE3;
			cut.value4 = VALUE4;
			cut.dataStore = DATASTORE;
			
			deserialized = new StatusEffect(null);
			serializedClass = [];
			
			SerializationUtils.serialize(serializedClass, cut);
			SerializationUtils.deserialize(serializedClass, deserialized);
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
		public function serializeDatastore():void
		{
			assertThat(serializedClass, hasProperty("dataStore", DATASTORE));
		}
		
		[Test]
		public function serializeStatusaffectname():void
		{
			assertThat(serializedClass, hasProperty("statusAffectName", STATUSAFFECTNAME));
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
		
		[Test]
		public function deserializeDatastore():void
		{
			assertThat(deserialized.dataStore, equalTo(DATASTORE));
		}
		
		[Test]
		public function deserializeStatusaffectname():void
		{
			assertThat(deserialized.stype.id, equalTo(STATUSAFFECTNAME));
		}
		
		[Test]
		public function noArgsConstructorIsNullType():void
		{
			var noArgs:StatusEffect = new StatusEffect();
			
			assertThat(noArgs.stype, nullValue());
		}
	}
}
