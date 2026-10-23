import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class CodeBlockDelimiter {
  // delimiter symbols, indicating the start of a code block
  final String start;
  // delimiter symbols, indicating the end of a code block
  final String end;

  const CodeBlockDelimiter({required this.start, required this.end});

  const CodeBlockDelimiter.standard() : start = '{{', end = '}}';
}

/// Defines the [TemplateEngine] syntax,
/// which can be customized by providing a custom [Grammar]
/// to the [TemplateEngine] constructor.
class Grammar {
  final CodeBlockDelimiter codeBlockDelimiter;
  final List<StatementDefinition> statements;
  final List<DataTypeDefinition> dataTypes;
  final List<ConstantDefinition> constants;
  final Map<String, ConstantDefinition> _constantLookUp;
  final List<UnaryOperatorDefinition> unaryOperators;
  final Map<String, UnaryOperatorDefinition> _unaryOperatorLookUp;
  final List<BinaryOperatorDefinition> binaryOperators;
  final Map<String, BinaryOperatorDefinition> _binaryOperatorLookUp;
  final List<FunctionGroup> functionGroups;
  final Map<String, FunctionDefinition> _functionLookUp;
  final List<MethodDefinition> methods;

  late final List<String> reservedKeywords =
      _createNormalizedReservedKeywords();

  Grammar({
    required this.codeBlockDelimiter,
    required this.statements,
    required this.dataTypes,
    required this.constants,
    required this.unaryOperators,
    required this.binaryOperators,
    required this.functionGroups,
    required this.methods,
  }) : // creating look up maps using lower case keys because they are case unsensitive
       _unaryOperatorLookUp = {
         for (var unaryOperator in unaryOperators)
           unaryOperator.symbol.toLowerCase(): unaryOperator,
       },
       _binaryOperatorLookUp = {
         for (var binaryOperator in binaryOperators)
           binaryOperator.symbol.toLowerCase(): binaryOperator,
       },
       _constantLookUp = {
         for (var constant in constants) constant.name.toLowerCase(): constant,
       },
       _functionLookUp = {
         for (var function in functionGroups.expand((fg) => fg))
           function.name.toLowerCase(): function,
       };

  factory Grammar.standard() => Grammar(
    codeBlockDelimiter: const CodeBlockDelimiter.standard(),
    statements: standardStatements,
    dataTypes: standardDataTypes,
    constants: standardConstants,
    unaryOperators: standardUnaryOperators,
    binaryOperators: standardBinaryOperators,
    functionGroups: standardFunctionGroups,
    methods: standardMethods,
  );

  Grammar copyWith({
    CodeBlockDelimiter? codeBlockDelimiter,
    List<StatementDefinition>? statements,
    List<DataTypeDefinition>? dataTypes,
    List<ConstantDefinition>? constants,
    List<UnaryOperatorDefinition>? unaryOperators,
    List<BinaryOperatorDefinition>? binaryOperators,
    List<FunctionGroup>? functionGroups,
    List<MethodDefinition>? methods,
  }) {
    return Grammar(
      codeBlockDelimiter: codeBlockDelimiter ?? this.codeBlockDelimiter,
      statements: statements ?? this.statements,
      dataTypes: dataTypes ?? this.dataTypes,
      constants: constants ?? this.constants,
      unaryOperators: unaryOperators ?? this.unaryOperators,
      binaryOperators: binaryOperators ?? this.binaryOperators,
      functionGroups: functionGroups ?? this.functionGroups,
      methods: methods ?? this.methods,
    );
  }

  Grammar withAdditionalStatements(List<StatementDefinition> additional) =>
      copyWith(statements: [...statements, ...additional]);

  Grammar withAdditionalDataTypes(List<DataTypeDefinition> additional) =>
      copyWith(dataTypes: [...dataTypes, ...additional]);

  Grammar withAdditionalConstants(List<ConstantDefinition> additional) =>
      copyWith(constants: [...constants, ...additional]);

  Grammar withAdditionalUnaryOperators(
    List<UnaryOperatorDefinition> additional,
  ) => copyWith(unaryOperators: [...unaryOperators, ...additional]);

