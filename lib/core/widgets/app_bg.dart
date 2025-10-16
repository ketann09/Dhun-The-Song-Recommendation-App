import 'package:flutter/material.dart';

class AppBg extends StatelessWidget {
  final Widget child;
  const AppBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors:[
            Color(0xFFD100A3),
            Color(0xFF3A2F7D), 
            Colors.black,  
          ] ,
          stops: [0.0,0.35,0.6],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),
      ),
      child: child,
    );
  }
}
