import 'package:flutter/material.dart';

/*
  点击弹出一个 BottomSheet
  mainText 是主要描述文字
  resultText 是选择结果 or 之前的选择
  showBottomSheet 还没封装好
 */
class TapBottomSheetOption extends StatelessWidget {
  final String mainText;
  final String resultText;
  final showBottomSheet;

  const TapBottomSheetOption({Key key, this.mainText, this.resultText, this.showBottomSheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: () => showBottomSheet(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
            left: 24.0,
            right: 24.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  mainText,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Text(
                resultText,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
