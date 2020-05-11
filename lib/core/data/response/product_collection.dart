import 'package:famili/core/data/models/base_paginate.dart';
import 'package:famili/core/data/models/meta.dart';
import 'package:famili/core/data/models/product.dart';
import 'base_response.dart';

class ProductCollection extends BaseResponse {
  List<Product> data;

  ProductCollection({String message, this.data, Meta meta})
      : super(message, meta);

  ProductCollection.fromJson(Map<String, dynamic> json)
      : data = (json["data"] as List)
            .map((item) => Product.fromJson(item))
            .toList(),
        super.fromJson(json);
}

class ProductPaginate implements BasePaginate<Product, ProductCollection> {
  @override
  List<Product> data;

  @override
  bool isLoading;

  @override
  int lastPage;

  @override
  int nextPage;

  ProductPaginate({this.data, this.isLoading, this.lastPage, this.nextPage});

  @override
  ProductPaginate addMore(ProductCollection newData, bool isLoading) {
    this.data.addAll(newData.data);
    this.lastPage = newData.meta.pagination.currentPage;
    this.nextPage = newData.meta.pagination?.to ?? null;
    this.isLoading = isLoading;
    return this;
  }

  @override
  BasePaginate add(ProductCollection newData, bool isLoading) {
    this.data = newData.data;
    this.lastPage = newData.meta.pagination.currentPage;
    this.nextPage = newData.meta.pagination?.to ?? null;
    this.isLoading = isLoading;
    return this;
  }
}
