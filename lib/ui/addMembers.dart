import 'package:flutter/material.dart';

class AddMembers extends StatelessWidget {
  const AddMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEFE9E9),
        body: Container(
            padding: const EdgeInsets.all(60),
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        //border radius equal to or more than 50% of width
                      )),
                      child: const Icon(Icons.person),
                    )),
                const Divider(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                  child: const Text("Elevated Button with Border Radius"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.elliptical(10, 40)
                              //  bottomLeft:, bottom left
                              // bottomRight: bottom right
                              ))),
                  child: const Text("Elevated Button with Radius on Corner"),
                ),
              ],
            )));
  }
}
