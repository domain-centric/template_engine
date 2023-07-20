import 'package:template_engine/template_engine.dart';

class StringFunctions extends FunctionGroup {
  StringFunctions()
      : super('String', [
          StringLength(),
        ]);
}

class StringLength extends ExpressionFunction<num> {
  StringLength()
      : super(
            name: 'length',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) {
              var value = parameters['value'];
              if (value is String) {
                return value.length;
              } else {
                throw ParameterException('String expected');
              }
            });
}
