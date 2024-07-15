import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayPayment extends StatefulWidget {
  const VNPayPayment({super.key});


  @override
  _VNPayPaymentState createState() => _VNPayPaymentState();
}

class _VNPayPaymentState extends State<VNPayPayment> {
  late WebViewController _controller;
  String initialUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initialUrl = generatePaymentUrl();
  }

  String generatePaymentUrl() {
    const String tmnCode = 'MR4ATASV';
    const String secretKey = 'YGJS2UQOPR2LAQGUNCV9RBT2NW4T5K6N';
    const String returnUrl = 'https://yourwebsite.com/return_url';
    const String ipAddr = '127.0.0.1';
    final DateTime now = DateTime.now();
    final String createDate = DateFormat('yyyyMMddHHmmss').format(now).trim();
    final String orderId = Random()
        .nextInt(1000000)
        .toString(); // Order ID cần cố định hoặc sinh tự động
    const int amount = 120000; // Số tiền thanh toán (đơn vị: VND)
    const String locale = 'vn';
    const String currCode = 'VND';
    const String orderInfo = 'Thanh toan don hang';
    const String orderType = 'other';

    Map<String, String> vnpParams = {
      'vnp_Version': '2.0.0',
      'vnp_Command': 'pay',
      'vnp_TmnCode': tmnCode,
      'vnp_Amount': (amount * 100).toString(),
      'vnp_CurrCode': currCode,
      'vnp_TxnRef': orderId,
      'vnp_OrderInfo': orderInfo,
      'vnp_OrderType': orderType,
      'vnp_Locale': locale,
      'vnp_ReturnUrl': returnUrl,
      'vnp_IpAddr': ipAddr,
      'vnp_CreateDate': createDate,
    };

    List<String> sortedKeys = vnpParams.keys.toList()..sort();
    String query = sortedKeys.map((key) => '$key=${vnpParams[key]}').join('&');
    var hmac = Hmac(sha512, utf8.encode(secretKey));
    var digest = hmac.convert(utf8.encode(query));
    String secureHash = digest.toString();

    vnpParams['vnp_SecureHash'] = secureHash;

    return '$initialUrl?${Uri(queryParameters: vnpParams).query}';
  }

  String getFormattedDateTime() {
    final now = DateTime.now()
        .toUtc()
        .add(const Duration(hours: 7)); // Adjust for GMT+7
    final formatter = DateFormat('yyyyMMddHHmmss');
    return formatter.format(now);
  }

  String generateSecureHash(Map<String, dynamic> params, String secretKey) {
    var sortedKeys = params.keys.toList()..sort();
    var preHashString =
        sortedKeys.map((key) => '$key=${params[key]}').join('&');
    var bytes = utf8.encode(preHashString + secretKey);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void checkErrors(String url) {
    Uri uri = Uri.parse(url);
    Map<String, String> params = uri.queryParameters;

    String secretKey = 'YOUR_SECRET_KEY';
    String providedHash = params['vnp_SecureHash'] ?? '';
    params.remove('vnp_SecureHash');

    String generatedHash = generateSecureHash(params, secretKey);

    if (providedHash == generatedHash) {
      print('Hashes match. The URL is correct.');
    } else {
      print('Hashes do not match. There might be an error in the URL.');
    }
  }

  void _handlePaymentSuccess(String txnRef) async {
    await _firestore.collection('payments').doc(txnRef).set({
      'transaction_ref': txnRef,
      'status': 'success',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VNPay Payment'),
      ),
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://yourwebsite.com/return_url')) {
            final uri = Uri.parse(request.url);
            final txnRef = uri.queryParameters['vnp_TxnRef'];
            _handlePaymentSuccess(txnRef!);
            context.pop(txnRef);
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (url) {
          // Can be used to hide loading spinner
          print('Page finished loading: $url');
        },
      ),
    );
  }
}
