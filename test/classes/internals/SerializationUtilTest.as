package classes.internals
{
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;
	import org.hamcrest.text.*;
	import org.hamcrest.collection.*;
	
	import classes.internals.Serializable;
	import classes.internals.SerializableAMF;
	
	public class SerializationUtilTest
	{
		private static const TEST_INSTANCES:int = 5;
		
		private var testObject:*;
		private var testVector:Vector.<Serializable>;
		private var testAMFVector:Vector.<SerializableAMF>;
		
		public function SerializationUtilTest()
		{
		}
		
		private function buildVector(instances:int):void
		{
			for (var i:int = 0; i < instances; i++)
			{
				testVector.push(new SerializationDummy(i, i + 1));
			}
		}
		
		private function buildAmfVector(instances:int):void
		{
			for (var i:int = 0; i < instances; i++)
			{
				testAMFVector.push(new AMFSerializationDummy(i, i + 1));
			}
		}
		
		[Before]
		public function setUp():void
		{
			testObject = null;
			testVector = new Vector.<Serializable>();
			testAMFVector = new Vector.<SerializableAMF>();
			
			buildVector(TEST_INSTANCES);
			buildAmfVector(TEST_INSTANCES);
		}
		
		[Test]
		public function serializeVectorObjectSize():void
		{
			testObject = SerializationUtils.serializeVector(testVector);
			
			assertThat(testObject, arrayWithSize(TEST_INSTANCES));
		}
		
		[Test]
		public function serializeVectorLastObjectValue():void
		{
			testObject = SerializationUtils.serializeVector(testVector);
			
			assertThat(testObject[TEST_INSTANCES - 1], hasProperties({foo: TEST_INSTANCES - 1, bar: TEST_INSTANCES}));
		}
		
		[Test]
		public function serializeVectorWithAMFObjectSize():void
		{
			testObject = SerializationUtils.serializeVectorWithAMF(testAMFVector);
			
			assertThat(testObject, arrayWithSize(TEST_INSTANCES));
		}
		
		[Test]
		public function serializeVectorWithAMFLastObjectValue():void
		{
			testObject = SerializationUtils.serializeVectorWithAMF(testAMFVector);
			
			assertThat(testObject[TEST_INSTANCES - 1], instanceOf(AMFSerializationDummy));
		}
	}
}

import classes.internals.Serializable;
import classes.internals.SerializableAMF;
import flash.errors.IllegalOperationError;

class SerializationDummy implements Serializable
{
	public var foo:int;
	private var bar:int;
	
	public function SerializationDummy(foo:int, bar:int)
	{
		this.foo = foo;
		this.bar = bar;
	}
	
	public function serialize(relativeRootObject:*):void
	{
		relativeRootObject.foo = foo;
		relativeRootObject.bar = bar;
	}
	
	public function deserialize(relativeRootObject:*):void
	{
		this.foo = relativeRootObject.foo;
		this.bar = relativeRootObject.bar;
	}
}

class AMFSerializationDummy implements SerializableAMF
{
	public var foo:int;
	public var bar:int;
	
	public function AMFSerializationDummy(foo:int, bar:int)
	{
		this.foo = foo;
		this.bar = bar;
	}
}
