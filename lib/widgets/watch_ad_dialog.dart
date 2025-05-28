import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchAdDialog extends StatelessWidget {
  final VoidCallback onComplete;

  const WatchAdDialog({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'Change Theme',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Icon(
            Icons.video_collection,
            size: 50,
            color: Colors.blueAccent,
          ),
          SizedBox(height: 10),
          Text(
            'Watch an Ad to Change App Theme.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          textStyle:
              TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          child: Text('Watch Ad'),
          onPressed: () {
            Get.back();
            onComplete();
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          child: Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
