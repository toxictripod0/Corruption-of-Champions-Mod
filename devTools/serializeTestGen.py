import argparse

NORMAL = 'normal'
CAPS = 'caps'
TITLE = 'title'


def build_variations(variable):
    variations = {NORMAL: variable, CAPS: variable.upper(), TITLE: variable.capitalize()}

    return variations


def build_constants(const_definition, value):
    return "private static const {0}:int = {1};".format(const_definition, value)


def import_hint():
    return '''/*
* required imports:
* 
import classes.internals.SerializationUtils;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperty;
*/
'''


def build_definitions(class_name):
    return '''private var deserialized: {0};
private var serializedClass: *;
private var cut: {0};
'''.format(class_name)


def build_cut_intit(variations):
    return '''cut.{0} = {1};'''.format(variations[NORMAL], variations[CAPS])

def build_setup(class_name, cut_init):
    setup_test = '''[Before]
public function setUp():void {{
    cut = new {0}();
{1}

    deserialized = new {0}();
    serializedClass = [];
    
    SerializationUtils.serialize(serializedClass, cut);
    SerializationUtils.deserialize(serializedClass, deserialized);
}}
'''
    return setup_test.format(class_name, cut_init)


def build_serialize_test(variations):
    serialize_test = '''[Test]
public function serialize{0}():void
{{
    assertThat(serializedClass, hasProperty("{1}", {2}));
}}
'''
    return serialize_test.format(variations[TITLE], variations[NORMAL], variations[CAPS])


def build_deserialize_test(variations):
    deserialize_test = '''[Test]
public function deserialize{0}():void
{{
    assertThat(deserialized.{1}, equalTo({2}));
}}
'''
    return deserialize_test.format(variations[TITLE], variations[NORMAL], variations[CAPS])


parser = argparse.ArgumentParser()
parser.add_argument('--start-value', '-s', help='The start value to use for constants, default is 1', type=int, action='store', default='1')
parser.add_argument('--setup', help='Generate serialization test variables and setup code, the parameter is the class name', action='store')
parser.add_argument('variable', help='Variables for which tests should be generated', nargs='+', action='store')

args = parser.parse_args()

serialize_tests = []
deserialize_tests = []
cut_init = []
constants = []

constant_value = args.start_value

for var in args.variable:
    variations = build_variations(var)

    constants.append(build_constants(variations[CAPS], constant_value))
    constant_value = constant_value + 1

    serialize_tests.append(build_serialize_test(variations))
    deserialize_tests.append(build_deserialize_test(variations))
    cut_init.append(build_cut_intit(variations))

print('\n'.join(constants) + '\n')
if args.setup is not None:
    print(import_hint())
    print(build_definitions(args.setup))
    print(build_setup(args.setup, '\n'.join(cut_init)))

print('\n'.join(serialize_tests))
print('\n'.join(deserialize_tests))
