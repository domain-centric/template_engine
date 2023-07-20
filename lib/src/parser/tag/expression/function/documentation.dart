import 'package:template_engine/template_engine.dart';

/// Functions that create documentation of the [TemplateEngine] configuration
class DocumentationFunctions extends FunctionGroup {
  DocumentationFunctions()
      : super(
            'Functions to generate markdown Template Engine Documentation. '
            'It is likely that the documentation that you are currently reading'
            ' was generated using these expression functions',
            [
              TagDocumentation(),
              //TODO basetypes
              //TODO constants
              //TODO variables
              //TODO operators
              //TODO functions
            ]);
}

class TagDocumentation extends ExpressionFunction<String> {
  TagDocumentation()
      : super(
            name: 'engine.tag.documentation',
            description: 'Generates markdown documentation of all the tags '
                'within a TemplateEngine',
            parameters: [
              Parameter<num>(
                  name: 'titleLevel',
                  description: 'The level of the tag title (default=1)',
                  presence: Presence.optionalWithDefaultValue(1))
            ],
            function: (renderContext, parameters) {
              var titleLevel = parameters['titleLevel'];
              if (titleLevel is! int) {
                throw ParameterException(
                    'Parameter titleLevel: must be a integer');
              }
              if (titleLevel < 1 && titleLevel > 10) {
                throw ParameterException(
                    'Parameter titleLevel: must be a number >=1 and <=10');
              }

              var markdown = StringBuffer();

              for (Tag tag in renderContext.engine.tags) {
                markdown.write('#' * (titleLevel));
                markdown.write(' ${tag.name}\n');
                markdown.write('${tag.documentation(renderContext.engine)}\n');
              }
              return markdown.toString();
            });
}
