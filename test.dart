abstract class WhereOperator {
  const WhereOperator();

  @override
  String toString();
}

const _sqlOperator = [
  "=",
  "!=",
  ">",
  ">=",
  "<",
  "<=",
  "in",
  "is null",
  "is not null"
];

class FieldValidator extends WhereOperator {
  final String columnName;

  final String operationSign;
  final String value;

  FieldValidator({
    required this.columnName,
    required this.operationSign,
    required this.value,
  }) : assert(
          _sqlOperator.contains(operationSign) &&
              (value.isEmpty &&
                  (operationSign == "is null" ||
                      operationSign == "is not null")) &&
              (value.isNotEmpty &&
                  (operationSign != "is null" &&
                      operationSign != "is not null")),
        );

  @override
  String toString() {
    return "$columnName $operationSign $value";
  }
}

class AndOp extends WhereOperator {
  const AndOp();

  @override
  String toString() {
    return "and";
  }
}

class OrOp extends WhereOperator {
  const OrOp();

  @override
  String toString() {
    return "or";
  }
}

void main() async {
  assert(true);

  /// select * from users where
  /// birthday is not null;
  final List<WhereOperator> where = [];

  where.add(FieldValidator(
      columnName: "birthday", operationSign: "is not null", value: 'a'));

  print(where.join(" "));

  // final createBloc = CreateBloc(5, 5);
  // print(createBloc.controllers);
}
