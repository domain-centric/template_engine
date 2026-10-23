import 'package:template_engine/template_engine.dart';

final standardListMethods = <MethodDefinition<List, dynamic>>[
  _lengthMethod,
  _firstMethod,
  _lastMethod,
  _isEmptyMethod,
  _isNotEmptyMethod,
  _sortMethod,
  _reverseMethod,
  _toSetMethod,
  _indexOfMethod,
  _getMethod,
  _removeMethod,
  _removeAtMethod,
  _addMethod,
  _insertMethod,
  _containsMethod,
  _clearMethod,
];

final _lengthMethod = MethodDefinition<List, num>(
  name: 'length',
  parameters: [],
  method: (context) => Future.value(context.owner.length),

  description: 'Returns the number of items (length) of a List',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}numbers.length()${delimiter.end}',
      variables: {
        'numbers': [4, 5, 7],
      },
      shouldRender: "3",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/length_test.dart',
    ),
  ],
);

final _firstMethod = MethodDefinition<List, dynamic>(
  name: 'first',
  parameters: [],
  method: (context) {
    if (context.owner.isEmpty) {
      throw RenderError(
        'Cannot call first() on an empty list',
        context.methodLocation,
      );
    }
    return Future.value(context.owner.first);
  },

  description: 'Returns the first item of a List',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}numbers.first()${delimiter.end}',
      variables: {
        'numbers': [4, 5, 7],
      },
      shouldRender: "4",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/first_test.dart',
    ),
  ],
);

final _lastMethod = MethodDefinition<List, dynamic>(
  name: 'last',
  parameters: [],
  method: (context) {
    if (context.owner.isEmpty) {
      throw RenderError(
        'Cannot call last() on an empty list',
        context.methodLocation,
      );
    }
    return Future.value(context.owner.last);
  },

  description: 'Returns the last item of a List',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}numbers.last()${delimiter.end}',
      variables: {
        'numbers': [4, 5, 7],
      },
      shouldRender: "7",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/last_test.dart',
    ),
  ],
);

final _isEmptyMethod = MethodDefinition<List, bool>(
  name: 'isEmpty',
  parameters: [],
  method: (context) => Future.value(context.owner.isEmpty),

  description: 'Returns true if the List is empty, false otherwise',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.isEmpty()${delimiter.end}',
      variables: {'items': []},
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/is_empty_test.dart',
    ),
  ],
);

final _isNotEmptyMethod = MethodDefinition<List, bool>(
  name: 'isNotEmpty',
  parameters: [],
  method: (context) => Future.value(context.owner.isNotEmpty),

  description: 'Returns true if the List is not empty, false otherwise',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.isNotEmpty()${delimiter.end}',
      variables: {
        'items': [1, 2, 3],
      },
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/is_not_empty_test.dart',
    ),
  ],
);

final _sortMethod = MethodDefinition<List, void>(
  name: 'sort',
  parameters: [],
  method: (context) {
    try {
      context.owner.sort();
    } catch (e) {
      context.addWarning(
        'Error occurred while sorting the list: $e',
        context.methodLocation,
      );
    }
    return Future.value();
  },
  description:
      'Sorts the List in according to the natural ordering of its elements.',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.sort()${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': [3, 1, 2],
      },
      shouldRender: "[1, 2, 3]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/sort_test.dart',
    ),
  ],
);

final _reverseMethod = MethodDefinition<List, void>(
  name: 'reverse',
  parameters: [],
  method: (context) {
    var list = context.owner;
    var reversedList = list.reversed.toList();
    list.clear();
    list.addAll(reversedList);
    return Future.value();
  },
  description: 'Reverses the order in a list.',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.reverse()${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': [1, 2, 3],
      },
      shouldRender: "[3, 2, 1]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/reverse_test.dart',
    ),
  ],
);

final _toSetMethod = MethodDefinition<List, Set<dynamic>>(
  name: 'toSet',
  parameters: [],
  method: (context) => Future.value(context.owner.toSet()),

  description:
      'Returns the elements of the List as a Set (a set is a collection of unique items)',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.toSet()${delimiter.end}',
      variables: {
        'items': [1, 2, 2, 3],
      },
      shouldRender: "{1, 2, 3}",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/to_set_test.dart',
    ),
  ],
);

final _indexOfMethod = MethodDefinition<List, int>(
  name: 'indexOf',
  parameters: [
    Parameter<dynamic>(
      name: 'value',
      description: 'The value in the list that we want the index from',
      presence: PresenceMandatory(),
    ),
    Parameter<int>(
      name: 'start',
      description: 'The index the search starts at',
      presence: PresenceOptionalWithDefaultValue(0),
    ),
  ],
  method: (context) {
    var valueToFind = context.argumentValues['value'];
    var startIndex = context.argumentValues['start'] as int;
    var list = context.owner;
    return Future.value(list.indexOf(valueToFind, startIndex));
  },
  description:
      'Searches the List from index [start] to the end of the list '
      'and returns the found index number (0= if the value matches first item). '
      'Returns -1 then value can not be found in the List.',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.indexOf(2)${delimiter.end}',
      variables: {
        'items': [1, 2, 2, 3],
      },
      shouldRender: "1",
    ),
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.indexOf(2,2)${delimiter.end}',
      variables: {
        'items': [1, 2, 2, 3],
      },
      shouldRender: "2",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/index_of_test.dart',
    ),
  ],
);

