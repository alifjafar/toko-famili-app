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

class QuantityCounter {
  int quantity;
  int maxQuantity;

  QuantityCounter({this.quantity = 1, this.maxQuantity = 1});

  void plusQty() {
    if (maxQuantity > quantity) {
      quantity++;
    }
  }

  void minusQty() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void setMaxQuantity(int value) {
    maxQuantity = value;
  }

  void setQuantity(int value) {
    quantity = value;
  }
}
