import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class TeacherAttendanceListController extends GetxController {
  /// TODO: Implement caching mechanism for schedule lists
  /// This will be done by making a teacher_attendance_list_actions.dart and teacher_attendance_list_model.dart
  /// file and registering the action in the DBHelper class.

  TeacherAttendanceListController(int classId) {
    getSchedules(classId);
  }

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var schedulesRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get schedules => schedulesRx.value;
  set schedules(List<Map<String, dynamic>> value) => schedulesRx.value = value;

  String _formatDate(String date) {
    DateTime parsedDateTime = DateTime.parse(date).toLocal();
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return "${monthNames[parsedDateTime.month - 1]} "
        "${parsedDateTime.day}, "
        "${parsedDateTime.year}";
  }

  String _formatTime(String time) {
    DateTime parsedDateTime = DateTime.parse(time).toLocal();
    int hour = parsedDateTime.hour;
    int minute = parsedDateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')} $period";
  }

  void getSchedules(int classId) async {
    isLoading = true;
    final data = await SupabaseService.course.getSchedules(classId);

    schedules = data.map((schedule) {
      return {
        "id": schedule["id"],
        "date": _formatDate(schedule["startTime"]),
        "startTime": _formatTime(schedule["startTime"]),
        "endTime": _formatTime(schedule["endTime"]),
        "attendance": schedule["Attendance"].map((student) {
          return {
            "id": student["id"],
            "studentId": student["Student"]["id"],
            "studentName": student["Student"]["User"]["name"],
            "rollNo": student["Student"]["rollNo"],
            "present": student["present"],
          };
        }).toList(),
      };
    }).toList();

    isLoading = false;
  }
}
