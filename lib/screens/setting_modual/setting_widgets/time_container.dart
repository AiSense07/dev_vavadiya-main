import 'package:flutter/material.dart';


import '../../../helper/colors.dart';

class TimeContainer extends StatefulWidget {
  final String title;
  final String? time;
  Color? color;
  final Function(String time) onTap;

  TimeContainer({Key? key, required this.title, this.time, required this.onTap, this.color}) : super(key: key);

  @override
  State<TimeContainer> createState() => _TimeContainerState();
}

class _TimeContainerState extends State<TimeContainer> {
  TimeOfDay? time;

  @override
  void initState() {
    if (widget.time != null) time = stringToTime(time: widget.time!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int hr = widget.time == null ? 00 : int.parse(widget.time!.split(" : ")[0]);
    int min = widget.time == null ? 00 : int.parse(widget.time!.split(" : ")[1].split(" ")[0]);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30, right: 5, left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.title} :",
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: widget.color ?? AppColors.white,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hr, minute: min),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    time = value;
                  });
                  widget.onTap(timeToString(time: value));
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white38),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.white38,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.access_time_filled),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      time != null ? timeToString(time: time ?? const TimeOfDay(hour: 00, minute: 00)) : "Select Time",
                      style: TextStyle(fontSize: size.width * 0.035, color: AppColors.white70),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

String timeToString({required TimeOfDay time}) {
  int hour = time.hour;
  if (hour > 11) {
    return "${hour == 12 ? hour : "0${hour - 12}"} : ${time.minute < 10 ? "0${time.minute}" : time.minute} PM";
  } else {
    return "${time.hour < 10 ? "0${time.hour}" : time.hour} :"
        " ${time.minute < 10 ? "0${time.minute}" : time.minute} AM";
  }
}

TimeOfDay stringToTime({required String time}) {
  String hour = time.split(" : ")[0];
  String minute = time.split(" : ")[1].split(" ")[0];
  String timeZone = time.split(" : ")[1].split(" ")[1];

  if (timeZone == "AM") {
    if (hour == "00") {
      return const TimeOfDay(hour: 00, minute: 00);
    } else {
      return TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
    }
  } else {
    if (hour == "12") {
      return const TimeOfDay(hour: 12, minute: 00);
    } else {
      return TimeOfDay(hour: int.parse(hour) + 12, minute: int.parse(minute));
    }
  }
}
