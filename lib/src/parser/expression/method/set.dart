import 'package:template_engine/template_engine.dart';

final standardSetMethods = <MethodDefinition<Set, dynamic>>[
  _lengthMethod,
  _firstMethod,
  _lastMethod,
  _isEmptyMethod,
  _isNotEmptyMethod,
  _toListMethod,
  _containsMethod,
  _addMethod,
  _removeMethod,
  _clearMethod,
];

final _lengthMethod = MethodDefinition<Set, num>(
  name: 'length',
  parameters: [],
  method: (context) => Future.value(context.owner.length),

  description: 'Returns the number of items (length) of a Set',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}numbers.length()${delimiter.end}',
      variables: {
        'numbers': {4, 5, 7},
      },
      shouldRender: "3",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/length_test.dart',
    ),
  ],
);

final _firstMethod = MethodDefinition<Set, dynamic>(
  name: 'first',
  parameters: [],
  method: (context) {
    var set = context.owner;
    if (set.isEmpty) {
      throw RenderError(
        'Cannot call first() on an empty set',
        context.methodLocation,
      );
    }
    return Future.value(set.first);
  },

  description: 'Returns the first item of a Set',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}numbers.first()${delimiter.end}',
      variables: {
        'numbers': {4, 5, 7},
      },
      shouldRender: "4",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/first_test.dart',
    ),
  ],
);

final _lastMethod = MethodDefinition<Set, dynamic>(
  name: 'last',
  parameters: [],
  method: (context) {
    var set = context.owner;
    if (set.isEmpty) {
      throw RenderError(
        'Cannot call last() on an empty set',
        context.methodLocation,
      );
    }
    return Future.value(set.last);
  },

  description: 'Returns the last item of a Set',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}numbers.last()${delimiter.end}',
      variables: {
        'numbers': {4, 5, 7},
      },
      shouldRender: "7",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/last_test.dart',
    ),
  ],
);

final _isEmptyMethod = MethodDefinition<Set, bool>(
  name: 'isEmpty',
  parameters: [],
  method: (context) => Future.value(context.owner.isEmpty),

  description: 'Returns true if the Set is empty, false otherwise',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.isEmpty()${delimiter.end}',
      variables: {'items': <Object>{}},
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/is_empty_test.dart',
    ),
  ],
);

final _isNotEmptyMethod = MethodDefinition<Set, bool>(
  name: 'isNotEmpty',
  parameters: [],
  method: (context) => Future.value(context.owner.isNotEmpty),

  description: 'Returns true if the Set is not empty, false otherwise',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.isNotEmpty()${delimiter.end}',
      variables: {
        'items': {1, 2, 3},
      },
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/is_not_empty_test.dart',
    ),
  ],
);

final _toListMethod = MethodDefinition<Set, List<dynamic>>(
  name: 'toList',
  parameters: [],
  method: (context) => Future.value(context.owner.toList()),

  description: 'Returns the elements of the Set as a List',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.toList()${delimiter.end}',
      variables: {
        'items': {1, 2, 3},
      },
      shouldRender: "[1, 2, 3]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/to_list_test.dart',
    ),
  ],
);

final _addMethod = MethodDefinition<Set, void>(
  name: 'add',
  parameters: [
    Parameter(
      name: 'value',
      description: 'The value to add to the Set',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var value = context.argumentValues['value'];
    var set = context.owner;
    set.add(value);
    return Future.value();
  },
  description: 'Returns the set with the added value',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.add(7)${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': {1, 2, 3},
      },
      shouldRender: "{1, 2, 3, 7}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/add_test.dart',
    ),
  ],
);

final _removeMethod = MethodDefinition<Set, void>(
  name: 'remove',
  parameters: [
    Parameter(
      name: 'value',
      description: 'The value to remove from the Set',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var set = context.owner;
    var valueToRemove = context.argumentValues['value'];
    if (set.contains(valueToRemove)) {
      set.remove(valueToRemove);
      return Future.value();
    } else {
      context.addWarning(
        'Item `$valueToRemove` is not part of the Set '
        "and can therefore not be removed",
        context.argumentLocations['value']!,
      );
    }
    return Future.value();
  },
  description: 'Returns the set, where the value was removed',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.remove(2)${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': {1, 2, 3},
      },
      shouldRender: "{1, 3}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/remove_test.dart',
    ),
  ],
);

final _clearMethod = MethodDefinition<Set, void>(
  name: 'clear',
  parameters: [],
  method: (context) {
    var set = context.owner;
    set.clear();
    return Future.value();
  },
  description: 'Returns the set, where all items are removed',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.clear()${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': {1, 2, 3},
      },
      shouldRender: "{}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/clear_test.dart',
    ),
  ],
);

final _containsMethod = MethodDefinition<Set, bool>(
  name: 'contains',
  parameters: [
    Parameter(
      name: 'value',
      description: 'The value to remove from the Set',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var value = context.argumentValues['value'];
    var set = context.owner;
    var contains = set.contains(value);
    return Future.value(contains);
  },
  description: 'Returns if a Set contains a given value',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.contains(2)${delimiter.end}',
      variables: {
        'items': {1, 2, 3},
      },
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/set/contains_test.dart',
    ),
  ],
);
