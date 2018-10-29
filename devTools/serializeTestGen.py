import argparse

NORMAL = 'normal'
CAPS = 'caps'
TITLE = 'title'


def build_variations(variable):
    variations = {NORMAL: variable, CAPS: variable.upper(), TITLE: variable.capitalize()}

    return variations


def build_constants(const_definition, value):
    return "private static const {0}:int = {1};".format(const_definition, value)


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
parser.add_argument('variable', help='Variables for which tests should be generated', nargs='+', action='store')

args = parser.parse_args()

serialize_tests = []
deserialize_tests = []
constants = []

constant_value = 0

for var in args.variable:
    variations = build_variations(var)

    constants.append(build_constants(variations[CAPS], constant_value))
    constant_value = constant_value + 1

    serialize_tests.append(build_serialize_test(variations))
    deserialize_tests.append(build_deserialize_test(variations))

print('\n'.join(constants) + '\n')
print('\n'.join(serialize_tests))
print('\n'.join(deserialize_tests))
