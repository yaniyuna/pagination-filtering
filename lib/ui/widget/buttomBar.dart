// import 'package:flutter/material.dart';
// import 'package:learn_pagination/ui/home.dart';
// import 'package:learn_pagination/ui/petaniPage.dart';

// Widget buildBottomBar(index, BuildContext context){
//   return BottomNavigationBar(
//     type: BottomNavigationBarType.fixed,
//     currentIndex: index,
//     onTap: (i){
//       switch (i) {
//         case 0:
//         Navigator.of(context).pushReplacement(new MaterialPageRoute(
//           builder: (BuildContext context)=>Home()
//         ));
//         break;
//         case 1:
//         Navigator.of(context).pushReplacement(new MaterialPageRoute(
//           builder: (BuildContext context)=>PetaniPage()
//         ));
//         break;
//         default:
//       }
//     },
//     items: [
//       BottomNavigationBarItem(icon: Icon(Icons.home)),
//       BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle)),
//     ],
//   );      
// }