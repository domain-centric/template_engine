import 'package:template_engine/template_engine.dart';

final standardDataTypes = <DataTypeDefinition>[
  _boolean,
  _number,
  _string,
  _list,
  _set,
  _map,
];

/// A [data type](https://en.wikipedia.org/wiki/Data_type) defines what the
/// possible values an expression, such as a variable, operator
/// or a function call, might use.
///
/// The [TemplateEngine] supports several default [DataTypeDefinition]s.
class DataTypeDefinition {
  /// documentation that describes the data type.
  final DefinitionDocumentation documentation;

  /// optional: if the data type uses keywords
  /// e.g. 'true' or 'false' for boolean if [DataTypeDefinition] is for booleans
  final Set<String> reservedKeywords;

  /// check if the first token(s) match the data type
  final bool Function(List<CodeToken> tokens) matches;

  /// consumes the first token(s) that represent the data type
  /// and converts them to an [Expression]
  final Expression Function(CodeTokenStream tokenStream) parse;

  DataTypeDefinition({
    required this.documentation,
    this.reservedKeywords = const {},
    required this.matches,
    required this.parse,
  });
}

String aggregatedDataTypeDocumentation(Grammar grammar, int titleLevel) {
  var markDown = StringBuffer();

  markDown.writeln(
    'A [data type](https://en.wikipedia.org/wiki/Data_type) defines what the '
    'possible values an expression, such as a variable, operator '
    'or a function call, might use.\n\n'
    'The [template_engine](https://pub.dev/packages/template_engine) '
    'supports several default DataTypes.',
  );

  for (var dataType in grammar.dataTypes) {
    markDown.writeln(
      dataType.documentation.createMarkdownDocumentation(
        grammar,
        titleLevel + 1,
      ),
    );
  }

  markDown.writeln(markdownTitle(titleLevel + 1, 'Custom data types'));
  markDown.writeln(
    'You can use the data types that are packaged with Template Engine, '
    'but you can also add or replace these with '
    'your own custom made data types. '
    'This is done by creating your own TemplateEngineConfiguration or '
    'adding to it using the withAdditionalDataTypes() method\n',
  );
  markDown.write('Example: ');
  markDown.writeln(customDataTypeExample.toMarkdownLink());

  return markDown.toString();
}

final customDataTypeExample = TestFileExample.fromProjectFilePath(
  'test/src/parser/expression/data_type/custom_data_type_test.dart',
);

// List<Parser<Expression>> dataTypeParsers(List<DataTypeDefinition> dataTypes) =>
//     dataTypes.map((dataType) => dataType.createParser()).toList();

const _booleanKeywords = {'true', 'false'};

final _boolean = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'Boolean',
    description: 'A form of data with only two possible values: true or false',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start}true${delimiter.end}  ${delimiter.start}false${delimiter.end}',
      explanationFunction: (delimiter) =>
          'A boolean is declared with the word true or false (case un-sensitive).',
    ),
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/data_type/bool_test.dart',
      ),
    ],
  ),
  reservedKeywords: _booleanKeywords,
  matches: (tokens) =>
      _booleanKeywords.contains(tokens.first.value.toLowerCase()),
  parse: (tokenStream) {
    var token = tokenStream.consume();
    if (token.value.toLowerCase() == 'true') {
      return LiteralExpression(true);
    } else {
      return LiteralExpression(false);
    }
  },
);

final _number = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'Number',
    description: 'A form of data to express the size of something.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (definition) => '{{-12.34}}',
      explanationFunction: (delimiter) => [
        'Numbers are declared in many ways:',
        '* integer (e.g. 2021)',
        '* fragments (e.g. 3.14)',
        '* positive (e.g. 10 or +10 or 10.2)',
        '* negative (e.g. -11 or -1.2)',
        '* scientific (e.g. 1e3 = 1000.0 or -123e-2 = -1.23)',
        '* hexadecimal (e.g. 0x1f = 31 or -0xFF = -255)',
      ].join('<br>'),
    ),
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/data_type/num_test.dart',
      ),
    ],
  ),
  matches: (tokens) => tokens.first.type == .number,
  parse: (tokenStream) {
    var token1 = tokenStream.consume();
    var token2 = tokenStream.peek(offset: 0);
    var token3 = tokenStream.peek(offset: 1);
    var token4 = tokenStream.peek(offset: 2);
    if (_isScientificNotationWithToken2(token2)) {
      tokenStream.consume(); // consume token 2
      return LiteralExpression(num.parse([token1.value, token2.value].join()));
    }
    if (_isScientificNotationWithToken2to4(token2, token3, token4)) {
      tokenStream.consume(); // consumes token 2
      tokenStream.consume(); // consumes token 3
      tokenStream.consume(); // consumes token 4
      return LiteralExpression(
        num.parse(
          [token1.value, token2.value, token3.value, token4.value].join(),
        ),
      );
    }
    if (isHexadecimal(token1, token2)) {
      tokenStream.consume(); // consume token 2
      return LiteralExpression(num.parse([token1.value, token2.value].join()));
    }
    return LiteralExpression(num.parse(token1.value));
  },
);

