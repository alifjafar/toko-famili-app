import 'package:famili/constants/colors.dart';
import 'package:famili/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'app_bar.dart';

class TextReadMoreSheetItem extends StatefulWidget {
  final String data;
  final int maxLines;
  final String titleBottomSheet;

  const TextReadMoreSheetItem(
      {Key key, this.data, this.maxLines = 2, this.titleBottomSheet})
      : super(key: key);

  @override
  _TextReadMoreSheetItemState createState() => _TextReadMoreSheetItemState();
}

class _TextReadMoreSheetItemState extends State<TextReadMoreSheetItem> {
  String title;

  @override
  void initState() {
    title = widget.titleBottomSheet == null
        ? Constant.detail
        : widget.titleBottomSheet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        Widget result;
        final span = TextSpan(text: widget.data);
        final tp = TextPainter(
            text: span,
            textAlign: TextAlign.start,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr);
        tp.layout(maxWidth: size.maxWidth);
        final text = Text(
          widget.data,
          maxLines: widget.maxLines,
          overflow: TextOverflow.ellipsis,
        );

        if (tp.didExceedMaxLines) {
          result = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text,
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  child: Text(
                    Constant.readMore,
                    style: TextStyle(color: ColorBase.primary),
                  ),
                  onTap: () => _showBottomSheet(),
                ),
              )
            ],
          );
        } else {
          result = text;
        }
        return result;
      },
    );
  }

  _showBottomSheet() {
    return showCupertinoModalBottomSheet(
      context: context,
      builder: (context, scrollController) {
        return Scaffold(
          backgroundColor: ColorBase.white,
          appBar: AppBarMV(
            title: title,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            )
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      text: widget.data, style: TextStyle(color: Colors.black)),
                )),
          ),
        );
      },
    );
  }
}