final _getMethod = MethodDefinition<List, dynamic>(
  name: 'get',
  parameters: [
    Parameter<int>(
      name: 'index',
      description: 'The index of the item in the List that we want to get',
      presence: PresenceOptionalWithDefaultValue(0),
    ),
  ],
  method: (context) {
    var list = context.owner;
    var index = context.argumentValues['index'];
    if (index < 0 || index >= list.length) {
      throw RenderError(
        'Index out of bounds: $index (min:0 max:${list.length - 1})',
        context.argumentLocations['index']!,
      );
    }
    return Future.value(list[index]);
  },
  description:
      'Gets the value of an item in the List using an given index'
      '(0=is the first item). '
      'Returns null if the index is out of bounds',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}items.get(1)${delimiter.end}',
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
      shouldRender: "berry",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/get_test.dart',
    ),
  ],
);

final _removeMethod = MethodDefinition<List, void>(
  name: 'remove',
  parameters: [
    Parameter<dynamic>(
      name: 'value',
      description: 'The value that we want to remove from the List',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var list = context.owner;
    var valueToRemove = context.argumentValues['value'];
    if (!list.contains(valueToRemove)) {
      context.addWarning(
        'Item `$valueToRemove` is not part of the List '
        "and can therefore not be removed",
        context.argumentLocations['value']!,
      );
    }
    list.remove(valueToRemove);
    return Future.value();
  },
  description:
      'Removes the given value from the List '
      '(0 is the first item)',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.remove("berry")${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
      shouldRender: '[apple, cherry]',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/remove_test.dart',
    ),
  ],
);

final _removeAtMethod = MethodDefinition<List, void>(
  name: 'removeAt',
  parameters: [
    Parameter<int>(
      name: 'index',
      description: 'The index of the item in the List that we want to remove',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var list = context.owner;
    var index = context.argumentValues['index'];
    if (index < 0 || index >= list.length) {
      context.addWarning(
        'Index out of bounds: $index (min:0 max:${list.length - 1})',
        context.argumentLocations['index']!,
      );
      return Future.value();
    }
    list.removeAt(index);
    return Future.value();
  },
  description:
      'Removes the item at the given index from the List '
      '(0 is the first item)',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.removeAt(1)${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
      shouldRender: '[apple, cherry]',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/remove_at_test.dart',
    ),
  ],
);

final _addMethod = MethodDefinition<List, void>(
  name: 'add',
  parameters: [
    Parameter(
      name: 'value',
      description: 'The value to add to the List',
      presence: PresenceMandatory(),
    ),
  ],

  method: (context) {
    var list = context.owner;
    var value = context.argumentValues['value'];
    list.add(value);
    return Future.value();
  },
  description: 'Returns the List with the added value',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.add(7)${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': [1, 2, 3],
      },
      shouldRender: "[1, 2, 3, 7]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/add_test.dart',
    ),
  ],
);

final _insertMethod = MethodDefinition<List, void>(
  name: 'insert',
  parameters: [
    Parameter<int>(
      name: 'index',
      description:
          'The index where the value needs to be inserted into the List (index=is first position)',
      presence: PresenceMandatory(),
    ),
    Parameter<dynamic>(
      name: 'value',
      description: 'The value to add to the List',
      presence: PresenceMandatory(),
    ),
  ],

  method: (context) {
    var list = context.owner;
    var index = context.argumentValues['index'] as int;
    if (index < 0 || index > list.length) {
      context.addWarning(
        'Index out of bounds: $index (min:0 max:${list.length})',
        context.argumentLocations['index']!,
      );
      return Future.value();
    }
    var value = context.argumentValues['value'];
    list.insert(index, value);
    return Future.value();
  },
  description: 'Adds a value to the List',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.insert(2, 3)${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': [1, 2, 4],
      },
      shouldRender: "[1, 2, 3, 4]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/insert_test.dart',
    ),
  ],
);

final _containsMethod = MethodDefinition<List, bool>(
  name: 'contains',
  parameters: [
    Parameter<dynamic>(
      name: 'value',
      description: 'The value to find in the List',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var list = context.owner;
    var value = context.argumentValues['value'];
    return Future.value(list.contains(value));
  },
  description:
      'Returns true if a given value is part of the List, '
      'and false if not',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.contains("berry")${delimiter.end}',
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/contains_test.dart',
    ),
  ],
);

final _clearMethod = MethodDefinition<List, void>(
  name: 'clear',
  parameters: [],
  method: (context) {
    var list = context.owner;
    list.clear();
    return Future.value();
  },
  description: 'Returns the List, where all items are removed',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}items.clear()${delimiter.end}'
          '${delimiter.start}items${delimiter.end}',
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
      shouldRender: "[]",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/list/clear_test.dart',
    ),
  ],
);
