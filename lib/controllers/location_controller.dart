import 'package:get/get.dart';
import '../apis/apis.dart';
import '../models/vpn.dart';

class LocationController extends GetxController {
  List<Vpn> freeVpnList = [];
  List<Vpn> premiumVpnList = [];
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getVpnData();
  }

  Future<void> getVpnData() async {
    isLoading.value = true;
    freeVpnList.clear();
    premiumVpnList.clear();

    List<Vpn> vpnList = await APIs.getVPNServers();
    for (int i = 0; i < vpnList.length; i++) {
      if (i < 5) {
        freeVpnList.add(vpnList[i]);
      } else {
        premiumVpnList.add(vpnList[i]);
      }
    }
    isLoading.value = false;
  }
}
