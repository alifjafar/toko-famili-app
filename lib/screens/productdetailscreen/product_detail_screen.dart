import 'package:badges/badges.dart';
import 'package:famili/components/api_observer.dart';
import 'package:famili/components/app_bar.dart';
import 'package:famili/components/carousel_pro.dart';
import 'package:famili/components/image_item.dart';
import 'package:famili/components/key_value_item.dart';
import 'package:famili/components/product/product_list_horizontal.dart';
import 'package:famili/components/product/product_list_horizontal_loading.dart';
import 'package:famili/components/skeleton.dart';
import 'package:famili/constants/colors.dart';
import 'package:famili/constants/constants.dart';
import 'package:famili/core/data/models/product.dart';
import 'package:famili/core/data/models/product_price.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/core/data/response/product_price_collection.dart';
import 'package:famili/core/data/response/product_response.dart';
import 'package:famili/core/navigation_service.dart';
import 'package:famili/injection.dart';
import 'package:famili/screens/productdetailscreen/product_detail_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sprintf/sprintf.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  final Product product;

  ProductDetailScreen({this.id, this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double scrollConstraint = 110;
  var productDetailBloc = ProductDetailScreenBloc();

  @override
  void initState() {
    super.initState();
    productDetailBloc.getProductById(widget.id);
    productDetailBloc.getProductPrice(widget.id);
    productDetailBloc.getRelatedProductById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[buildSliverApp(context)];
          },
          body: buildStream(context),
        ),
        bottomNavigationBar: _buildBottomContainer(_size));
  }

  Widget buildSliverApp(BuildContext context) {
    var platform = Theme.of(context).platform;
    final positionedGradient = Positioned(
        child: Container(
            height: 80,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.black87, Colors.transparent]))));

    void onScroll(double top) {
      if (top <= scrollConstraint) {
        productDetailBloc.updateUi(UIModelChanges(
            title: widget.product.name, iconColor: Colors.black));
      } else {
        productDetailBloc.updateUi(initialUiModel);
      }
    }

    Brightness changeBrightness(String title) {
      if (platform == TargetPlatform.iOS) {
        if (title.isEmpty) {
          return Brightness.dark;
        } else {
          return Brightness.light;
        }
      } else {
        return Brightness.light;
      }
    }

    return StreamBuilder<UIModelChanges>(
        stream: productDetailBloc.uiModelSubject.stream,
        builder: (context, snapshot) {
          var uiModel = snapshot.hasData ? snapshot.data : initialUiModel;
          var brightness = changeBrightness(uiModel.title);

          return SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              centerTitle: false,
              brightness: brightness,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: uiModel.iconColor),
              title: Text(uiModel.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              actions: <Widget>[
                Badge(
                  badgeContent: Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  animationType: BadgeAnimationType.slide,
                  position: BadgePosition.topRight(top: 5, right: 7),
                  child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: uiModel.iconColor,
                      ),
                      onPressed: null),
                )
              ],
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  onScroll(constraints.biggest.height);
                  return FlexibleSpaceBar(
                      background: Stack(children: <Widget>[
                    buildCarouselImage(widget.product.images),
                    positionedGradient
                  ]));
                },
              ));
        });
  }

  Widget buildStream(context) {
    return Container(
      child: ApiObserver<ProductResponse>(
        stream: productDetailBloc.productSubject.stream,
        onSuccess: (context, response) => buildBody(response.data),
        onErrorReload: () {
          productDetailBloc.getProductById(widget.id);
        },
      ),
    );
  }

  Widget buildBody(Product product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: Text(
              product.name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<ProductPrice>(
                      stream: productDetailBloc.currentPriceSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var price = snapshot.data;
                          return Text(
                            sprintf(Constant.baseCurrency,
                                [price.priceFormat, price.unit]),
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: ColorBase.redOrange),
                          );
                        } else {
                          return Skeleton(height: 20);
                        }
                      }),
                ),
                Expanded(
                  child: _buildCounter(),
                ),
              ],
            ),
          ),
          _buildProductPrice(),
          Divider(
            color: ColorBase.whiteGray,
            thickness: 6.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: Text(
              Constant.informationProduct,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
            ),
          ),
          KeyValueItem(
            left: Text(Constant.category),
            right: Text(product.category.name),
          ),
          KeyValueItem(
            left: Text(Constant.stock),
            right: StreamBuilder<ProductPrice>(
                stream: productDetailBloc.currentPriceSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var price = snapshot.data;
                    return Text(
                        "${price.maxQty} ${price.name.split(" (").first}");
                  } else {
                    return Text("-");
                  }
                }),
          ),
          Divider(
            color: ColorBase.whiteGray,
            thickness: 2.0,
          ),
          Container(
              margin: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 3.0, bottom: 8.0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: product.description,
                    style: TextStyle(color: Colors.black)),
              )),
          Divider(
            color: ColorBase.whiteGray,
            thickness: 6.0,
          ),
          ApiObserver<ProductCollection>(
            stream: productDetailBloc.relatedProductSubject.stream,
            onSuccess: (context, response) => ProductListHorizontalItem(
              response,
              Constant.otherProduct,
              titlePadding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              titleColor: Colors.black87,
              onTap: null,
            ),
            onWaiting: (context) => ProductListHorizontalLoading(),
            onErrorReload: () {
              productDetailBloc.getRelatedProductById(widget.id);
            },
          )
        ],
      ),
    );
  }

  Widget _buildBottomContainer(Size size) {
    return Container(
      width: size.width,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.7, color: ColorBase.whiteGray),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: size.width / 1.6,
            child: FlatButton(
              color: ColorBase.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              onPressed: () {},
              child: Text(
                Constant.buyNow,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          FlatButton(
              color: Colors.orange[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 16,
                  ),
                  Text(
                    Constant.cart,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProductPrice() {
    return ApiObserver(
      stream: productDetailBloc.productPriceSubject.stream,
      onSuccess: (context, ProductPriceCollection response) =>
          _buildProductPriceData(response),
      onErrorReload: () {
        productDetailBloc.getProductPrice(widget.id);
      },
      onWaiting: (context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Skeleton(height: 20),
      ),
    );
  }

  Widget _buildProductPriceData(ProductPriceCollection prices) {
    productDetailBloc.changeCurrentPrice(prices.data.first);

    return Visibility(
      visible: prices.data.length > 1,
      child: GestureDetector(
        onTap: () => _showBottomSheet(prices),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Ganti Harga",
                      style: TextStyle(
                          color: ColorBase.primary,
                          fontWeight: FontWeight.bold)),
                  Text("(tersedia ${prices.data.length} harga)",
                      style: TextStyle(color: Colors.black54))
                ],
              ),
            ),
//            Container(
//              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
//              child: Container(
//                padding: EdgeInsets.all(8.0),
//                child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      StreamBuilder<ProductPrice>(
//                          stream: productDetailBloc.currentPriceSubject.stream,
//                          builder: (context, snapshot) {
//                            if (snapshot.hasData) {
//                              return Text("Per ${snapshot.data.name}",
//                                  style: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 16,
//                                      fontWeight: FontWeight.normal));
//                            } else {
//                              return Skeleton(height: 20);
//                            }
//                          }),
//                      SizedBox(
//                          height: 24,
//                          child: Icon(
//                            Icons.keyboard_arrow_down,
//                            color: Colors.black54,
//                          )),
//                    ]),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(8),
//                    color: ColorBase.whiteGray,
//                    boxShadow: [
//                      BoxShadow(
//                        offset: Offset(0, 0),
//                        color: Colors.black12,
//                      ),
//                    ]),
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(ProductPriceCollection priceCollection) {
    var prices = priceCollection.data;

    return showMaterialModalBottomSheet(
      context: context,
      builder: (context, scrollController) {
        return Scaffold(
          backgroundColor: ColorBase.white,
          appBar: AppBarMV(
              title: "Pilih Harga Lain",
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              )),
          body: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: prices.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                var item = prices[index];
                return Column(
                  children: <Widget>[
                    ListTile(
                      dense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                      selected: isCurrentPriceId(item.id),
                      title: Text(item.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Rp${item.priceFormat}"),
                      trailing:
                          isCurrentPriceId(item.id) ? Icon(Icons.check) : null,
                      onTap: () {
                        productDetailBloc.changeCurrentPrice(item);
                        locator<NavigationService>().navigateBack();
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                    )
                  ],
                );
              }),
        );
      },
    );
  }

  bool isCurrentPriceId(String id) {
    return productDetailBloc.currentPriceValue.id == id;
  }

  Widget buildCarouselImage(List<ImageModel> images) {
    List<String> imageUrls = images.map((item) => item.url).toList();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CarouselPro(
        autoplay: false,
        boxFit: BoxFit.cover,
        dotSize: 5.0,
        dotPosition: DotPosition.bottomCenter,
        dotIncreasedColor: ColorBase.primary,
        dotBgColor: Colors.transparent,
        showIndicator: true,
        indicatorBgPadding: 7.0,
        images: List.generate(
            images.length,
            (index) => ImageItem(
                  url: images[index]?.url,
                  height: 200.0,
                  topRounded: false,
                  previewImage: true,
                  initialIndex: index,
                  galleryImages: imageUrls,
                )),
      ),
    );
  }

  Widget _buildCounter() {
    return StreamBuilder<QuantityCounter>(
        stream: productDetailBloc.productQuantitySubject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                        ),
                        shape: BoxShape.rectangle,
                        color: ColorBase.whiteGray),
                    child: Icon(
                      Icons.remove,
                      color: productDetailBloc.currentQty > 1
                          ? Colors.grey[800]
                          : Colors.grey[400],
                    ),
                  ),
                  onTap: () => productDetailBloc.minusQuantity(),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300], width: 2.0),
                        bottom: BorderSide(color: Colors.grey[300], width: 2.0),
                      ),
                      shape: BoxShape.rectangle),
                  child: Text(
                    "${snapshot.data.quantity}",
                    style: TextStyle(fontSize: 17.5),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        ),
                        shape: BoxShape.rectangle,
                        color: ColorBase.whiteGray),
                    child: Icon(
                      Icons.add,
                      color: productDetailBloc.maxQty >
                              productDetailBloc.currentQty
                          ? Colors.grey[800]
                          : Colors.grey[400],
                    ),
                  ),
                  onTap: () => productDetailBloc.plusQuantity(),
                ),
              ],
            );
          } else {
            return Skeleton(height: 20);
          }
        });
  }
}
