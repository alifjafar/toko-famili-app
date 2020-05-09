class Product {
  String id;
  String name;
  String slug;
  String description;
  Category category;
  int stock;
  int isActive;
  List<ImageModel> images;
  Price price;
  String lastUpdated;

  Product(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.category,
        this.stock,
        this.isActive,
        this.images,
        this.price,
        this.lastUpdated});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    images = List<ImageModel>.from(
        json["images"].map((item) => ImageModel.fromJson(item)));
    stock = json['stock'];
    isActive = json['is_active'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['stock'] = this.stock;
    data['is_active'] = this.isActive;
    if (this.price != null) {
      data['price'] = this.price.toJson();
    }
    data['last_updated'] = this.lastUpdated;
    return data;
  }
}

class Category {
  String id;
  String name;
  String slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Price {
  int price;
  String priceFormat;
  String unit;

  Price({this.price, this.priceFormat, this.unit});

  Price.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    priceFormat = json['price_format'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['unit'] = this.unit;
    return data;
  }
}

class ImageModel {
  int id;
  String url;

  ImageModel(this.id, this.url);

  ImageModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        url = json["url"];
}