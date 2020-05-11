import 'package:famili/core/base_bloc.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/core/repository/product_repository.dart';
import 'package:famili/core/rx_api.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc implements BaseBloc {
  final ProductRepository _repo = ProductRepository();
  final BehaviorSubject<ProductCollection> _productsRemoteSubject =
      BehaviorSubject<ProductCollection>();
  final BehaviorSubject<ProductPaginate> _productsSubject =
      BehaviorSubject<ProductPaginate>();

  HomeScreenBloc() {
    _productsRemoteSubject.listen(
      (value) {
        if (value == null && _productsSubject.stream.hasValue) {
          print("LOADING");
          var lastProduct = _productsSubject.stream.value;
          lastProduct.isLoading = true;
          _productsSubject.add(lastProduct);
        } else if (value?.meta?.pagination?.currentPage == 1) {
          _productsSubject.sink.add(ProductPaginate().add(value, false));
        } else if (value != null) {
          var lastProduct = _productsSubject.stream.value;
          _productsSubject.add(lastProduct.addMore(value, false));
        }
      },
      onError: (error) => _productsSubject.sink.addError(error),
    );
  }

  getProducts({int page = 1}) => rxApi(
      repository: _repo.getProducts(page: page),
      subject: _productsRemoteSubject,
      clear: true);

  BehaviorSubject<ProductPaginate> get productsSubject => _productsSubject;

  int get lastPage => _productsSubject.stream.value?.lastPage ?? 1;
  int get nextPage => _productsSubject.stream.value?.nextPage ?? null;
  bool get isLoading => _productsSubject.stream.value?.isLoading ?? false;

  @override
  void dispose() async {
    await _productsSubject.drain();
    _productsSubject.close();
  }
}

final homeBloc = HomeScreenBloc();
