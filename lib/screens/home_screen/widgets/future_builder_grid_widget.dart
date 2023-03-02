import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nzuri_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../colors/colors.dart';
import '../../../models/product_model.dart';
import '../../loader/loader_widget.dart';
import '../../product_screen/product_screen.dart';


class FutureBuilderGridWidget extends StatelessWidget {
  
  final Future<List<Product>>? products;

  const FutureBuilderGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => FutureBuilder(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 3.w,
                      mainAxisExtent: 37.h),
                  itemCount: productProvider.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        
                        //Navigate to my product details screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                      product: productProvider.products,
                                      index: index,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: kProductCardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: kBoxShadowColor,
                                  blurRadius: 10,
                                  spreadRadius: 3)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.w)),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Image.network(
                                  productProvider.products[index].image,
                                  width: double.infinity,
                                  height: 19.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(3.w, 2.w, 3.w, 2.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          productProvider.products[index].title,
                                          style: GoogleFonts.robotoSlab(
                                              color: kHeadingTextColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                          softWrap: false,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.star,size: 5.w,color: kIconsColor,),
                                      SizedBox(width: 2.w),
                                      Text(productProvider.products[index].rating.rate,style: GoogleFonts.robotoSlab(
                                        color: kPrimaryColor,fontSize: 9.sp,fontWeight: FontWeight.w600
                                      )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            productProvider
                                                .products[index].price,
                                            style: GoogleFonts.robotoSlab(
                                                color: kPrimaryColor,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            '\$',
                                            style: GoogleFonts.robotoSlab(
                                                color: kPrimaryColor,
                                                fontSize: 10.sp),
                                          )
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: (() {
                                          if (productProvider.cartProducts
                                              .contains(productProvider
                                                  .products[index])) {
                                            context
                                                .read<ProductProvider>()
                                                .removeFromCart(productProvider
                                                    .products[index]);
                                          } else {
                                            context
                                                .read<ProductProvider>()
                                                .addToCart(productProvider
                                                    .products[index]);
                                          }
                                        }),
                                        child: Icon(
                                          productProvider.cartProducts.contains(
                                                  productProvider
                                                      .products[index])
                                              ? Icons.delete
                                              : Icons.shopping_bag_outlined,
                                          color: kHeadingTextColor,
                                          size: 6.w,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
          }),
    );
  }
}
