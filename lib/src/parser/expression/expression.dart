import 'package:template_engine/template_engine.dart';

import 'package:collection/collection.dart';

abstract class Expression {
  Future<dynamic> evaluate(RenderContext context);
}

class LiteralExpression extends Expression {
  final dynamic value;
  LiteralExpression(this.value);

  @override
  Future<dynamic> evaluate(RenderContext context) => Future.value(value);

  @override
  String toString() => value.toString();

  final _deepEq = const DeepCollectionEquality();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LiteralExpression && _deepEq.equals(other.value, value);
  }

  @override
  int get hashCode => _deepEq.hash(value);
}

class ListExpression extends Expression {
  final List<Expression> items;
  ListExpression(this.items);

  @override
  Future<List> evaluate(RenderContext context) async {
    final evaluatedItems = <dynamic>[];
    for (final item in items) {
      evaluatedItems.add(await item.evaluate(context));
    }
    return evaluatedItems;
  }

  @override
  String toString() => '[${items.join(', ')}]';
}

class SetExpression extends Expression {
  final Set<Expression> items;
  SetExpression(this.items);

  @override
  Future<Set> evaluate(RenderContext context) async {
    final evaluatedItems = <dynamic>{};
    for (final item in items) {
      evaluatedItems.add(await item.evaluate(context));
    }
    return evaluatedItems;
  }

  @override
  String toString() => '{${items.join(', ')}}';
}

class MapExpression extends Expression {
  final Map<Expression, Expression> mapWithExpressions;

  MapExpression(this.mapWithExpressions);

  @override
  Future<dynamic> evaluate(RenderContext context) async {
    final evaluatedMap = <dynamic, dynamic>{};
    for (final entry in mapWithExpressions.entries) {
      final key = await entry.key.evaluate(context);
      final value = await entry.value.evaluate(context);
      evaluatedMap[key] = value;
    }
    return evaluatedMap;
  }
}
