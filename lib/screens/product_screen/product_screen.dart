import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nzuri_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../colors/colors.dart';
import '../../models/product_model.dart';
import '../../strings/product_screen_strings.dart';
import '../home_screen/home_screen.dart';

void main() {
  runApp(ProductScreen(
    product: [],
    index: 0,
  ));
}

class ProductScreen extends StatelessWidget {
  List<Product> product;
  int index;

  ProductScreen({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ProductDetailsPage(productList: product, index: index),
        );
      },
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  //Receive a map of product
  final List<Product> productList;
  final int index;

  const ProductDetailsPage(
      {super.key, required this.productList, required this.index});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //Get cart products
    List<Product> cartProducts =
        Provider.of<ProductProvider>(context, listen: false).cartProducts;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kBackgroundColor,
            leading: GestureDetector(
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomeScreen()));
              }),
              child: Icon(
                Icons.arrow_back_ios,
                color: kPrimaryColor,
              ),
            ),
            centerTitle: true,
            title: Text(
              productDetailsTitle,
              style: GoogleFonts.robotoSlab(
                  color: kTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600),
            ),
            elevation: 0),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) => SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(color: kBackgroundColor),
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 8.w, 4.w, 2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 100.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: kProductCardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: Image.network(
                              widget.productList[widget.index].image,
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                            ))),
                    SizedBox(
                      height: 2.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.productList[widget.index].title,
                                style: GoogleFonts.robotoSlab(
                                  color: kHeadingTextColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.star_border_outlined,
                              color: kIconsColor,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              widget.productList[widget.index].rating.rate,
                              style: GoogleFonts.robotoSlab(
                                  color: kIconsColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.productList[widget.index].price,
                              style: GoogleFonts.robotoSlab(
                                  color: kPrimaryColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '\$',
                              style:
                                  GoogleFonts.robotoSlab(color: kPrimaryColor),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(productDescription,
                            style: GoogleFonts.robotoSlab(
                                color: kHeadingTextColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.w),
                        Text(
                          widget.productList[widget.index].description,
                          style: GoogleFonts.robotoSlab(
                              color: kTextColor, fontSize: 10.sp),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    GestureDetector(
                      onTap: (() {
                        if (cartProducts
                            .contains(widget.productList[widget.index])) {
                          context
                              .read<ProductProvider>()
                              .removeFromCart(widget.productList[widget.index]);
                          
                        } else {
                          context
                              .read<ProductProvider>()
                              .addToCart(widget.productList[widget.index]);
                        }
                      }),
                      child: Container(
                        width: 100.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.w))),
                        child: Center(
                          child: Text(
                            cartProducts
                                    .contains(widget.productList[widget.index])
                                ? removeToCart
                                : addToCart,
                            style: GoogleFonts.robotoSlab(
                                color: kButtonTextColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
