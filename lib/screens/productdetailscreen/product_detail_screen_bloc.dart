import 'dart:ui';

import 'package:famili/constants/colors.dart';
import 'package:famili/core/data/models/product_price.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/core/data/response/product_price_collection.dart';
import 'package:famili/core/data/response/product_response.dart';
import 'package:famili/core/repository/product_repository.dart';
import 'package:famili/core/rx_api.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailScreenBloc {
  QuantityCounter _quantityCounter =
      QuantityCounter(quantity: 1, maxQuantity: 1);
  final ProductRepository _repo = ProductRepository();
  final PublishSubject<ProductResponse> _productSubject =
      PublishSubject<ProductResponse>();
  final BehaviorSubject<ProductPriceCollection> _productPriceSubject =
      BehaviorSubject<ProductPriceCollection>();
  final PublishSubject<UIModelChanges> _uiModelSubject =
      PublishSubject<UIModelChanges>();
  final BehaviorSubject<ProductPrice> _currentPriceSubject =
      BehaviorSubject<ProductPrice>();
  final BehaviorSubject<ProductCollection> _relatedProductSubject =
      BehaviorSubject<ProductCollection>();
  BehaviorSubject<QuantityCounter> _productQtySubject;

  ProductDetailScreenBloc() {
    _productQtySubject =
        BehaviorSubject<QuantityCounter>.seeded(_quantityCounter);
  }

  void getProductById(String id) => rxApi(
        repository: _repo.getProduct(id),
        subject: _productSubject,
      );

  void getProductPrice(String id) {
    rxApi(
      repository: _repo.getProductPrice(id),
      subject: _productPriceSubject,
    );
  }

  void getRelatedProductById(String id) => rxApi(
        repository: _repo.getRelatedProducts(id),
        subject: _relatedProductSubject,
      );

  void changeCurrentPrice(ProductPrice price) {
    _currentPriceSubject.sink.add(price);
    _quantityCounter.setMaxQuantity(price.maxQty);
    _quantityCounter.setQuantity(1);
    _productQtySubject.sink.add(_quantityCounter);
  }

  void updateUi(UIModelChanges value) {
    _uiModelSubject.sink.add(value);
  }

  void plusQuantity() {
    _quantityCounter.plusQty();
    _productQtySubject.sink.add(_quantityCounter);
  }

  void minusQuantity() {
    _quantityCounter.minusQty();
    _productQtySubject.sink.add(_quantityCounter);
  }

  void dispose() {
    _productSubject.close();
    _productPriceSubject.close();
    _uiModelSubject.close();
    _currentPriceSubject.close();
    _productQtySubject.close();
    _relatedProductSubject.close();
  }

  PublishSubject<ProductResponse> get productSubject => _productSubject;

  BehaviorSubject<ProductPriceCollection> get productPriceSubject =>
      _productPriceSubject;

  BehaviorSubject<ProductCollection> get relatedProductSubject =>
      _relatedProductSubject;

  PublishSubject<UIModelChanges> get uiModelSubject => _uiModelSubject;

  BehaviorSubject<ProductPrice> get currentPriceSubject => _currentPriceSubject;

  ProductPrice get currentPriceValue => _currentPriceSubject.stream.value;

  BehaviorSubject<QuantityCounter> get productQuantitySubject =>
      _productQtySubject;

  int get currentQty => _productQtySubject.stream.value.quantity;

  int get maxQty => _productQtySubject.stream.value.maxQuantity;
}

final productDetailBloc = ProductDetailScreenBloc();

class UIModelChanges {
  String title;
  Color iconColor;

  UIModelChanges({this.title, this.iconColor});
}

final initialUiModel = UIModelChanges(title: "", iconColor: ColorBase.white);
