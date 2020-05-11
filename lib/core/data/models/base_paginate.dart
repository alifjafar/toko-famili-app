abstract class BasePaginate<T, V> {
  List<T> data;
  int lastPage;
  int nextPage;
  bool isLoading;

  BasePaginate add(V newData, bool isLoading);

  BasePaginate addMore(V newData, bool isLoading);
}
