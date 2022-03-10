class Nullable<T> {
  Nullable(T? value) : _value = value;

  final T? _value;

  T? get value => _value;
}
