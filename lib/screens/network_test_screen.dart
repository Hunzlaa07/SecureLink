import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/apis.dart';
import '../main.dart';
import '../models/ip_details.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Network Test Screen'),
        backgroundColor: Colors.deepPurple,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Refresh button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            ipData.value = IPDetails.fromJson({});
            APIs.getIPDetails(ipData: ipData);
          },
          backgroundColor: Colors.deepPurple,
          child: Icon(CupertinoIcons.refresh, color: Colors.white),
        ),
      ),

      body: Obx(
        () => ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: mq.width * .04,
            right: mq.width * .04,
            top: mq.height * .01,
            bottom: mq.height * .1,
          ),
          children: [
            _buildGradientCard(
              title: 'IP Address',
              subtitle: ipData.value.query,
              icon: CupertinoIcons.location_solid,
              colors: [Colors.blue.shade200, Colors.blue.shade400],
            ),
            _buildGradientCard(
              title: 'Internet Provider',
              subtitle: ipData.value.isp,
              icon: Icons.business,
              colors: [Colors.orange.shade200, Colors.orange.shade400],
            ),
            _buildGradientCard(
              title: 'Location',
              subtitle: ipData.value.country.isEmpty
                  ? 'Fetching ...'
                  : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
              icon: CupertinoIcons.location,
              colors: [Colors.pink.shade200, Colors.pink.shade400],
            ),
            _buildGradientCard(
              title: 'Pin-code',
              subtitle: ipData.value.zip,
              icon: CupertinoIcons.location_solid,
              colors: [Colors.cyan.shade200, Colors.cyan.shade400],
            ),
            _buildGradientCard(
              title: 'Timezone',
              subtitle: ipData.value.timezone,
              icon: CupertinoIcons.time,
              colors: [Colors.green.shade200, Colors.green.shade400],
            ),
            StreamBuilder<VpnStatus?>(
              initialData: VpnStatus(),
              stream: VpnEngine.vpnStatusSnapshot(),
              builder: (context, snapshot) => Column(
                children: [
                  _buildGradientCard(
                    title: '${snapshot.data?.byteIn ?? '0 kbps'}',
                    subtitle: 'DOWNLOAD',
                    icon: Icons.arrow_downward_rounded,
                    colors: [Colors.green.shade200, Colors.green.shade400],
                  ),
                  _buildGradientCard(
                    title: '${snapshot.data?.byteOut ?? '0 kbps'}',
                    subtitle: 'UPLOAD',
                    icon: Icons.arrow_upward_rounded,
                    colors: [Colors.blue.shade200, Colors.blue.shade400],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
