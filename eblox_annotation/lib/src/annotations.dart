class StateBase{
  final String? name;

  const StateBase({this.name});
}

class StateX extends StateBase{
  const StateX({String? name}):super(name: name);
}

class AsyncX extends StateBase{
  const AsyncX({String? name}):super(name: name);
}

class ActionX{
    final String? name;
    final String bind;
    const ActionX({this.name,required this.bind});
}

class BindAsync{
  const BindAsync();
}

const bindAsync = BindAsync();

class BloX {
  const BloX();
}

const bloX = BloX();