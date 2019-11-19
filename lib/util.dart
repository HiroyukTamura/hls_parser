class Util {
  static void assertNonNull(List params) {
    assert(params != null);
    params.forEach((it) {
      assert(it != null);
    });
  }
}
