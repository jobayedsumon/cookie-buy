import 'package:cookie_buy_cookies/helpers/dioUtil.dart';
import 'package:flutter/material.dart';
import '../helpers/functions.dart';
import '../includes/CookieAppBar.dart';

const _colDivider = SizedBox(height: 10);
const double _maxWidthConstraint = 400;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var dio = DioUtil.getInstance();
  double balance = 0.0;

  bool _buttonEnabled = true;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    getBalance().then((value) {
      setState(() {
        balance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CookieAppBar(balance: balance),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: _maxWidthConstraint,
            child: Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('Convert Rewards in following Steps:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0))),
                    _colDivider,
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('1. Go to Store Section and Buy Cookies')),
                    _colDivider,
                    Text(
                        '2. For Redeem Cookies, Go to Profile section and Click on Withdraw.'),
                    _colDivider,
                    Text(
                        '3. In the Withdraw Page, enter cookies and click on Withdraw button.'),
                    _colDivider,
                    _colDivider,
                    Text(
                        'Note: You will receive 60% of the amount you have converted. '
                        'It will take 4 - 6 days to credit the amount into your account.'),
                  ],
                ),
              ),
            ),
          ),
        ),

      ]),
    );
  }
}
