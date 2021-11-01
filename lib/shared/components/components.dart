import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

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
  @required Function validate,
  Function suffixPressed,
}) =>
    TextFormField(
      obscureText: isPassword,
      validator: validate,
      enabled: isClickable,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(.8),),
        hintText: hint,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
      ),
    );
/*TextFormField(
keyboardType:  TextInputType.emailAddress,
controller: emailController,
validator: (String value) {
if (value.isEmpty || !value.contains('@')) {
return 'بريد الكتروني غير صالح';
}
return null;
},
decoration: InputDecoration(
border: InputBorder.none,
hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
hintText: "ادخل البريد الالكتروني"
),
),*/
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
Widget defaultFormField({
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
  textAlign: TextAlign.end,
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
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                  height: 20,
                  width: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              ),
            ],
          ),
          content: Text(subtitle),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text('الغاء')),
            TextButton(
                onPressed: () async {
                  function();
                  Navigator.pop(context);
                },
                child: Text(
                  'موافق',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      });
}