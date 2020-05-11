class ProductPrice {
  String id;
  String name;
  int price;
  String priceFormat;
  String unit;
  int maxQty;

  ProductPrice(
      {this.id,
        this.name,
        this.price,
        this.priceFormat,
        this.unit,
        this.maxQty});

  ProductPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    priceFormat = json['price_format'];
    unit = json['unit'];
    maxQty = json['max_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['unit'] = this.unit;
    data['max_qty'] = this.maxQty;
    return data;
  }
}