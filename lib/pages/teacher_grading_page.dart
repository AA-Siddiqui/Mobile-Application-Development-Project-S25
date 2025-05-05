import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/teacher_grading_controller.dart';
import 'package:project/utils/toast.dart';
import 'package:project/widgets/item_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TeacherGradingPage extends StatelessWidget {
  final int classId;
  final Map<String, dynamic> data;
  TeacherGradingPage(this.classId, this.data, {super.key});

  late final stateController = Get.put(TeacherGradingController(
    classId,
    data["id"],
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "${data["title"]}",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Skeletonizer(
            enabled: stateController.isLoading,
            child: ListView.builder(
                itemCount: stateController.isLoading
                    ? 4
                    : stateController.gradeList.length,
                itemBuilder: (context, index) => stateController.isLoading
                    ? itemBuilder(index)
                    : itemBuilder(
                        index,
                        stateController.gradeList[index]["studentId"],
                        stateController.gradeList[index]["name"],
                        stateController.gradeList[index]["rollNo"],
                        stateController.gradeList[index]["marks"],
                        stateController.gradeList[index]["submissionMade"],
                      )),
          ),
        );
      }),
    );
  }

  Widget itemBuilder(
    int index, [
    int studentId = -1,
    String name = "Lorem Ipsum Dolor",
    String rollNo = "Lorem Ipsum Dolor",
    int marks = 0,
    bool submissionMade = false,
  ]) =>
      ItemContainer(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Get.textTheme.titleLarge!.copyWith(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  rollNo,
                  style: Get.textTheme.bodyMedium!.copyWith(),
                ),
              ],
            ),
            SizedBox(
              width: Get.width * 0.2,
              child: DebouncedTextField(
                submissionMade: submissionMade,
                marks: marks,
                max: data["max"],
                action: (newMarks) async {
                  stateController.gradeList[index]["submissionId"] =
                      await stateController.updateMarks(
                    newMarks,
                    data["id"],
                    studentId,
                    stateController.gradeList[index]["submissionId"],
                  );
                  // FIXME: Add an indicator to show that the marks have been updated in the appbar
                },
              ),
            ),
          ],
        ),
      );
}

class DebouncedTextField extends StatefulWidget {
  final int marks;
  final int max;
  final bool submissionMade;
  final Future<void> Function(int) action;

  const DebouncedTextField({
    super.key,
    required this.marks,
    required this.max,
    required this.action,
    required this.submissionMade,
  });

  @override
  State<DebouncedTextField> createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounce;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.marks == 0 ? "" : widget.marks.toString(),
    );
    _focusNode = FocusNode();

    // Trigger update on focus loss
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _updateMarks(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.isEmpty || int.parse(value) > widget.max) {
      Toast.error(
        "Invalid",
        "Assigned marks can't be greater than the maximum",
      );
      return;
    }

    _debounce = Timer(const Duration(seconds: 5), () {
      if (!_isUpdating) {
        _updateMarks(value.isEmpty ? "0" : value);
      }
    });
  }

  void _onSubmitted(String value) {
    _debounce?.cancel(); // Cancel pending debounce
    _updateMarks(value); // Immediate update on Enter
  }

  Future<void> _updateMarks(String value) async {
    if (_isUpdating) return;

    final int? newMarks = int.tryParse(value);
    if (newMarks == null) return;

    _isUpdating = true;
    try {
      await widget.action(newMarks);
    } finally {
      _isUpdating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: !_isUpdating,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onChanged,
      onSubmitted: _onSubmitted,
    );
  }
}
