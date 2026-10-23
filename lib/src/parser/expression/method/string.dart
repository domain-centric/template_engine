import 'package:recase/recase.dart';
import 'package:template_engine/template_engine.dart';

final standardStringMethods = <MethodDefinition<String, dynamic>>[
  toNumberMethod,
  toUpperCaseMethod,
  toLowerCaseMethod,
  toCamelCaseMethod,
  toConstantCaseMethod,
  toSentenceCaseMethod,
  toSnakeCaseMethod,
  toDotCaseMethod,
  toParamCaseMethod,
  toPathCaseMethod,
  toPascalCaseMethod,
  toHeaderCaseMethod,
  toTitleCaseMethod,
  trimMethod,
  trimLeftMethod,
  trimRightMethod,
  padLeftMethod,
  padRightMethod,
  subStringMethod,
  splitMethod,
  replaceFirstMethod,
  replaceAllMethod,
  startsWithMethod,
  endsWithMethod,
  indexOfMethod,
  lengthMethod,
];

final toNumberMethod = MethodDefinition<String, num>(
  name: 'toNumber',
  parameters: [],
  method: (context) {
    var string = context.owner;
    var parseResult = num.tryParse(string);
    if (parseResult == null) {
      throw RenderError(
        'Could not parse `$string` to a number',
        context.methodLocation,
      );
    } else {
      return Future.value(parseResult);
    }
  },
  description: 'Returns a string as a number (int or double). ',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"123".toNumber()${delimiter.end}',
      shouldRender: '123',
    ),
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"12.3".toNumber()${delimiter.end}',
      shouldRender: '12.3',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_number_test.dart',
    ),
  ],
);

final toUpperCaseMethod = MethodDefinition<String, String>(
  name: 'toUpperCase',
  parameters: [],
  method: (context) => Future.value(context.owner.toUpperCase()),
  description: 'Returns a string where all characters are in upper case',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"HELlo".toUpperCase()${delimiter.end}',
      shouldRender: "HELlo".toUpperCase(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_lower_case_test.dart',
    ),
  ],
);

final toLowerCaseMethod = MethodDefinition<String, String>(
  name: 'toLowerCase',
  parameters: [],
  method: (context) => Future.value(context.owner.toLowerCase()),

  description: 'Returns a string where all characters are in lower case',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"HELlo".toLowerCase()${delimiter.end}',
      shouldRender: "HEllo".toLowerCase(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_lower_case_test.dart',
    ),
  ],
);

final toCamelCaseMethod = MethodDefinition<String, String>(
  name: 'toCamelCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).camelCase),
  description: 'Returns a string converted to camelCase',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello world".toCamelCase()${delimiter.end}',
      shouldRender: 'helloWorld',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_camel_case_test.dart',
    ),
  ],
);

final toConstantCaseMethod = MethodDefinition<String, String>(
  name: 'toConstantCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).constantCase),
  description: 'Returns a string converted to CONSTANT_CASE',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello world".toConstantCase()${delimiter.end}',
      shouldRender: 'HELLO_WORLD',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_constant_case_test.dart',
    ),
  ],
);

final toSentenceCaseMethod = MethodDefinition<String, String>(
  name: 'toSentenceCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).sentenceCase),
  description: 'Returns a string converted to sentence case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"hello_world".toSentenceCase()${delimiter.end}',
      shouldRender: 'Hello world',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_sentence_case_test.dart',
    ),
  ],
);

final toSnakeCaseMethod = MethodDefinition<String, String>(
  name: 'toSnakeCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).snakeCase),
  description: 'Returns a string converted to snake_case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello World".toSnakeCase()${delimiter.end}',
      shouldRender: 'hello_world',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_snake_case_test.dart',
    ),
  ],
);

final toDotCaseMethod = MethodDefinition<String, String>(
  name: 'toDotCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).dotCase),
  description: 'Returns a string converted to dot.case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello World".toDotCase()${delimiter.end}',
      shouldRender: 'hello.world',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_dot_case_test.dart',
    ),
  ],
);

final toParamCaseMethod = MethodDefinition<String, String>(
  name: 'toParamCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).paramCase),
  description: 'Returns a string converted to param-case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello World".toParamCase()${delimiter.end}',
      shouldRender: 'hello-world',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_param_case_test.dart',
    ),
  ],
);

final toPathCaseMethod = MethodDefinition<String, String>(
  name: 'toPathCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).pathCase),
  description: 'Returns a string converted to path/case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello World".toPathCase()${delimiter.end}',
      shouldRender: 'hello/world',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_path_case_test.dart',
    ),
  ],
);