  Grammar withAdditionalBinaryOperators(
    List<BinaryOperatorDefinition> additional,
  ) => copyWith(binaryOperators: [...binaryOperators, ...additional]);

  Grammar withAdditionalFunctionGroups(List<FunctionGroup> additional) =>
      copyWith(functionGroups: [...functionGroups, ...additional]);

  Grammar withAdditionalMethods(List<MethodDefinition> additional) =>
      copyWith(methods: [...methods, ...additional]);

  /// * collects reservedKeywords
  /// * makes them all lower case (case unsensitive)
  /// * orders them from long to short (if keywords start with the same letter, try the longer words first)
  List<String> _createNormalizedReservedKeywords() {
    // keywords are converted to lowercase, because they are case unsensitive
    var keywords = {
      ...dataTypes
          .expand((d) => d.reservedKeywords)
          .map((k) => k.toLowerCase()),
      ...statements
          .expand((d) => d.reservedKeywords)
          .map((k) => k.toLowerCase()),
    };

    List<String> keywordsLongToShort = keywords.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    return keywordsLongToShort;
  }

  /// * collects operator symbols
  /// * makes them all lower case (case unsensitive)
  /// * orders them from long to short (if operators start with the same chars, try the longer symbols first)
  List<String> _createNormalizedOperatorSymbols() {
    var operatorSymbols = <String>{
      ...unaryOperators.map((operator) => operator.symbol.toLowerCase()),
      ...binaryOperators.map((operator) => operator.symbol.toLowerCase()),
    };

    List<String> operatorSymbolsLongToShort = operatorSymbols.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    return operatorSymbolsLongToShort;
  }

  late final List<String> operatorSymbols = _createNormalizedOperatorSymbols();

  Map<Type, List<MethodDefinition>> _createMethodsPerOwnerType() {
    var methodsPerOwnerType = <Type, List<MethodDefinition>>{};
    for (var method in methods) {
      var ownerType = method.ownerType;
      if (!methodsPerOwnerType.containsKey(ownerType)) {
        methodsPerOwnerType[ownerType] = <MethodDefinition>[];
      }
      methodsPerOwnerType[ownerType]!.add(method);
    }
    return methodsPerOwnerType;
  }

  late final Map<Type, List<MethodDefinition>> methodsPerOwnerType =
      _createMethodsPerOwnerType();

  Map<String, List<MethodDefinition>> _createMethodsPerMethodName() {
    var methodsPerMethodName = <String, List<MethodDefinition>>{};
    for (var method in methods) {
      var lowerCaseMethodName = method.name.toLowerCase();
      if (!methodsPerMethodName.containsKey(lowerCaseMethodName)) {
        methodsPerMethodName[lowerCaseMethodName] = <MethodDefinition>[];
      }
      methodsPerMethodName[lowerCaseMethodName]!.add(method);
    }
    return methodsPerMethodName;
  }

  late final Map<String, List<MethodDefinition>> _methodLookUp =
      _createMethodsPerMethodName();

  StatementDefinition? findStatementDefinition(CodeTokenStream tokenStream) {
    for (final statementDef in statements) {
      if (statementDef.matches(tokenStream.clone())) {
        return statementDef;
      }
    }
    return null;
  }

  FunctionDefinition? findFunction(String lowerCaseFunctionName) =>
      _functionLookUp[lowerCaseFunctionName];

  List<MethodDefinition>? findMethod(String lowerCaseMethodName) =>
      _methodLookUp[lowerCaseMethodName];

  ConstantDefinition? findConstant(String lowerCaseConstantName) =>
      _constantLookUp[lowerCaseConstantName];

  DataTypeDefinition? findDataTypeDefinition(List<CodeToken> tokens) =>
      dataTypes.firstWhereOrNull((d) => d.matches(tokens));

  BinaryOperatorDefinition? findBinaryOperator(
    String lowerCaseOperatorSymbol,
  ) => _binaryOperatorLookUp[lowerCaseOperatorSymbol];

  UnaryOperatorDefinition? findUnaryOperator(String lowerCaseOperatorSymbol) =>
      _unaryOperatorLookUp[lowerCaseOperatorSymbol];
}
