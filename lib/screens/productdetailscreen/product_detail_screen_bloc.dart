import 'dart:ui';

import 'package:famili/constants/colors.dart';
import 'package:famili/core/data/models/product_price.dart';
import 'package:famili/core/data/response/product_price_collection.dart';
import 'package:famili/core/data/response/product_response.dart';
import 'package:famili/core/repository/product_repository.dart';
import 'package:famili/core/rx_api.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailScreenBloc {
  final ProductRepository _repo = ProductRepository();

  final PublishSubject<ProductResponse> _productSubject =
      PublishSubject<ProductResponse>();
  final BehaviorSubject<ProductPriceCollection> _productPriceSubject =
      BehaviorSubject<ProductPriceCollection>();
  final PublishSubject<UIModelChanges> _uiModelSubject =
      PublishSubject<UIModelChanges>();
  final BehaviorSubject<ProductPrice> _currentPriceSubject =
      BehaviorSubject<ProductPrice>();

  getProductById(String id) => rxApi(
        repository: _repo.getProduct(id),
        subject: _productSubject,
      );

  getProductPrice(String id) {
    rxApi(
      repository: _repo.getProductPrice(id),
      subject: _productPriceSubject,
    );
  }

  changeCurrentPrice(ProductPrice price) {
    _currentPriceSubject.sink.add(price);
  }

  updateUi(UIModelChanges value) {
    _uiModelSubject.sink.add(value);
  }

  void dispose() {
    _productSubject.close();
    _productPriceSubject.close();
    _uiModelSubject.close();
    _currentPriceSubject.close();
  }

  PublishSubject<ProductResponse> get productSubject => _productSubject;

  BehaviorSubject<ProductPriceCollection> get productPriceSubject =>
      _productPriceSubject;

  PublishSubject<UIModelChanges> get uiModelSubject => _uiModelSubject;

  BehaviorSubject<ProductPrice> get currentPriceSubject => _currentPriceSubject;

  ProductPrice get currentPriceValue => _currentPriceSubject.stream.value;
}

final productDetailBloc = ProductDetailScreenBloc();

class UIModelChanges {
  String title;
  Color iconColor;

  UIModelChanges({this.title, this.iconColor});
}

final initialUiModel = UIModelChanges(title: "", iconColor: ColorBase.white);
