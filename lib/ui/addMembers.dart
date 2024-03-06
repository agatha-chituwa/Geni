import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

const cHeight = 50.0;

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE9E9),
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0, left: 20, right: 20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: cHeight,
                    ),
                    Card(
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 150, // Adjust the height as needed
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Positioned(
                              bottom: 50,
                              child: DropDownTextField(
                                // initialValue: "name4",
                                clearOption: true,
                                searchDecoration: const InputDecoration(
                                    hintText:
                                        "enter your custom hint text here"),
                                validator: (value) {
                                  if (value == null) {
                                    return "Required field";
                                  } else {
                                    return null;
                                  }
                                },
                                dropDownItemCount: 6,
                                dropDownList: const [
                                  DropDownValueModel(
                                      name: 'name1', value: "value1"),
                                  DropDownValueModel(
                                      name: 'name2',
                                      value: "value2",
                                      toolTipMsg:
                                          "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                  DropDownValueModel(
                                      name: 'name3', value: "value3"),
                                  DropDownValueModel(
                                      name: 'name4',
                                      value: "value4",
                                      toolTipMsg:
                                          "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                                  DropDownValueModel(
                                      name: 'name5', value: "value5"),
                                  DropDownValueModel(
                                      name: 'name6', value: "value6"),
                                  DropDownValueModel(
                                      name: 'name7', value: "value7"),
                                  DropDownValueModel(
                                      name: 'name8', value: "value8"),
                                ],
                                onChanged: (val) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFF19CA79),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/200 px.png'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
