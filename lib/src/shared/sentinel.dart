class Sentinel<T> {
  const Sentinel.absent() : hasValue = false, value = null;
  const Sentinel.of(this.value) : hasValue = true;

  final bool hasValue;
  final T? value;
}