final toPascalCaseMethod = MethodDefinition<String, String>(
  name: 'toPascalCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).pascalCase),
  description: 'Returns a string converted to PascalCase',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"hello world".toPascalCase()${delimiter.end}',
      shouldRender: 'HelloWorld',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_pascal_case_test.dart',
    ),
  ],
);

final toHeaderCaseMethod = MethodDefinition<String, String>(
  name: 'toHeaderCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).headerCase),
  description: 'Returns a string converted to Header-Case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"hello world".toHeaderCase()${delimiter.end}',
      shouldRender: 'Hello-World',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_header_case_test.dart',
    ),
  ],
);

final toTitleCaseMethod = MethodDefinition<String, String>(
  name: 'toTitleCase',
  parameters: [],
  method: (context) => Future.value(ReCase(context.owner).titleCase),
  description: 'Returns a string converted to Title Case',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"hello_world".toTitleCase()${delimiter.end}',
      shouldRender: 'Hello World',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/to_title_case_test.dart',
    ),
  ],
);

final trimMethod = MethodDefinition<String, String>(
  name: 'trim',
  parameters: [],
  method: (context) => Future.value(context.owner.trim()),
  description: 'Returns a string without any leading and trailing whitespace',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"  Hello  ".trim()${delimiter.end}',
      shouldRender: "  Hello  ".trim(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/trim_test.dart',
    ),
  ],
);

final trimLeftMethod = MethodDefinition<String, String>(
  name: 'trimLeft',
  parameters: [],
  method: (context) => Future.value(context.owner.trimLeft()),
  description: 'Returns a string without any leading whitespace',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"  Hello  ".trimLeft()${delimiter.end}',
      shouldRender: "  Hello  ".trimLeft(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/trim_left_test.dart',
    ),
  ],
);

final trimRightMethod = MethodDefinition<String, String>(
  name: 'trimRight',
  parameters: [],
  method: (context) => Future.value(context.owner.trimRight()),
  description: 'Returns a string without any trailing whitespace',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"  Hello  ".trimRight()${delimiter.end}',
      shouldRender: "  Hello  ".trimRight(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/trim_right_test.dart',
    ),
  ],
);

final padLeftMethod = MethodDefinition<String, String>(
  name: 'padLeft',
  parameters: [
    Parameter<int>(
      name: 'width',
      description: 'The total width of the resulting string',
      presence: PresenceMandatory(),
    ),
    Parameter<String>(
      name: 'padding',
      description: 'The string to use for padding',
      presence: PresenceOptionalWithDefaultValue(' '),
    ),
  ],
  method: (context) {
    final width = context.argumentValues['width'] as int;
    final padding = context.argumentValues['padding'] as String;
    var string = context.owner;
    return Future.value(string.padLeft(width, padding));
  },
  description: 'Returns a string with padding added to the left',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"Hello".padLeft(7)${delimiter.end}',
      shouldRender: "  Hello",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/pad_left_test.dart',
    ),
  ],
);

final padRightMethod = MethodDefinition<String, String>(
  name: 'padRight',
  parameters: [
    Parameter<int>(
      name: 'width',
      description: 'The total width of the resulting string',
      presence: PresenceMandatory(),
    ),
    Parameter<String>(
      name: 'padding',
      description: 'The string to use for padding',
      presence: PresenceOptionalWithDefaultValue(' '),
    ),
  ],
  method: (context) {
    final width = context.argumentValues['width'] as int;
    final padding = context.argumentValues['padding'] as String;
    var string = context.owner;
    return Future.value(string.padRight(width, padding));
  },
  description: 'Returns a string with padding added to the right',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"Hello".padRight(7)${delimiter.end}',
      shouldRender: "Hello  ",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/pad_right_test.dart',
    ),
  ],
);

final subStringMethod = MethodDefinition<String, String>(
  name: 'subString',
  parameters: [
    Parameter<int>(
      name: 'start',
      description: 'The starting index of the substring (0=first character)',
      presence: PresenceMandatory(),
    ),
    Parameter<int>(
      name: 'end',
      description: 'The ending index of the substring',
      presence: PresenceOptional(),
    ),
  ],
  method: (context) {
    final start = context.argumentValues['start'] as int;
    final end = context.argumentValues['end'] as int?;
    var string = context.owner;
    return Future.value(string.substring(start, end));
  },
  description: 'Returns a substring of the string',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"12345".subString(0, 2)${delimiter.end}',
      shouldRender: "12",
    ),
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"12345".subString(1, 4)${delimiter.end}',
      shouldRender: "234",
    ),
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"12345".subString(3)${delimiter.end}',
      shouldRender: "45",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/sub_string_test.dart',
    ),
  ],
);

