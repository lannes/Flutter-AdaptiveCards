import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:provider/provider.dart';

class InheritedReferenceResolver extends StatelessWidget {
  final Widget child;
  final ReferenceResolver resolver;

  const InheritedReferenceResolver(
      {super.key, required this.resolver, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<ReferenceResolver>.value(
      value: resolver,
      child: child,
    );
  }
}

mixin AdaptiveElementWidgetMixin on StatefulWidget {
  Map<String, dynamic> get adaptiveMap;
}

mixin AdaptiveElementMixin<T extends AdaptiveElementWidgetMixin> on State<T> {
  late String id;

  late RawAdaptiveCardState widgetState;

  Map<String, dynamic> get adaptiveMap => widget.adaptiveMap;

  late ReferenceResolver resolver;

  @override
  void initState() {
    super.initState();

    resolver = context.read<ReferenceResolver>();

    widgetState = context.read<RawAdaptiveCardState>();
    if (widget.adaptiveMap.containsKey('id')) {
      id = widget.adaptiveMap['id'];
    } else {
      id = widgetState.idGenerator.getId();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveElementMixin &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

mixin AdaptiveActionMixin<T extends AdaptiveElementWidgetMixin> on State<T>
    implements AdaptiveElementMixin<T> {
  String get title => widget.adaptiveMap['title'] ?? '';

  void onTapped();
}

mixin AdaptiveInputMixin<T extends AdaptiveElementWidgetMixin> on State<T>
    implements AdaptiveElementMixin<T> {
  late String value;
  late String placeholder;

  @override
  void initState() {
    super.initState();
    value = adaptiveMap['value'].toString() == 'null'
        ? ''
        : adaptiveMap['value'].toString();

    placeholder = widget.adaptiveMap['placeholder'] ?? '';
  }

  void appendInput(Map map);

  void initInput(Map map);

  void loadInput(Map map) {}

  bool checkRequired();
}

mixin AdaptiveTextualInputMixin<T extends AdaptiveElementWidgetMixin>
    on State<T> implements AdaptiveInputMixin<T> {
  @override
  void initState() {
    super.initState();
  }
}

abstract class GenericAction {
  GenericAction(this.adaptiveMap, this.rawAdaptiveCardState);

  String? get title => adaptiveMap['title'];
  final Map<String, dynamic> adaptiveMap;
  final RawAdaptiveCardState rawAdaptiveCardState;

  void tap();
}

class GenericSubmitAction extends GenericAction {
  GenericSubmitAction(Map<String, dynamic> adaptiveMap,
      RawAdaptiveCardState rawAdaptiveCardState)
      : super(adaptiveMap, rawAdaptiveCardState) {
    data = adaptiveMap['data'] ?? {};
  }

  late Map<String, dynamic> data;

  @override
  void tap() {
    rawAdaptiveCardState.submit(data);
  }
}

class GenericActionOpenUrl extends GenericAction {
  GenericActionOpenUrl(Map<String, dynamic> adaptiveMap,
      RawAdaptiveCardState rawAdaptiveCardState)
      : super(adaptiveMap, rawAdaptiveCardState) {
    url = adaptiveMap['url'];
  }

  late String? url;

  @override
  void tap() {
    if (url != null) {
      rawAdaptiveCardState.openUrl(url!);
    }
  }
}
