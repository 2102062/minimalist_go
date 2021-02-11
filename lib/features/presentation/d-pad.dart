import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DPadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/5,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: Colors.white,
                    child: Container(
                      child: Transform.rotate(angle: pi/2, child: Icon(Icons.arrow_back)),
                    ),
                    onPressed: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Colors.white,
                        child: Container(
                          child: Transform.rotate(angle: 0, child: Icon(Icons.arrow_back)),
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: 10,),
                      MaterialButton(
                        color: Colors.white,
                        child: Container(
                          child: Transform.rotate(angle: pi, child: Icon(Icons.arrow_back)),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  MaterialButton(
                    color: Colors.white,
                    child: Container(
                      child: Transform.rotate(angle: -pi / 2, child: Icon(Icons.arrow_back)),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              MaterialButton(
                color: Colors.deepPurple,
                child: Container(
                  height: constraints.biggest.height,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
