package classes.Scenes.NPCs 
{
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    public class NpcContainerTest
    {
        private var cut:NpcContainer;
        private var saveObject:Object;

        [Before]
        public function setUp():void
        {
            saveObject = [];
            cut = new NpcContainer();
        }

        [Test]
        public function noNpcObjectInSave(): void 
        {
            cut.upgradeSerializationVersion(saveObject, 0);

            assertThat(saveObject, hasProperty("npcs"));
        }

        [Test]
        public function noJojoObjectInSave(): void
        {
            cut.upgradeSerializationVersion(saveObject, 0);

            assertThat(saveObject.npcs ,hasProperty("jojo"));
        }

        [Test]
        public function serializationVersion(): void
        {
            assertThat(cut.currentSerializationVerison(), equalTo(1));
        }
    }
}
