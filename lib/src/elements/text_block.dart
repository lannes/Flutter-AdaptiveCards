import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../flutter_adaptive_cards.dart';
import '../additional.dart';
import '../base.dart';
import '../utils.dart';
import 'package:provider/provider.dart';

class AdaptiveTextBlock extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveTextBlock(
      {super.key, required this.adaptiveMap, required this.supportMarkdown});

  final Map<String, dynamic> adaptiveMap;
  final bool supportMarkdown;

  @override
  _AdaptiveTextBlockState createState() => _AdaptiveTextBlockState();
}

class _AdaptiveTextBlockState extends State<AdaptiveTextBlock>
    with AdaptiveElementMixin {
  FontWeight? fontWeight;
  double? fontSize;
  late Alignment horizontalAlignment;
  int? maxLines;
  late TextAlign textAlign;
  late String text;

  @override
  void initState() {
    super.initState();
    fontSize = resolver.resolveFontSize(adaptiveMap["size"]);
    fontWeight = resolver.resolveFontWeight(adaptiveMap["weight"]);
    horizontalAlignment = loadAlignment();
    textAlign = loadTextAlign();
    maxLines = loadMaxLines();

    text = parseTextString(adaptiveMap['text']);
  }

  /*child: */

  // TODO create own widget that parses _basic_ markdown. This might help: https://docs.flutter.io/flutter/widgets/Wrap-class.html
  @override
  Widget build(BuildContext context) {
    var textBody =
        widget.supportMarkdown ? getMarkdownText(context: context) : getText();

    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Align(
        // TODO IntrinsicWidth finxed a few things, but breaks more
        alignment: horizontalAlignment,
        child: textBody,
      ),
    );
  }

  Widget getText() {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: getColor(Theme.of(context).brightness),
      ),
      maxLines: maxLines,
    );
  }

  Widget getMarkdownText({BuildContext? context}) {
    return MarkdownBody(
      // TODO the markdown library does currently not support max lines
      // As markdown support is more important than maxLines right now
      // this is in here.
      //maxLines: maxLines,
      data: text,
      styleSheet: loadMarkdownStyleSheet(),
      onTapLink: (text, href, title) {
        if (href != null) {
          var rawAdaptiveCardState = context?.watch<RawAdaptiveCardState>();
          rawAdaptiveCardState?.openUrl(href);
        }
      },
    );
  }

  /*String textCappedWithMaxLines() {
    if(text.split("\n").length <= maxLines) return text;
    return text.split("\n").take(maxLines).reduce((o,t) => "$o\n$t") + "...";
  }*/

  // Probably want to pass context down the tree, until now -> this
  Color? getColor(Brightness brightness) {
    Color? color = resolver.resolveForegroundColor(
        adaptiveMap["color"], adaptiveMap["isSubtle"]);
    if (color != null && widgetState.widget.approximateDarkThemeColors) {
      color = adjustColorToFitDarkTheme(color, brightness);
    }
    return color;
  }

  Alignment loadAlignment() {
    String alignmentString =
        widget.adaptiveMap["horizontalAlignment"]?.toLowerCase() ?? "left";

    switch (alignmentString) {
      case "left":
        return Alignment.centerLeft;
      case "center":
        return Alignment.center;
      case "right":
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  TextAlign loadTextAlign() {
    String alignmentString =
        widget.adaptiveMap["horizontalAlignment"]?.toLowerCase() ?? "left";

    switch (alignmentString) {
      case "left":
        return TextAlign.start;
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.right;
      default:
        return TextAlign.start;
    }
  }

  /// This also takes care of the wrap property, because maxLines = 1 => no wrap
  int? loadMaxLines() {
    bool wrap = widget.adaptiveMap["wrap"] ?? false;
    if (!wrap) return 1;
    // can be null, but that's okay for the text widget.
    return widget.adaptiveMap["maxLines"];
  }

  /// TODO Markdown still has some problems
  MarkdownStyleSheet loadMarkdownStyleSheet() {
    var color = getColor(Theme.of(context).brightness);
    TextStyle style =
        TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

    return MarkdownStyleSheet(
      a: style,
      blockquote: style,
      code: style,
      em: style,
      strong: style.copyWith(fontWeight: FontWeight.bold),
      p: style,
    );
  }
}