bool isHexadecimal(CodeToken token1, CodeToken token2) =>
    token1.value == '0' &&
    token2.value.toLowerCase().startsWith('x') &&
    token2.value.length > 1 &&
    _isValidHexadecimal(token2.value.substring(1));

bool _isValidHexadecimal(String binary) =>
    RegExp(r'^[0123456789ABCDEF]+$', caseSensitive: false).hasMatch(binary);

// e.g. 'e', '-', '12'
bool _isScientificNotationWithToken2to4(
  CodeToken token2,
  CodeToken token3,
  CodeToken token4,
) =>
    token2.value.toLowerCase() == 'e' &&
    token3.value == '-' &&
    token4.type == .number;

/// e.g. 'e10'
bool _isScientificNotationWithToken2(CodeToken token2) =>
    token2.value.toLowerCase().startsWith('e') &&
    token2.value.length > 1 &&
    _isValidNumber(token2.value.substring(1));

bool _isValidNumber(String number) {
  var result = num.tryParse(number);
  return result != null && !result.isNaN;
}

final _string = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'String',
    description: 'A form of data containing a sequence of characters',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) => '',
      explanationFunction: (delimiter) =>
          'A string is declared with a chain of characters, surrounded by '
          'two single (\') or double (") quotes to indicate the '
          'start and end of a string. In example: \'Hello\' or "Hello"',
    ),
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/data_type/string_test.dart',
      ),
    ],
  ),
  matches: (List<CodeToken> tokens) => tokens.first.type == .string,
  parse: (tokenStream) {
    var token = tokenStream.consume();
    return LiteralExpression(token.value);
  },
);

final _list = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'List',
    description: 'An indexable ordered collection of objects.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start}List(1, 2, 3)${delimiter.end}',
      explanationFunction: (delimiter) =>
          'List() creates an empty list. Values can be supplied as constructor arguments.',
    ),
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/data_type/list_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'list'},
  matches: (List<CodeToken> tokens) =>
      tokens.length >= 2 &&
      tokens[0].value.toLowerCase() == 'list' &&
      tokens[1].value == '(',
  parse: (tokenStream) {
    final listItems = <Expression>[];

    tokenStream.consume(); // consume List

    if (tokenStream.consume().value != '(') {
      throw ParseError(
        'Expected `(` after `List`',
        tokenStream.peek().location,
      );
    }

    if (tokenStream.peek().value == ')') {
      tokenStream.consume(); // consume )
      return ListExpression(listItems);
    }

    while (!tokenStream.isAtEnd) {
      final currentToken = tokenStream.peek();

      if (currentToken.value == ',') {
        throw ParseError(
          'Expected list value before `,`',
          currentToken.location,
        );
      }

      if (currentToken.value == ')') {
        tokenStream.consume();
        return ListExpression(listItems);
      }

      final parser = ExpressionParser(
        Grammar.standard(),
        tokenStream,
        <ParseError>[],
      );

      final itemExpression = parser.parseExpression();
      listItems.add(itemExpression);

      final separator = tokenStream.peek();

      if (separator.value == ',') {
        tokenStream.consume();

        if (tokenStream.peek().value == ')') {
          throw ParseError(
            'Expected list value after `,`',
            tokenStream.peek().location,
          );
        }

        continue;
      }

      if (separator.value == ')') {
        tokenStream.consume();
        return ListExpression(listItems);
      }

      throw ParseError(
        'Expected `,` or `)` in List constructor',
        separator.location,
      );
    }

    throw ParseError(
      'Missing closing parenthesis `)` in List constructor',
      tokenStream.peek().location,
    );
  },
);

