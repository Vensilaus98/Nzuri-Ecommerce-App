import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nzuri_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../colors/colors.dart';
import '../../models/product_model.dart';
import '../../strings/home_screen_strings.dart';
import '../loader/loader_widget.dart';
import 'widgets/future_builder_grid_widget.dart';
import 'widgets/top_bar_widget.dart';

void main() {
  runApp(const MyHomeScreen());
}

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Create search textfiled controller
  final TextEditingController _controller = TextEditingController();

  Future<List<Product>>? products;
  Future<List<Product>>? cartProducts;
  Future<List<Product>>? searchedProducts;

  bool isSorting = false;

  @override
  void initState() {
    products = Provider.of<ProductProvider>(context, listen: false)
        .getProductsFromApi();
    cartProducts = Provider.of<ProductProvider>(context, listen: false)
        .getAllCartItemsFromDatabase();
    super.initState();
  }

  //Get sorted list of products by price
  getSortedProductsByPrice() {
    isSorting = true;
    products = Provider.of<ProductProvider>(context, listen: false)
        .getSortedProductsByPrice();
    isSorting = false;
  }

  //Get sorted list of products by rate
  getSortedProductsByRate() {
    isSorting = true;
    products = Provider.of<ProductProvider>(context, listen: false)
        .getSortedProductsByRate();
    isSorting = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) => Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(color: kBackgroundColor),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const TopBarWidget(),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 93.w,
                              height: 8.h,
                              child: TextField(
                                controller: _controller,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  //Get search products from provider
                                  Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .searchProductByName(value);

                                  //Open Modal Bottom Sheet for Search Results
                                  showSearchResultsBottomSheetModal(value);
                                  _controller.clear();
                                },
                                decoration: InputDecoration(
                                    focusColor: kFormInputFocusedColor,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: kIconsColor,
                                      size: 6.w,
                                    ),
                                    fillColor: kTextColor,
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    hintText: 'Search keyword',
                                    hintStyle: GoogleFonts.robotoSlab(
                                        color: kPlaceholderColor,
                                        fontSize: 12.sp)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productTitle,
                          style: GoogleFonts.robotoSlab(
                              color: kHeadingTextColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: (() => showSortingsModalBottomSheet()),
                          child: Icon(
                            Icons.sort,
                            size: 8.w,
                            color: kIconsColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    //Display product by categories
                    SizedBox(
                        width: double.maxFinite,
                        child: FutureBuilderGridWidget(
                          products: products,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Create modal bottom sheet for search results
  showSearchResultsBottomSheetModal(String keyword) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.maxFinite,
            height: 80.h,
            decoration: BoxDecoration(color: kBackgroundColor),
            child: Padding(
              padding: EdgeInsets.fromLTRB(3.w, 5.w, 3.w, 2.w),
              child: SizedBox(
                width: double.maxFinite,
                child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) => FutureBuilder(
                          future: productProvider
                              .searchProductByNameFromAPI(keyword),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount:
                                      productProvider.searchedProducts.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Card(
                                          color: kProductCardColor,
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.w)),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 2.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 20.w,
                                                      height: 15.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4.w))),
                                                      child: Image.network(
                                                        productProvider
                                                            .searchedProducts[
                                                                index]
                                                            .image,
                                                        width: double.infinity,
                                                        height: 19.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4.w),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 45.w,
                                                            child: Text(
                                                              productProvider
                                                                  .searchedProducts[
                                                                      index]
                                                                  .title,
                                                              style: GoogleFonts.robotoSlab(
                                                                  color:
                                                                      kTextColor,
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              softWrap: false,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2.w,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  productProvider
                                                                      .searchedProducts[
                                                                          index]
                                                                      .price,
                                                                  style: GoogleFonts.robotoSlab(
                                                                      color:
                                                                          kPrimaryColor,
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              SizedBox(
                                                                width: 1.w,
                                                              ),
                                                              Text('\$',
                                                                  style: GoogleFonts
                                                                      .robotoSlab(
                                                                          color:
                                                                              kPrimaryColor))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: (() {
                                                    if (productProvider
                                                        .cartProducts
                                                        .contains(productProvider
                                                                .searchedProducts[
                                                            index])) {
                                                      context
                                                          .read<
                                                              ProductProvider>()
                                                          .removeFromCart(
                                                              productProvider
                                                                      .searchedProducts[
                                                                  index]);
                                                    } else {
                                                      context
                                                          .read<
                                                              ProductProvider>()
                                                          .addToCart(productProvider
                                                                  .searchedProducts[
                                                              index]);
                                                    }
                                                  }),
                                                  child: Icon(
                                                    productProvider.cartProducts
                                                            .contains(
                                                                productProvider
                                                                        .searchedProducts[
                                                                    index])
                                                        ? Icons.delete
                                                        : Icons
                                                            .shopping_bag_outlined,
                                                    size: 7.w,
                                                    color: kPrimaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 5.w,
                                      color: kIconsColor,
                                    ),
                                    SizedBox(
                                      height: 1.w,
                                    ),
                                    Text(
                                      'Failed to get products',
                                      style: GoogleFonts.robotoSlab(
                                        color: kTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: const LoaderWidget(),
                              ),
                            );
                          },
                        )),
              ),
            ),
          );
        });
  }

  //Create sorting modal bottom sheet
  showSortingsModalBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 15.h,
              decoration: BoxDecoration(
                color: kProductCardColor,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(3.w, 5.w, 3.w, 2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sort,
                          size: 7.w,
                          color: kIconsColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            isSorting ? const LoaderWidget() : '';
                            getSortedProductsByPrice();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            sortByPriceText,
                            style: GoogleFonts.robotoSlab(
                                color: kTextColor, fontSize: 13.sp),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sort,
                          size: 6.w,
                          color: kIconsColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            isSorting ? const LoaderWidget() : '';
                            getSortedProductsByRate();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            sortByRateText,
                            style: GoogleFonts.robotoSlab(
                                color: kTextColor, fontSize: 13.sp),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
