import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddMembers extends StatelessWidget {
  const AddMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(60),
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.person),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        //border radius equal to or more than 50% of width
                      )),
                    )),
                Divider(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Elevated Button with Border Radius"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Elevated Button with Radius on Corner"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.elliptical(10, 40)
                              //  bottomLeft:, bottom left
                              // bottomRight: bottom right
                              ))),
                ),
              ],
            )));
  }
}
