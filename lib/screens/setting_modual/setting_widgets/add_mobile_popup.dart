import 'package:ai_sense/helper/navigations.dart';
import 'package:ai_sense/helper/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';


import '../../../helper/colors.dart';

class AddMobile extends StatefulWidget {
  const AddMobile({Key? key}) : super(key: key);

  @override
  State<AddMobile> createState() => _AddMobileState();
}

class _AddMobileState extends State<AddMobile> {
  int primaryNumber = 0;

  TextEditingController mobile = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add alternative mobile number",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.05,
              color: AppColors.white,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return index != 2
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          primaryNumber = index;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.05,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "+91 8795462315",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  index == 1 ? "Secondary" : "Primary",
                                  style: TextStyle(
                                    fontSize: size.width * 0.035,
                                    color: AppColors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Radio(
                              fillColor: MaterialStateColor.resolveWith((states) => Colors.orange),
                              value: primaryNumber,
                              groupValue: index,
                              onChanged: (v) {},
                            )
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              backgroundColor: AppColors.primary,
                              title: Column(
                                children: [
                                  CustomTextField(hint: "Enter Mobile number", title: "Mobile number", controller: mobile, size: size),
                                  customBtn(
                                      size: size,
                                      name: "Add",
                                      onTap: () {
                                        pop(context);
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 15),
                        child: DottedBorder(
                          color: AppColors.white70,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Add Mobile number",
                                  style: TextStyle(fontSize: size.width * 0.04, color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            },
          ),
          customBtn(
              size: size,
              name: "Set as Primary",
              onTap: () {
                pop(context);
              })
        ],
      ),
    );
  }

}
