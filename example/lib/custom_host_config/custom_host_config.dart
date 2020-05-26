import 'package:example/loading_adaptive_card.dart';
import 'package:flutter/material.dart';

import '../brightness_switch.dart';

class DynamicHostConfigPage extends StatelessWidget {
  final hostConfig = '''
  {
    "choiceSetInputValueSeparator": ",",
    "supportsInteractivity": true,
    "fontFamily": "Segoe UI",
    "spacing": {
        "none": 0,
      "small": 3,
      "default": 8,
      "medium": 20,
      "large": 30,
      "extraLarge": 40,
      "padding": 10
    },
    "separator": {
      "lineThickness": 1,
      "lineColor": "#EEEEEE"
    },
    "fontSizes": {
      "small": 12,
      "default": 14,
      "medium": 17,
      "large": 21,
      "extraLarge": 26
    },
    "fontWeights": {
      "lighter": 200,
      "default": 400,
      "bolder": 600
    },
    "imageSizes": {
      "small": 40,
      "medium": 80,
      "large": 160
    },
    "containerStyles": {
      "default": {
        "foregroundColors": {
          "default": {
            "default": "#FF0000",
            "subtle": "#EEFF0000"
          },
          "dark": {
            "default": "#000000",
            "subtle": "#66000000"
          },
          "light": {
            "default": "#FFFFFF",
            "subtle": "#33000000"
          },
          "accent": {
            "default": "#2E89FC",
            "subtle": "#882E89FC"
          },
          "good": {
            "default": "#54a254",
            "subtle": "#DD54a254"
          },
          "warning": {
            "default": "#c3ab23",
            "subtle": "#DDc3ab23"
          },
          "attention": {
            "default": "#FF0000",
            "subtle": "#DDFF0000"
          }
        },
        "backgroundColor": "#AAAAAA"
      },
      "emphasis": {
        "foregroundColors": {
          "default": {
            "default": "#333333",
            "subtle": "#EE333333"
          },
          "dark": {
            "default": "#000000",
            "subtle": "#66000000"
          },
          "light": {
            "default": "#FFFFFF",
            "subtle": "#33000000"
          },
          "accent": {
            "default": "#2E89FC",
            "subtle": "#882E89FC"
          },
          "good": {
            "default": "#54a254",
            "subtle": "#DD54a254"
          },
          "warning": {
            "default": "#c3ab23",
            "subtle": "#DDc3ab23"
          },
          "attention": {
            "default": "#FF0000",
            "subtle": "#DDFF0000"
          }
        },
        "backgroundColor": "#08000000"
      }
    },
    "actions": {
      "maxActions": 5,
      "spacing": "Default",
      "buttonSpacing": 10,
      "showCard": {
        "actionMode": "Inline",
        "inlineTopMargin": 16,
        "style": "emphasis"
      },
      "preExpandSingleShowCardAction": false,
      "actionsOrientation": "Horizontal",
      "actionAlignment": "Left"
    },
    "adaptiveCard": {
      "allowCustomStyle": false
    },
    "imageSet": {
      "imageSize": "Medium",
      "maxImageHeight": 100
    },
    "factSet": {
      "title": {
        "size": "Default",
        "color": "Default",
        "isSubtle": false,
        "weight": "Bolder",
        "warp": true
      },
      "value": {
        "size": "Default",
        "color": "Default",
        "isSubtle": false,
        "weight": "Default",
        "warp": true
      },
      "spacing": 10
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Host Config"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return DemoAdaptiveCard("lib/samples/example${index + 1}", hostConfig: hostConfig);
        },
      ),
    );
  }
}
