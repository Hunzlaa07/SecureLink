import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import '../controllers/location_controller.dart';
import '../controllers/native_ad_controller.dart';
import '../helpers/ad_helper.dart';
import '../helpers/pref.dart';
import '../main.dart';
import '../widgets/vpn_card.dart';
import 'upgrade_screen.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = Get.put(LocationController());
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            'VPN Locations (${_controller.freeVpnList.length} free, ${_controller.premiumVpnList.length} premium)',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        bottomNavigationBar:
            _adController.ad != null && _adController.adLoaded.isTrue
                ? SafeArea(
                    child: SizedBox(
                        height: 85, child: AdWidget(ad: _adController.ad!)))
                : null,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
            onPressed: () => _controller.getVpnData(),
            backgroundColor: Colors.deepPurple,
            child: Icon(CupertinoIcons.refresh, color: Colors.white),
          ),
        ),
        body: _controller.isLoading.value
            ? _loadingWidget()
            : _controller.freeVpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(context),
      ),
    );
  }

  Widget _vpnData(BuildContext context) => ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            top: mq.height * .015,
            bottom: mq.height * .1,
            left: mq.width * .04,
            right: mq.width * .04),
        children: [
          Text(
            'Free Servers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ..._controller.freeVpnList.map((vpn) => VpnCard(vpn: vpn)).toList(),
          SizedBox(height: 20),
          Text(
            'Premium Servers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (!Pref.isUserPremium)
            GestureDetector(
              onTap: () => Get.to(() => UpgradeScreen()),
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Upgrade to Premium to access these servers',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          if (Pref.isUserPremium)
            ..._controller.premiumVpnList
                .map((vpn) => VpnCard(vpn: vpn))
                .toList(),
        ],
      );

  Widget _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/lottie/loading.json',
                width: mq.width * .7),
            Text(
              'Loading Secure VPNs...',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget _noVPNFound() => Center(
        child: Text(
          'VPNs Not Found! 😔',
          style: TextStyle(
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold),
        ),
      );
}
