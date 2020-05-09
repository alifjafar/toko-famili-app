import 'package:famili/core/base_bloc.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/core/repository/product_repository.dart';
import 'package:famili/core/rx_api.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc implements BaseBloc {
  final ProductRepository _repo = ProductRepository();
  final BehaviorSubject<ProductCollection> _productsSubject =
      BehaviorSubject<ProductCollection>();

  getProducts() => rxApi(
    repository: _repo.getProducts(),
    subject: _productsSubject
  );

  BehaviorSubject<ProductCollection> get productsSubject => _productsSubject;

  @override
  void dispose() async {
    await _productsSubject.drain();
    _productsSubject.close();
  }
}

final homeBloc = HomeScreenBloc();