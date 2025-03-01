import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:example/brightness_switch.dart';

class NetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network'),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          AdaptiveCard.network(
            // placeholder:
            //     Container(child: Center(child: CircularProgressIndicator())),
            url: 'assets/ac-qv-faqs.json',
            hostConfigPath: 'assets/host_config.json',
            initData: {
              'fullname': 'minato',
              'bookingdate': '08/05/2023',
              'gender': 'female'
            },
            onChange: (id, key, cardState) {
              print('$id - $key');
              if (id == 'gender') {
                if (key == 'male')
                  cardState.loadInput('department', {'1': '1'});
                else
                  cardState.loadInput('department', {'2': '2', '3': '3'});
              }
            },
            onSubmit: (map) {
              print(map);
              // Send to server or handle locally
            },
            onOpenUrl: (url) {
              launchUrl(Uri.parse(url));
            },
            showDebugJson: false,
            approximateDarkThemeColors: true,
          )
        ],
      ),
    );
  }
}
