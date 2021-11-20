import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/shared/styles/color.dart';

Widget defaultButtom({
  double radius = 10,
  double width = double.infinity,
  Color background = Colors.teal,
  @required Function function,
  @required String text,
  bool isupperCase = true,
}) =>
    Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isupperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormFiled({
  bool isPassword = false,
  @required TextEditingController controller,
  @required TextInputType type,
  @required String hint,
  Function onSubmit,
  Function onChange,
  bool isClickable = true,
  Function onTap,
  IconData suffix,
  Widget prefix,
  Widget prefixIcon,
  @required Function validate,
  Function suffixPressed,
}) =>
    TextFormField(
      style: TextStyle(color: defaultColor),
      textAlign: TextAlign.end,
      obscureText: isPassword,
      validator: validate,
      enabled: isClickable,
      onTap: onTap,
      onChanged: onChange,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        prefix:prefix,
        prefixIcon: prefixIcon,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(.8),),
        hintText: hint,
      ),
    );
Widget userTitle({ String title}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14.0),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
Widget userListTile(
    String title, String subTitle , BuildContext context,IconData icon) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      splashColor: Theme.of(context).splashColor,
      child: ListTile(
        onTap: () {},
        title: Center(child: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Text(title,style: TextStyle(fontSize: 20),),
        )),
        subtitle: Text(subTitle),
        trailing: Icon(icon),
      ),
    ),
  );
}

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);


void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

Widget defaultTextButton(@required Function function, @required String text) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );

void showToast({@required String text,@required ToastState state }) => Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastState{SUCCESS,ERROR,WARNING}
Color chooseToastColor(ToastState state){
  Color color;
  switch(state){
    case ToastState.SUCCESS:
      color=Colors.green;
      break;
    case ToastState.ERROR:
      color=Colors.red;
      break;
    case ToastState.WARNING:
      color=Colors.amber;
      break;
  }
  return color;
}

Widget defaultButton(
    {@required Function function,
      @required String text,
      @required Color color}) =>
    Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(text),
        height: 50,
        textColor: Colors.white,
      ),
    );

Widget defaultTextFormFieldField({
  @required TextInputType type,
  @required TextEditingController controller,
  String labelText,
  IconData prefix,
  IconData suffix,
  bool isPassword = false ,
  Function validate,
  Function onChange,
  Function onSubmit,
  BuildContext context,
  Function suffixPressed,
}) => TextFormField(
  controller: controller,
  validator: validate,
  obscureText: isPassword,
  textInputAction: TextInputAction.next,
  keyboardType: type,
  textAlign: TextAlign.center,
  decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      suffixIcon: suffix != null
          ? IconButton(
        onPressed: suffixPressed,
        icon: Icon(
          suffix,
        ),
      )
          : null,
      prefixIcon: Icon(prefix),
      labelText: labelText,
      fillColor: Theme.of(context).backgroundColor),
  onSaved: (value) {
  },
);

Future<void> showDialogg(context,title,subtitle,Function function) async {
  var cubit=StoreAppCubit.get(context);
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Directionality(
          textDirection: StoreAppCubit.get(context).isEn == false? TextDirection.ltr :TextDirection.rtl,
          child: AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/kindacheese-7c99d.appspot.com/o/3071694.png?alt=media&token=4096d309-9f1f-45f0-8430-b46fed6f732b',
                    height: 18.h,
                    width: 18.w,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,style: TextStyle(fontSize: 13.sp),textAlign: TextAlign.center,),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(subtitle,style: TextStyle(fontSize: 11.sp),textAlign: TextAlign.center,maxLines: 2,),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text( cubit.getTexts('dialog'),
                      style: TextStyle(fontSize: 15.sp),)),
              TextButton(
                  onPressed: () async {
                    function();
                    Navigator.pop(context);
                  },
                  child: Text(
                           cubit.getTexts('forgetPassDialog3'),
                    style: TextStyle(color: Colors.red,fontSize: 15.sp),
                  ))
            ],
          ),
        );
      });
}

Future<void> showDialoggLogout(context,title,subtitle,Function function) async {
  var cubit=StoreAppCubit.get(context);
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Directionality(
          textDirection: StoreAppCubit.get(context).isEn == false? TextDirection.ltr :TextDirection.rtl,
          child: AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/889/889937.png',
                    height: 18.h,
                    width: 18.w,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,style: TextStyle(fontSize: 13.sp),textAlign: TextAlign.center,),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(subtitle,style: TextStyle(fontSize: 11.sp),textAlign: TextAlign.center,maxLines: 2,),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text( cubit.getTexts('dialog'),
                      style: TextStyle(fontSize: 15.sp),)),
              TextButton(
                  onPressed: () async {
                    function();
                    Navigator.pop(context);
                  },
                  child: Text(
                           cubit.getTexts('forgetPassDialog3'),
                    style: TextStyle(color: Colors.red,fontSize: 15.sp),
                  ))
            ],
          ),
        );
      });
}