import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nzuri_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../colors/colors.dart';
import '../../models/product_model.dart';
import '../../strings/my_cart_screen_strings.dart';
import '../home_screen/home_screen.dart';

void main() {
  runApp(const MyCartScreen());
}

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CartScreen(),
      );
    });
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Future<List<Product>>? myCartProducts;

  @override
  void initState() {
    myCartProducts = Provider.of<ProductProvider>(context, listen: false)
        .getAllCartItemsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Get all cart products
    // final myCartProducts = context.watch<ProductProvider>().cartProducts;

    //Get total cart amount
    final double total = context.watch<ProductProvider>().totalCartAmount;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: kBackgroundColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomeScreen()));
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: kPrimaryColor,
            ),
          ),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cartAppBarTitle,
                style: GoogleFonts.robotoSlab(
                    color: kTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      total.toString(),
                      style: GoogleFonts.robotoSlab(
                          color: kPrimaryColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Icon(
                      Icons.currency_exchange_outlined,
                      size: 4.w,
                      color: kIconsColor,
                    ),
                  ],
                ),
            ],
          ),
          elevation: 0),
      body: SingleChildScrollView(
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) => Container(
                width: double.infinity,
                height: 100.h,
                decoration: BoxDecoration(color: kBackgroundColor),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 5.w, 3.w, 2.w),
                  child: ListView.builder(
                      itemCount: productProvider.cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.cartProducts;
        
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Card(
                              color: kProductCardColor,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.w)),
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20.w,
                                          height: 15.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.w))),
                                          child: Image.network(
                                            product[index].image,
                                            width: double.infinity,
                                            height: 19.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 45.w,
                                                child: Text(
                                                  product[index].title,
                                                  style: GoogleFonts.robotoSlab(
                                                      color: kTextColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  softWrap: false,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.w,
                                              ),
                                              Row(
                                                children: [
                                                  Text(product[index].price,
                                                      style:
                                                          GoogleFonts.robotoSlab(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  Text('\$',
                                                      style:
                                                          GoogleFonts.robotoSlab(
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
                                        context
                                            .read<ProductProvider>()
                                            .removeFromCart(product[index]);
                                      }),
                                      child: Icon(
                                        Icons.delete_forever_outlined,
                                        size: 7.w,
                                        color: kPrimaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        );
                      }),
                ),
              ),
        ),
      ),
    ));
  }
}
