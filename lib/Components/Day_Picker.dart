import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

import '../Resources/commons.dart';

class DayPicker extends StatefulWidget {
  final int days;
  final Color? inactiveCardColor;
  final Color? activeColor;
  final Color? foregroundColor;
  final bool showDatePicker;
  final void Function(DateTime)? onSelected;
  const DayPicker({
    super.key,
    this.onSelected,
    this.days = 7,
    this.inactiveCardColor,
    this.foregroundColor,
    this.activeColor,
    this.showDatePicker = true,
  });

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  String _selectedDate = "";
  bool showPick = true;
  final ScrollController _controller = ScrollController();

  String getDate(DateTime date) {
    return date.toString().split(" ").first;
  }

  String getDay(String date) {
    return DateFormat("EEE").format(DateTime.parse(date));
  }

  String getMonth(String date) {
    return DateFormat("MMM").format(DateTime.parse(date));
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = getDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (widget.showDatePicker)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () async {
                  final calenderDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                    currentDate: DateTime.parse(_selectedDate),
                    initialDate: DateTime.parse(_selectedDate),
                  );
                  if (calenderDate != null) {
                    _selectedDate = getDate(calenderDate);
                    if (widget.onSelected != null) {
                      widget.onSelected!(calenderDate);
                    }
                    setState(() {
                      showPick = false;
                    });
                  }
                },
                child: KCard(
                  color: widget.inactiveCardColor ?? DColor.card,
                  child: !showPick
                      ? Column(
                          children: [
                            Text(
                              getMonth(_selectedDate),
                              style: TextStyle(
                                color: widget.activeColor ?? Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _selectedDate.split("-").last,
                              style: TextStyle(
                                color: widget.activeColor ?? Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Label(
                              getDay(_selectedDate),
                            ).regular,
                          ],
                        )
                      : Column(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 22,
                              color: widget.foregroundColor,
                            ),
                            height10,
                            Text(
                              "Pick",
                              style: TextStyle(
                                color: widget.foregroundColor ?? Colors.black,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          Row(
            children: List.generate(
              widget.days,
              (index) => _pill(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(index) {
    // Reverse Days
    // DateTime date = DateTime.now()
    //     .subtract(Duration(days: widget.days))
    //     .add(Duration(days: index + 1));

    // Forward days
    DateTime date = DateTime.now().add(Duration(days: index));

    String filterDate = getDate(date);

    bool isActive = _selectedDate == filterDate;
    if (getDay(filterDate) != "Sun") {
      return GestureDetector(
        onTap: () {
          if (widget.onSelected != null) {
            widget.onSelected!(date);
          }
          setState(() {
            _selectedDate = filterDate;
            showPick = true;
          });
        },
        child: Container(
          width: 55,
          margin: EdgeInsets.only(right: index == (widget.days - 1) ? 0 : 10),
          decoration: BoxDecoration(
            color: isActive
                ? widget.activeColor ?? DColor.primary
                : widget.inactiveCardColor ?? Colors.white,
            borderRadius: kRadius(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              Text(
                filterDate.split("-").last,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                getDay(filterDate),
                style: const TextStyle(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
