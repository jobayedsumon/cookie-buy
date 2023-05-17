import 'dart:async';
import 'dart:convert';
import 'package:cookie_buy_cookies/helpers/functions.dart';
import 'package:cookie_buy_cookies/includes/CookieAppBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../components/CookieChip.dart';
import '../helpers/alerts.dart';
import '../helpers/dioUtil.dart';
import 'package:pay/pay.dart';
import 'payment_configurations.dart' as payment_configurations;

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];


class StoreScreen extends StatefulWidget {
  final fromProfile;

  const StoreScreen({super.key, this.fromProfile = false});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List cookiePackages = [];
  var dio = DioUtil.getInstance();
  late StreamSubscription<dynamic> _subscription;
  Set<String> skuIds = {'30', '90', '120', '150', '330', '660', '1320', '3300'};
  bool isLoading = false;
  double balance = 0.0;
  late final Pay _payClient;

  // Future<void> getProducts() async {
  //   ProductDetailsResponse response =
  //       await InAppPurchase.instance.queryProductDetails(skuIds);
  //   if (response.notFoundIDs.isEmpty) {
  //     List products = response.productDetails.toList();
  //     products.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
  //
  //     setState(() {
  //       cookiePackages = products;
  //     });
  //   }
  // }

  // Future verifyAndDeposit(PurchaseDetails purchaseDetails, quantity) async {
  //   try {
  //     dio.post('/transaction/deposit', data: {
  //       'cookies': purchaseDetails.productID,
  //       'quantity': quantity,
  //       'purchase_id': purchaseDetails.purchaseID,
  //       'purchase_token':
  //           purchaseDetails.verificationData.serverVerificationData,
  //     }).then((response) async {
  //       if (response.data['success']) {
  //         showSuccess(context, response.data['message']);
  //         await setBalance(response.data['balance'].toDouble());
  //         setState(() {
  //           balance = response.data['balance'].toDouble();
  //         });
  //       } else {
  //         showError(context, response.data['message']);
  //       }
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }).catchError((e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       showError(context,
  //           'Something went wrong. Please try again later or contact the admin.');
  //     });
  //   } on DioError catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showError(context,
  //         'Something went wrong. Please try again later or contact the admin.');
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showError(context,
  //         'Something went wrong. Please try again later or contact the admin.');
  //   }
  // }

  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       showSuccess(context, 'Purchase is pending');
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         showError(context, 'Purchase failed');
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //           purchaseDetails.status == PurchaseStatus.restored) {
  //         setState(() {
  //           isLoading = true;
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //               "Purchase complete. Please stay on this page while we verify and deposit your cookies."),
  //           duration: Duration(milliseconds: 2000),
  //         ));
  //
  //         PurchaseWrapper billingClientPurchase =
  //             (purchaseDetails as GooglePlayPurchaseDetails)
  //                 .billingClientPurchase;
  //         var jsonData = jsonDecode(billingClientPurchase.originalJson);
  //         int quantity = jsonData['quantity']! ?? 1;
  //
  //         await verifyAndDeposit(purchaseDetails, quantity);
  //       }
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await InAppPurchase.instance.completePurchase(purchaseDetails);
  //       }
  //     }
  //   });
  // }

  @override
  initState() {
    // InAppPurchase.instance.isAvailable().then((available) {
    //   if (!available) {
    //     showError(context, 'In-App Purchases are not available on this device');
    //   } else {
    //     getProducts();
    //
    //     final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    //     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //       _listenToPurchaseUpdated(purchaseDetailsList);
    //     }, onDone: () {
    //       _subscription.cancel();
    //     }, onError: (error) {
    //       _subscription.cancel();
    //     });
    //   }
    // });

    super.initState();
    _payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(
          payment_configurations.basicGooglePayIsReadyToPay),
    });
    getBalance().then((value) {
      setState(() {
        balance = value;
      });
    });

  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }



  void onGooglePayPressed() async {
    final result = await _payClient.showPaymentSelector(
      PayProvider.google_pay,
      _paymentItems,
    );

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: CookieAppBar(
                balance: balance, showBalance: !widget.fromProfile),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            'PURCHASE COOKIES',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: cookiePackages
                                .take((cookiePackages.length ~/ 2))
                                .map(
                                  (package) => CookieChip(package: package),
                                )
                                .toList(),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            '*Please stay on this page after purchasing for verification.',
                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                          ),
                          Column(
                            children: cookiePackages
                                .skip((cookiePackages.length ~/ 2))
                                .map((package) => CookieChip(package: package))
                                .toList(),
                          ),


                        FutureBuilder<bool>(
                          future: _payClient.userCanPay(PayProvider.google_pay),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.data == true) {
                                return RawGooglePayButton(
                                    type: GooglePayButtonType.pay,
                                    onPressed: onGooglePayPressed,);
                              } else {
                                return Text('Google Pay not available');
                              }
                            } else {
                              CircularProgressIndicator();
                            }
                            return CircularProgressIndicator();
                          },
                        ),

                        ],
                      )),
                    ],
                  ),
                ),
              ),

            ),
          );
  }
}
