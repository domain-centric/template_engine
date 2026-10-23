import 'package:template_engine/template_engine.dart';

final standardMapMethods = <MethodDefinition<Map, dynamic>>[
  _lengthMethod,
  _isEmptyMethod,
  _isNotEmptyMethod,
  _keysMethod,
  _valuesMethod,
  _getMethod,
  _clearMethod,
  _putMethod,
  _removeMethod,
];

final _lengthMethod = MethodDefinition<Map, num>(
  name: 'length',
  parameters: [],
  method: (context) => Future.value(context.owner.length),

  description: 'Returns the number of key, value pairs in a Map',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.length()${delimiter.end}',
      variables: {
        'items': {
          'numbers': {4, 5, 7},
          'words': {'apple', 'banana'},
        },
      },
      shouldRender: "2",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/length_test.dart',
    ),
  ],
);

final _isEmptyMethod = MethodDefinition<Map, bool>(
  name: 'isEmpty',
  parameters: [],
  method: (context) => Future.value(context.owner.isEmpty),

  description: 'Returns true if the Map is empty, false otherwise',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.isEmpty()${delimiter.end}',
      variables: {'items': {}},
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/is_empty_test.dart',
    ),
  ],
);

final _isNotEmptyMethod = MethodDefinition<Map, bool>(
  name: 'isNotEmpty',
  parameters: [],
  method: (context) => Future.value(context.owner.isNotEmpty),

  description: 'Returns true if the Map is not empty, false otherwise',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.isNotEmpty()${delimiter.end}',
      variables: {
        'items': {'key': 'value'},
      },
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/is_not_empty_test.dart',
    ),
  ],
);

final _keysMethod = MethodDefinition<Map, Set>(
  name: 'keys',
  parameters: [],
  method: (context) => Future.value(context.owner.keys.toSet()),

  description: 'Returns the keys of a Map as a Set',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.keys()${delimiter.end}',
      variables: {
        'items': {'1stKey': 1, '2ndKey': 2, '3rdKey': 3},
      },
      shouldRender: "{1stKey, 2ndKey, 3rdKey}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/keys_test.dart',
    ),
  ],
);

final _valuesMethod = MethodDefinition<Map, List>(
  name: 'values',
  parameters: [],
  method: (context) => Future.value(context.owner.values.toList()),

  description: 'Returns the values of a Map as a List',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.values()${delimiter.end}',
      variables: {
        'items': {'1stKey': 1, '2ndKey': 2, '3rdKey': 3},
      },
      shouldRender: "[1, 2, 3]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/values_test.dart',
    ),
  ],
);

final _getMethod = MethodDefinition<Map, dynamic>(
  name: 'get',
  parameters: [
    Parameter<Object>(
      name: 'key',
      description: 'The key of the item in the Map that we want to get',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var map = context.owner;
    var key = context.argumentValues['key'];

    if (!map.containsKey(key)) {
      context.addWarning(
        'Key not found: `$key`',
        context.argumentLocations['key']!,
      );
      return Future.value(null);
    }
    return Future.value(map[key]);
  },
  description:
      'Gets the value of an item in the Map using a given key. '
      'If the key does not exist, null is returned.',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}properties.get("age")${delimiter.end}',
      variables: {
        'properties': {'name': 'James', 'age': 30, 'city': 'New York'},
      },
      shouldRender: "30",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/get_test.dart',
    ),
  ],
);

final _clearMethod = MethodDefinition<Map, void>(
  name: 'clear',
  parameters: [],
  method: (context) {
    context.owner.clear();
    return Future.value();
  },
  description: 'Returns the Map, where all keys and values are removed',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.clear()${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': {'1stKey': 1, '2ndKey': 2, '3rdKey': 3},
      },
      shouldRender: "{}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/clear_test.dart',
    ),
  ],
);

final _putMethod = MethodDefinition<Map, void>(
  name: 'put',
  parameters: [
    Parameter<Object>(
      name: 'key',
      description: 'The key to add',
      presence: PresenceMandatory(),
    ),
    Parameter<dynamic>(
      name: 'value',
      description: 'The value to add',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var map = context.owner;
    var key = context.argumentValues['key'];
    var value = context.argumentValues['value'];
    map[key] = value;
    return Future.value();
  },
  description: 'Returns the map with the added key and value pair',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.put("3rdKey", 3)${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': {'1stKey': 1, '2ndKey': 2},
      },
      shouldRender: "{1stKey: 1, 2ndKey: 2, 3rdKey: 3}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/put_test.dart',
    ),
  ],
);

final _removeMethod = MethodDefinition<Map, void>(
  name: 'remove',
  parameters: [
    Parameter<Object>(
      name: 'key',
      description: 'The key to remove',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var map = context.owner;
    var key = context.argumentValues['key'];
    map.remove(key);
    return Future.value();
  },
  description: 'Returns the map with the removed key and value pair',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.remove("1stKey")${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': {'1stKey': 1, '2ndKey': 2},
      },
      shouldRender: "{2ndKey: 2}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/map/remove_test.dart',
    ),
  ],
);