final splitMethod = MethodDefinition<String, List<String>>(
  name: 'split',
  parameters: [
    Parameter<String>(
      name: 'pattern',
      description: 'The pattern to split the string by',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    final pattern = context.argumentValues['pattern'] as String;
    var string = context.owner;
    return Future.value(string.split(pattern));
  },
  description:
      'Returns a list of strings obtained by splitting the string at each occurrence of the pattern',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello world".split(" ")${delimiter.end}',
      shouldRender: "Hello world".split(" ").toString(),
    ),
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}"Hello world".split("")${delimiter.end}',
      shouldRender: "Hello world".split("").toString(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/split_test.dart',
    ),
  ],
);

final replaceFirstMethod = MethodDefinition<String, String>(
  name: 'replaceFirst',
  parameters: [
    Parameter<String>(
      name: 'from',
      description: 'The string to replace',
      presence: PresenceMandatory(),
    ),
    Parameter<String>(
      name: 'to',
      description: 'The string to replace with',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    final from = context.argumentValues['from'] as String;
    final to = context.argumentValues['to'] as String;
    var string = context.owner;
    return Future.value(string.replaceFirst(from, to));
  },
  description:
      'Returns a string with the first occurrence of a substring replaced',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          "${delimiter.start}'Hello ! !'.replaceFirst('!','world')${delimiter.end}",
      shouldRender: "Hello world !",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/replace_first_test.dart',
    ),
  ],
);

final replaceAllMethod = MethodDefinition<String, String>(
  name: 'replaceAll',
  parameters: [
    Parameter<String>(
      name: 'from',
      description: 'The string to replace',
      presence: PresenceMandatory(),
    ),
    Parameter<String>(
      name: 'to',
      description: 'The string to replace with',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    final from = context.argumentValues['from'] as String;
    final to = context.argumentValues['to'] as String;
    var string = context.owner;
    return Future.value(string.replaceAll(from, to));
  },
  description: 'Returns a string with all occurrences of a substring replaced',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          "${delimiter.start}'Hello ??'.replaceAll('?','!')${delimiter.end}",
      shouldRender: "Hello !!",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/replace_all_test.dart',
    ),
  ],
);

final startsWithMethod = MethodDefinition<String, bool>(
  name: 'startsWith',
  parameters: [
    Parameter<String>(
      name: 'pattern',
      description: 'The pattern to check if the string starts with',
      presence: PresenceMandatory(),
    ),
    Parameter<int>(
      name: 'index',
      description: 'The index to check if the string starts with',
      presence: PresenceOptionalWithDefaultValue(0),
    ),
  ],
  method: (context) {
    final pattern = context.argumentValues['pattern'] as String;
    final index = context.argumentValues['index'] as int;
    var string = context.owner;
    return Future.value(string.startsWith(pattern, index));
  },
  description:
      'Returns a boolean indicating if the string starts with the specified pattern',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          "${delimiter.start}'Hello world'.startsWith('Hello')${delimiter.end}",
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/starts_with_test.dart',
    ),
  ],
);

final endsWithMethod = MethodDefinition<String, bool>(
  name: 'endsWith',
  parameters: [
    Parameter<String>(
      name: 'pattern',
      description: 'The pattern to check if the string ends with',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    final pattern = context.argumentValues['pattern'] as String;
    var string = context.owner;
    return Future.value(string.endsWith(pattern));
  },
  description:
      'Returns a boolean indicating if the string ends with the specified pattern',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          "${delimiter.start}'Hello world'.endsWith('world')${delimiter.end}",
      shouldRender: "true",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/ends_with_test.dart',
    ),
  ],
);

final indexOfMethod = MethodDefinition<String, int>(
  name: 'indexOf',
  parameters: [
    Parameter<String>(
      name: 'pattern',
      description: 'The text to search for in the string',
      presence: PresenceMandatory(),
    ),
    Parameter<int>(
      name: 'start',
      description: 'The index to start searching from',
      presence: PresenceOptionalWithDefaultValue(0),
    ),
  ],
  method: (context) {
    final pattern = context.argumentValues['pattern'] as String;
    final start = context.argumentValues['start'] as int;
    var string = context.owner;
    return Future.value(string.indexOf(pattern, start));
  },
  description:
      'Returns the index of the first occurrence of the specified pattern '
      'in the string. It returns -1 if the pattern is not found.',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          "${delimiter.start}'Hello world'.indexOf('lo')${delimiter.end}",
      shouldRender: "3",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/index_of_test.dart',
    ),
  ],
);

final lengthMethod = MethodDefinition<String, num>(
  name: 'length',
  parameters: [],
  method: (context) => Future.value(context.owner.length),
  description: 'Returns the length of a string in number of characters',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"Hello".length()${delimiter.end}',
      shouldRender: "Hello".length.toString(),
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/string/length_test.dart',
    ),
  ],
);