final _set = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'Set',
    description: 'An unordered collection of unique objects.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start}Set(1, 2, 3)${delimiter.end}',
      explanationFunction: (delimiter) =>
          'Set() creates an empty set. Values can be supplied as constructor arguments.',
    ),
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/data_type/set_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'set'},
  matches: (List<CodeToken> tokens) =>
      tokens.length >= 2 &&
      tokens[0].value.toLowerCase() == 'set' &&
      tokens[1].value == '(',
  parse: (tokenStream) {
    final setItems = <Expression>{};

    tokenStream.consume(); // consume Set

    if (tokenStream.consume().value != '(') {
      throw ParseError('Expected `(` after `Set`', tokenStream.peek().location);
    }

    if (tokenStream.peek().value == ')') {
      tokenStream.consume(); // consume )
      return SetExpression(setItems);
    }

    while (!tokenStream.isAtEnd) {
      final currentToken = tokenStream.peek();

      if (currentToken.value == ',') {
        throw ParseError(
          'Expected set value before `,`',
          currentToken.location,
        );
      }

      if (currentToken.value == ')') {
        tokenStream.consume();
        return SetExpression(setItems);
      }

      final parser = ExpressionParser(
        Grammar.standard(),
        tokenStream,
        <ParseError>[],
      );

      final itemExpression = parser.parseExpression();
      setItems.add(itemExpression);

      final separator = tokenStream.peek();

      if (separator.value == ',') {
        tokenStream.consume();

        if (tokenStream.peek().value == ')') {
          throw ParseError(
            'Expected set value after `,`',
            tokenStream.peek().location,
          );
        }

        continue;
      }

      if (separator.value == ')') {
        tokenStream.consume();
        return SetExpression(setItems);
      }

      throw ParseError(
        'Expected `,` or `)` in Set constructor',
        separator.location,
      );
    }

    throw ParseError(
      'Missing closing parenthesis `)` in Set constructor',
      tokenStream.peek().location,
    );
  },
);

final _map = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'Map',
    description: 'A collection of key-value pairs.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start}Map("name": "Nils", "age": 12)${delimiter.end}',
      explanationFunction: (delimiter) =>
          'Map() creates an empty map. Key-value pairs can be supplied using the syntax key: value.',
    ),
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/data_type/map_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'map'},
  matches: (List<CodeToken> tokens) =>
      tokens.length >= 2 &&
      tokens[0].value.toLowerCase() == 'map' &&
      tokens[1].value == '(',
  parse: (tokenStream) {
    final entries = <Expression, Expression>{};

    tokenStream.consume(); // consume Map

    if (tokenStream.consume().value != '(') {
      throw ParseError('Expected `(` after `Map`', tokenStream.peek().location);
    }

    if (tokenStream.peek().value == ')') {
      tokenStream.consume();
      return MapExpression(entries);
    }

    while (!tokenStream.isAtEnd) {
      final currentToken = tokenStream.peek();

      if (currentToken.value == ',') {
        throw ParseError('Expected map key before `,`', currentToken.location);
      }

      if (currentToken.value == ')') {
        tokenStream.consume();
        return MapExpression(entries);
      }

      final keyParser = ExpressionParser(
        Grammar.standard(),
        tokenStream,
        <ParseError>[],
      );

      final keyExpression = keyParser.parseExpression();

      if (tokenStream.peek().value != ':') {
        throw ParseError(
          'Expected `:` after map key',
          tokenStream.peek().location,
        );
      }

      tokenStream.consume(); // consume :

      final valueParser = ExpressionParser(
        Grammar.standard(),
        tokenStream,
        <ParseError>[],
      );

      final valueExpression = valueParser.parseExpression();

      entries[keyExpression] = valueExpression;

      final separator = tokenStream.peek();

      if (separator.value == ',') {
        tokenStream.consume();

        if (tokenStream.peek().value == ')') {
          throw ParseError(
            'Expected map entry after `,`',
            tokenStream.peek().location,
          );
        }

        continue;
      }

      if (separator.value == ')') {
        tokenStream.consume();
        return MapExpression(entries);
      }

      throw ParseError(
        'Expected `,` or `)` in Map constructor',
        separator.location,
      );
    }

    throw ParseError(
      'Missing closing parenthesis `)` in Map constructor',
      tokenStream.peek().location,
    );
  },
);
