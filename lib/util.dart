class Util {
  static void assertNonNull(List params){
    assert(params != null);
  }

  static void assertConditionally(bool condition, param){
    if (condition) {
      assert (param != null);
    }
  }
}