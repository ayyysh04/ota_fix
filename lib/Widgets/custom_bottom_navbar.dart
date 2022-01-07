import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   int pageIndex;
//   final void Function(int) onItemTapped;
//   CustomBottomNavBar({
//     Key? key,
//     required this.pageIndex,
//     required this.onItemTapped,
//   }) : super(key: key);
//   @override
//   _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     currentIndex = widget.pageIndex;
//     final Size size = MediaQuery.of(context).size;
//     return Container(
//       height: 100,
//       child: Stack(children: [
//         Positioned(
//           bottom: 0,
//           left: 0,
//           child: Container(
//             width: size.width,
//             height: 80,
//             child: Stack(
//               // overflow: Overflow.visible,
//               children: [
//                 CustomPaint(
//                   size: Size(size.width, 80),
//                   painter: BtmNavBarCustomPainter(),
//                 ),
//                 Center(
//                   heightFactor: 0.6,
//                   child: FloatingActionButton(
//                       backgroundColor: Colors.blue,
//                       child: Icon(Icons.mic),
//                       elevation: 0.1,
//                       onPressed: () {}),
//                 ),
//                 Container(
//                   width: size.width,
//                   height: 80,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.home,
//                           color: currentIndex == 0
//                               ? Colors.blue
//                               : Colors.grey.shade400,
//                         ),
//                         onPressed: () {
//                           widget.onItemTapped(0);
//                           // setState(() {
//                           // currentIndex = 0;
//                           // });
//                         },
//                         splashColor: Colors.white,
//                       ),
//                       IconButton(
//                           icon: Icon(
//                             CupertinoIcons.bolt_fill,
//                             color: currentIndex == 1
//                                 ? Colors.blue
//                                 : Colors.grey.shade400,
//                           ),
//                           onPressed: () {
//                             widget.onItemTapped(1);
//                             // setState(() {
//                             // currentIndex = 1;
//                             // });
//                           }),
//                       Container(
//                         width: size.width * 0.20,
//                       ),
//                       IconButton(
//                           icon: Icon(
//                             FontAwesomeIcons.solidUser,
//                             color: currentIndex == 2
//                                 ? Colors.blue
//                                 : Colors.grey.shade400,
//                           ),
//                           onPressed: () {
//                             widget.onItemTapped(2);
//                             // setState(() {
//                             // currentIndex = 2;
//                             // });
//                           }),
//                       IconButton(
//                           icon: Icon(
//                             Icons.notifications,
//                             color: currentIndex == 3
//                                 ? Colors.blue
//                                 : Colors.grey.shade400,
//                           ),
//                           onPressed: () {
//                             widget.onItemTapped(3);
//                             // setState(() {
//                             // currentIndex = 3;
//                             // });
//                           }),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }

class BtmNavBarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
