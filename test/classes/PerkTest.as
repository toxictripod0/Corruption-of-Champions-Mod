package classes
{
	import classes.internals.SerializationUtils;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.number.isNumber;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.notNullValue;
	
	public class PerkTest
	{
		private static const PTYPE:PerkType = PerkLib.Agility;
		private static const VALUE1:int = 6;
		private static const VALUE2:int = 7;
		private static const VALUE3:int = 8;
		private static const VALUE4:int = 9;
		
		private var deserialized:Perk;
		private var serializedClass:*;
		private var serializedNaNValues:*;
		
		private var cut:Perk;
		private var defaultConstructor:Perk;
		
		//TODO add test that loaded NaN values are converted to 0
		
		private function cleanSerializaton(): void
		{
			serializedClass = [];
			deserialized = new Perk();
		}
		
		[Before]
		public function setUp():void
		{
			cut = new Perk(PTYPE);
			defaultConstructor = new Perk();
			
			cut.value1 = VALUE1;
			cut.value2 = VALUE2;
			cut.value3 = VALUE3;
			cut.value4 = VALUE4;
			
			serializedNaNValues = [];
			serializedNaNValues.id = "JustNaN";
			serializedNaNValues.value1 = NaN;
			serializedNaNValues.value2 = NaN;
			serializedNaNValues.value3 = NaN;
			serializedNaNValues.value4 = NaN;
			
			deserialized = new Perk();
			serializedClass = [];
			
			SerializationUtils.serialize(serializedClass, cut);
			
			delete serializedClass["serializationVersion"];
			
			SerializationUtils.deserialize(serializedClass, deserialized);
		}
		
		[Test]
		public function defaultPerkTypeIsNothing():void
		{
			assertThat(defaultConstructor.ptype.id, equalTo(Perk.NOTHING.id));
		}
		
		[Test]
		public function defaultPerkValue1():void
		{
			assertThat(defaultConstructor.value1, equalTo(0));
		}
		
		[Test]
		public function defaultPerkValue2():void
		{
			assertThat(defaultConstructor.value2, equalTo(0));
		}
		
		[Test]
		public function defaultPerkValue3():void
		{
			assertThat(defaultConstructor.value3, equalTo(0));
		}
		
		[Test]
		public function defaultPerkValue4():void
		{
			assertThat(defaultConstructor.value4, equalTo(0));
		}
		
		[Test]
		public function serializePtype():void
		{
			assertThat(serializedClass, hasProperty("id", PTYPE.id));
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
		public function deserializePtype():void
		{
			assertThat(deserialized.ptype, equalTo(PTYPE));
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
		public function upgradeFixesHistoryPerk():void
		{
			serializedClass = [];
			serializedClass["id"] = "History: Whote";
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.ptype.id, equalTo("History: Whore"));
		}
		
		[Test]
		public function upgradeFixesLustyPerk():void
		{
			serializedClass = [];
			serializedClass["id"] = "LustyRegeneration";
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.ptype.id, equalTo("Lusty Regeneration"));
		}
		
		[Test]
		public function upgradePerkNameToId():void
		{
			serializedClass = [];
			serializedClass["perkName"] = PerkLib.Agility.id;

			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.ptype.id, equalTo(PerkLib.Agility.id));
		}
		
		[Test]
		public function upgradeConvertsNaNtoZeroValue1():void
		{
			SerializationUtils.deserialize(serializedNaNValues, deserialized);
			
			assertThat(deserialized.value1, equalTo(0));
		}
		
		[Test]
		public function upgradeConvertsNaNtoZeroValue2():void
		{
			SerializationUtils.deserialize(serializedNaNValues, deserialized);
			
			assertThat(deserialized.value2, equalTo(0));
		}
		
		[Test]
		public function upgradeConvertsNaNtoZeroValue3():void
		{
			SerializationUtils.deserialize(serializedNaNValues, deserialized);
			
			assertThat(deserialized.value3, equalTo(0));
		}
		
		[Test]
		public function upgradeConvertsNaNtoZeroValue4():void
		{
			SerializationUtils.deserialize(serializedNaNValues, deserialized);
			
			assertThat(deserialized.value4, equalTo(0));
		}
		
		[Test]
		public function upgradeConvertsNullIdToNothing():void
		{
			serializedClass.id = null;
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.ptype, notNullValue());
			assertThat(deserialized.ptype.id, equalTo(Perk.NOTHING.id));
		}
		
		[Test]
		public function wizardFocusFixOnLoad():void
		{
			cleanSerializaton();
			serializedClass["id"] = PerkLib.WizardsFocus.id;
			serializedClass["value1"] = NaN;
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(serializedClass.value1, equalTo(0.3));
		}
		
		[Test]
		public function wizardFocusFix2OnLoad():void
		{
			cleanSerializaton();
			
			serializedClass["id"] = PerkLib.WizardsFocus.id;
			serializedClass["value1"] = 0.05;
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.value1, equalTo(0.5));
		}
		
		[Test]
		public function elvenBountyFixOnLOad():void
		{
			cleanSerializaton();
			
			serializedClass["id"] = PerkLib.ElvenBounty.id;
			serializedClass["value1"] = 15;
			serializedClass["value2"] = 0;
			
			SerializationUtils.deserialize(serializedClass, deserialized);
			
			assertThat(deserialized.value1, equalTo(0));
			assertThat(deserialized.value2, equalTo(15));
		}
	}
}
