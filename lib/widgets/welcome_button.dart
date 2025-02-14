import 'package:flutter/material.dart';
//import 'package:mobileproject/screens/signup.dart';
class welcome_button extends StatelessWidget {
const welcome_button({super.key, this.buttontext, this.onTap});
final String? buttontext;
final Widget? onTap;
@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: () {
Navigator.push(
  context,
MaterialPageRoute(
builder: (e) => onTap!,
),
);
},
child: Container(
padding: EdgeInsets.all(10.0),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.only(
topLeft: Radius.circular(50),
),
),
child: Text(
buttontext!,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 20.0,
fontWeight: FontWeight.bold,
),
)),
);
}
}