void main() {
  final a = [
    [1, 2],
    [3, 4],
    [5, 6]
  ];

  // final resul = a.fold([], (previousValue, element) {
  //   print("Prev: $previousValue");
  //   print(element);
  //   previousValue.addAll(element);
  //   return previousValue;
  // });
  final resul = fold(a, [], (p0, p1) {
    p0.addAll(p1);
    return p0;
  });
  print(resul);
}

List fold(
  List source,
  List previousValue,
  List Function(dynamic, dynamic) callback,
) {
  for (final nextValue in source) {
    callback(previousValue, nextValue);
  }
  return previousValue;
}


/// hold
/// [
/// {name: Size, attributes: ({name: X}, {name: XL}, {name: S})}, 
/// {name: Color, attributes: ({name: Red}, {name: Green}, {name: Blue})}, 
/// {name: Package, attributes: ({name: Gold}, {name: Sliver})}
/// ]
/// []
/// 1. [[{name: X}, {name: XL}, {name: S}],[{name: Red}, {name: Green}, {name: Blue}],[{name: Gold}, {name: Sliver}]]
/// 
/// 2. pick first array [{name: X}, {name: XL}, {name: S}] ->[[{name: Red}, {name: Green}, {name: Blue}],[{name: Gold}, {name: Sliver}]]
/// 
/// {name: X} -> 
/// [{name: Red}, {name: Green}, {name: Blue}] -> {name: X},{name: Red}|{name: X},{name: Green}
/// 
/// 
/// [{name: Gold}, {name: Sliver}], {name: X},{name: Red},{name: Gold}|  {name: X},{name: Red},{name: Sliver}
/// 
/// expect
/// [{name: Size},{name: Red},{name: Gold}],....
/// 
/// x,red | x,green | x,blue ,xl,red | xl,green | xl,blue ,
/// x,red,gold,
/// 
