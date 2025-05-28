import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lottie/lottie.dart';

class UpgradeScreen extends StatefulWidget {
  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;
  static const Set<String> _kIds = {
    'test_product_id'
  }; // Replace with your actual product ID

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen(_onPurchaseUpdated, onError: _onPurchaseError);
    _initializeStoreInfo();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _initializeStoreInfo() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      setState(() {
        _isAvailable = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kIds);
    if (response.error != null) {
      setState(() {
        _isAvailable = false;
        _loading = false;
      });
      return;
    }

    if (response.productDetails.isEmpty) {
      setState(() {
        _isAvailable = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = true;
      _products = response.productDetails;
      _loading = false;
    });
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Handle purchase success
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Purchase successful!')));
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle purchase error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Purchase error!')));
      }
    }
  }

  void _onPurchaseError(Object error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Purchase stream error!')));
  }

  void _buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upgrade to Premium'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _isAvailable
              ? Column(
                  children: [
                    Lottie.asset('assets/lottie/premium.json', height: 200),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Unlock Premium Features',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          FeatureItem(icon: Icons.speed, text: 'High Speed'),
                          FeatureItem(
                              icon: Icons.lock, text: 'Unlimited Servers'),
                          FeatureItem(
                              icon: Icons.security, text: 'Enhanced Security'),
                          FeatureItem(
                              icon: Icons.support, text: '24/7 Support'),
                          SizedBox(height: 24),
                          _products.isNotEmpty
                              ? ElevatedButton(
                                  onPressed: () => _buyProduct(_products.first),
                                  child: Text('Upgrade Now for \$5.99'),
                                )
                              : Text('No products available for purchase')
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: Text('Store not available')),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 16),
          Text(text, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
