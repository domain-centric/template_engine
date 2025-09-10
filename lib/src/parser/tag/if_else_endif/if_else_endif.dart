import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/generic_parsers/value_context_map_parser.dart';
import 'package:template_engine/src/parser/parser.dart';
import 'package:template_engine/src/parser/tag/expression/expression.dart';
import 'package:template_engine/src/parser/tag/expression/expression_parser.dart';
import 'package:template_engine/src/parser/tag/tag.dart';
import 'package:template_engine/src/project_file_path.dart';
import 'package:template_engine/src/render.dart';

class If implements Renderer, BranchChanger, BranchOwner {
  @override
  final List<Type> followedBy;
  @override
  final List<Type> precededBy;
  @override
  final Position position;
  final Value<bool> condition;
  final Branch trueBranch = Branch();
  final Branch falseBranch = Branch();

  If(IfTag ifTag, this.position, this.condition)
    : precededBy = ifTag.precededBy,
      followedBy = ifTag.followedBy;

  @override
  String toString() =>
      'If(condition: "$condition", trueBranch: $trueBranch, falseBranch $falseBranch)';

  @override
  Branch nextBranch(AbstractStatementTree ast) => trueBranch;

  @override
  Future render(RenderContext context) async {
    var conditionValue = await condition.render(context);
    if (conditionValue) {
      return trueBranch.render(context);
    } else {
      return falseBranch.render(context);
    }
  }

  @override
  late List<Branch> branches = [trueBranch, falseBranch];
}

class IfTag extends Tag<If> implements TagSequence {
  IfTag()
    : super(
        name: 'IF',
        description: ['TODO'],
        example: null,
        exampleResult: null,
        exampleFile: ProjectFilePath('TODO'),
      );

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) {
    // TODO: implement createMarkdownExamples
    throw UnimplementedError();
  }

  @override
  final List<Type> precededBy = [];

  @override
  final List<Type> followedBy = [Else, EndIf]; //TODO ELSEIf

  @override
  Parser<If> createInnerTagParser(ParserContext parseContext) =>
      (string(name, ignoreCase: true) &
              whitespace().plus() &
              expressionParser(parseContext))
          .valueContextMap(
            (values, context) =>
                If(this, Position.ofContext(context), values[2]),
          );
}

class Else implements BranchChanger {
  @override
  final List<Type> precededBy;

  @override
  final List<Type> followedBy;
  @override
  final Position position;
  @override
  String toString() => 'Else';

  Else(ElseTag elseTag, this.position)
    : precededBy = elseTag.precededBy,
      followedBy = elseTag.followedBy;

  @override
  Branch nextBranch(AbstractStatementTree ast) {
    var parent = ast.findParentNodeOfCurrentBranch();
    if (parent is If) {
      return parent.falseBranch;
    }
    return ast.findParentBranchOfCurrentBranch();
  }
}

class ElseTag extends Tag<Else> implements TagSequence {
  ElseTag()
    : super(
        name: 'Else',
        description: ['TODO'],
        example: null,
        exampleResult: null,
        exampleFile: ProjectFilePath('TODO'),
      );

  @override
  Parser<Else> createInnerTagParser(ParserContext context) =>
      string(name, ignoreCase: true).valueContextMap(
        (value, context) => Else(this, Position.ofContext(context)),
      );

  @override
  final List<Type> precededBy = [If]; //TODO ElseIf

  @override
  final List<Type> followedBy = [EndIf];

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) {
    // TODO: implement createMarkdownExamples
    throw UnimplementedError();
  }
}

class EndIf implements BranchChanger {
  @override
  final List<Type> precededBy;
  @override
  final List<Type> followedBy;
  @override
  final Position position;
  @override
  String toString() => 'EndIf';

  EndIf(EndIfTag endIfTag, this.position)
    : precededBy = endIfTag.precededBy,
      followedBy = endIfTag.followedBy;

  @override
  Branch nextBranch(AbstractStatementTree ast) =>
      ast.findParentBranchOfCurrentBranch();
}

class EndIfTag extends Tag<EndIf> implements TagSequence {
  EndIfTag()
    : super(
        name: 'EndIf',
        description: ['TODO'],
        example: null,
        exampleResult: null,
        exampleFile: ProjectFilePath('TODO'),
      );
  @override
  Parser<EndIf> createInnerTagParser(ParserContext context) =>
      string(name, ignoreCase: true).valueContextMap(
        (value, context) => EndIf(this, Position.ofContext(context)),
      );

  @override
  final List<Type> precededBy = [If, Else]; //TODO ElseIf

  @override
  final List<Type> followedBy = [];

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) {
    // TODO: implement createMarkdownExamples
    throw UnimplementedError();
  }
}
