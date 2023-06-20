import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/parser/tag/tag_variable.dart';

void main() {
  given('Variables', () {
    var variables = Variables({
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    });

    when('getting variable name paths', () {
      var variableNamePaths = variables.namePaths;
      then('expect the correct (nested) name paths', () {
        variableNamePaths.should.be([
          'person',
          'person.name',
          'person.age',
          'person.child',
          'person.child.name',
          'person.child.age',
        ]);
      });
    });

    when('calling value("person")', () {
      var value = variables.value('person');
      then('expect: person map', () {
        value.toString().should.be({
              'name': 'John Doe',
              'age': 30,
              'child': {
                'name': 'Jane Doe',
                'age': 5,
              }
            }.toString());
      });
    });

    when('calling value("person.name")', () {
      var value = variables.value('person.name');
      then('expect: "John Doe"', () {
        value.should.be('John Doe');
      });
    });

    when('calling value("person.age")', () {
      var value = variables.value('person.age');
      then('expect: 30', () {
        value.should.be(30);
      });
    });

    when('calling value("person.child")', () {
      var value = variables.value('person.child');
      then('expect: person map', () {
        value.toString().should.be({
              'name': 'Jane Doe',
              'age': 5,
            }.toString());
      });
    });

    when('calling value("person.child.name")', () {
      var value = variables.value('person.child.name');
      then('expect: "Jane Doe"', () {
        value.should.be('Jane Doe');
      });
    });

    when('calling value("person.child.age")', () {
      var value = variables.value('person.child.age');
      then('expect: 5', () {
        value.should.be(5);
      });
    });
  });

  given('VariableName', () {
    when('calling validate("a")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => VariableName.validate('a'));
      });
    });

    when('calling validate("ab")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => VariableName.validate('ab'));
      });
    });
    when('calling validate("a1")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => VariableName.validate('a1'));
      });
    });
    when('calling validate("a11")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => VariableName.validate('a11'));
      });
    });

    when('calling validate("1")', () {
      then('should throw a correct error', () {
        Should.throwException<VariableException>(
                () => VariableName.validate('1'))!
            .message
            .should
            .be('Variable name: "1" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("@")', () {
      then('should throw a correct error', () {
        Should.throwException<VariableException>(
                () => VariableName.validate('@'))!
            .message
            .should
            .be('Variable name: "@" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("ab.1")', () {
      then('should throw a correct error', () {
        Should.throwException<VariableException>(
                () => VariableName.validate('1'))!
            .message
            .should
            .be('Variable name: "1" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("ab@")', () {
      then('should throw a correct error', () {
        Should.throwException<VariableException>(
                () => VariableName.validate('ab@'))!
            .message
            .should
            .be('Variable name: "ab@" is invalid: '
                'end of input expected at position: 2');
      });
    });

    when('calling validate("ab1.@")', () {
      then('should throw a correct error', () {
        Should.throwException<VariableException>(
                () => VariableName.validate('ab1.@'))!
            .message
            .should
            .be('Variable name: "ab1.@" is invalid: '
                'end of input expected at position: 3');
      });
    });
  });

  given('Variables with correct names', () {
    var variable = Variables({'name': 'John Doe', 'age': 30});
    when('calling validateNames()', () {
      then('should not throw Exception', () {
        Should.notThrowException(() => variable.validateNames());
      });
    });
  });

  given('Variables with correct and incorrect name', () {
    when('calling validateNames()', () {
      then('should throw a correct exception', () {
        Should.throwException<VariableException>(
                () => Variables({'name': 'John Doe', 'age:': 30}))!
            .message
            .should
            .be('Variable name: "age:" is invalid: '
                'end of input expected at position: 3');
      });
    });
  });

  given('Variables with correct and incorrect name', () {
    when('calling validateNames()', () {
      then('should throw a correct exception', () {
        Should.throwException<VariableException>(() => Variables({
                  'child': {'n@me': 'Jane Doe'}
                }))!
            .message
            .should
            .be('Variable name: "child.n@me" is invalid: '
                'end of input expected at position: 7');
      });
    });
  });

  given('Variables with correct and incorrect names', () {
    when('calling validateNames()', () {
      then('should throw a correct exception', () {
        Should.throwException<VariableException>(() => Variables({
                  'name': 'John Doe',
                  '@ge': 30,
                  'child': {
                    'n@me': 'Jane Doe',
                    'age': 5,
                  }
                }))!
            .message
            .should
            .be('Variable name: "@ge" is invalid: '
                'letter expected at position: 0\n'
                'Variable name: "child.n@me" is invalid: '
                'end of input expected at position: 7');
      });
    });
  });
}
