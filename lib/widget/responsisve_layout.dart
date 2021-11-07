import 'package:flutter/cupertino.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileWidget;
  final Widget tabletWidget;
  final Widget webWidget;

  ResponsiveLayout({this.mobileWidget,this.tabletWidget,this.webWidget}) ;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints){
          if(constraints.maxWidth>=1000){
            return webWidget ?? mobileWidget;
          }
          else if(constraints.maxWidth>=650){
            return tabletWidget ?? mobileWidget;
          }
          else {
            return mobileWidget;
          }
    }
    );
  }
}
