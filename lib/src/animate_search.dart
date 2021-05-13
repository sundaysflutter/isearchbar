import 'package:flutter/material.dart';

class SearchBarStyle {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Border border;
  final double height;

  static const BorderSide _borderSide =
      BorderSide(color: Color(0xffdcdcdc), width: 1.0);

  const SearchBarStyle({
    this.backgroundColor = const Color.fromRGBO(142, 142, 147, .15),
    this.padding = const EdgeInsets.all(5.0),
    this.borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    this.border = const Border(
        top: _borderSide,
        bottom: _borderSide,
        left: _borderSide,
        right: _borderSide),
    this.height = 42.0,
  });
}

class ISearchBar extends StatefulWidget {
  final EdgeInsetsGeometry searchBarPadding;
  final SearchBarStyle searchBarStyle;
  final double cancelWidgetWidth;
  final Widget cancellationWidget;
  final double textPaddingLeft;
  final Function(String) onCancelled;
  final String hintText;
  final TextStyle hintStyle;
  final String text;
  final TextStyle textStyle;
  // final TextAlign textAligin;
  final double searchIconTop;
  final Widget searchIcon;
  final Color searchIconActiveColor;
  final Function(String) focusCall;
  final Function loseFocusCall;
  final Function(String) onTextChange;

  ISearchBar({
    Key key,
    this.searchBarPadding = const EdgeInsets.all(0),
    this.searchBarStyle = const SearchBarStyle(),
    this.cancelWidgetWidth,
    this.cancellationWidget = const Text("Cancel"),
    this.onCancelled,
    this.textPaddingLeft = 30,
    this.hintText = '搜索',
    this.hintStyle = const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
    this.text,
    this.textStyle,
    // this.textAligin = TextAlign.center,
    this.searchIconTop = 4,
    this.searchIcon,
    this.searchIconActiveColor = Colors.grey,
    this.focusCall,
    this.loseFocusCall,
    this.onTextChange,
  }) : super(key: key);

  @override
  _ISearchBarState createState() => _ISearchBarState();
}

class _ISearchBarState extends State<ISearchBar> {
  bool _isfocus = false;
  TextEditingController _searchQueryController;
  String _inputStr = "";
  TextAlign _textAligin = TextAlign.center;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _inputStr = '';
    _textAligin = TextAlign.center;
    _searchQueryController = TextEditingController.fromValue(

        ///用来设置初始化时显示
        TextEditingValue(
      ///用来设置文本 controller.text = "0000"
      text: _inputStr,

      ///设置光标的位置
      selection: TextSelection.fromPosition(
        ///用来设置文本的位置
        TextPosition(
            affinity: TextAffinity.downstream,

            /// 光标向后移动的长度
            offset: _inputStr.length),
      ),
    ));
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // print('得到焦点');

        setState(() {
          _textAligin = TextAlign.left;
          _isfocus = true;
        });
        if (widget.focusCall != null) {
          String text = _searchQueryController.text;
          widget.focusCall(text);
        }
      } else {
        // print('失去焦点');
        //
        setState(() {
          _isfocus = false;
          _textAligin = TextAlign.center;
        });
        if (widget.onCancelled != null) {
          widget.onCancelled(_searchQueryController.text);
        } else {
          // FocusScope.of(context).requestFocus(FocusNode());
        }
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final widthMax = constraints.maxWidth;
      return searchWidget(context, widthMax);
    }));
  }

  Widget searchWidget(BuildContext context, double widthMax) {
    return Padding(
      padding: widget.searchBarPadding,
      child: Container(
        height: widget.searchBarStyle.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: _isfocus
                    ? widget.cancelWidgetWidth != null
                        ? widthMax - widget.cancelWidgetWidth
                        : widthMax * .85
                    : widthMax,
                decoration: BoxDecoration(
                    borderRadius: widget.searchBarStyle.borderRadius,
                    color: widget.searchBarStyle.backgroundColor,
                    border: widget.searchBarStyle.border),
                child: Padding(
                  padding: widget.searchBarStyle.padding,
                  child: Theme(
                    child: Stack(
                      children: [
                        Positioned(
                            top: widget.searchIconTop,
                            left: _isfocus
                                ? widget.textPaddingLeft - 25
                                : widget.cancelWidgetWidth != null
                                    ? (widthMax -
                                                widget.cancelWidgetWidth -
                                                getTextSize(
                                                        _searchQueryController.text ??
                                                            widget.hintText,
                                                        ((_searchQueryController.text.isEmpty ||
                                                                _searchQueryController.text ==
                                                                    null)
                                                            ? widget.textStyle
                                                            : widget.hintStyle))
                                                    .width) /
                                            2 -
                                        widget.textPaddingLeft -
                                        ((_searchQueryController.text.isEmpty ||
                                                _searchQueryController.text ==
                                                    null)
                                            ? 15
                                            : 5)
                                    : (widthMax -
                                                getTextSize(
                                                        _searchQueryController.text ??
                                                            widget.hintText,
                                                        ((_searchQueryController
                                                                    .text
                                                                    .isEmpty ||
                                                                _searchQueryController.text ==
                                                                    null)
                                                            ? widget.hintStyle
                                                            : widget.textStyle))
                                                    .width) /
                                            2 -
                                        widget.textPaddingLeft -
                                        ((_searchQueryController.text.isEmpty ||
                                                _searchQueryController.text == null)
                                            ? 15
                                            : 5),
                            child: widget.searchIcon != null ? widget.searchIcon : Icon(Icons.search_rounded)),
                        TextField(
                          controller: _searchQueryController,
                          focusNode: _focusNode,
                          onChanged: _onTextChanged,
                          style: widget.textStyle,
                          textAlign: _textAligin,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            // icon: widget.icon ?? null,
                            contentPadding: EdgeInsets.fromLTRB(
                                widget.textPaddingLeft, 7, 8, 7),
                            hintText: widget.hintText,
                            hintStyle: widget.hintStyle,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        )
                      ],
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: widget.searchIconActiveColor,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _cancel,
              child: AnimatedOpacity(
                opacity: _isfocus ? 1.0 : 0,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: _isfocus ? 300 : 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _isfocus
                      ? widget.cancelWidgetWidth != null
                          ? widget.cancelWidgetWidth
                          : widthMax * .15
                      : 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: widget.cancellationWidget,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTextChanged(String text) {
    if (widget.onTextChange != null) {
      widget.onTextChange(text);
    }
  }

  void _cancel() {
    if (widget.onCancelled != null) {
      widget.onCancelled('');
    }
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _searchQueryController.clear();
      _inputStr = '';
      _isfocus = false;
      _textAligin = TextAlign.center;
    });
  }
}

Size getTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
