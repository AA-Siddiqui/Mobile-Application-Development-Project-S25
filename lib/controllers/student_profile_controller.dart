import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_profile_model.dart';
import '../utils/db_helper.dart';

class StudentProfileController extends GetxController {
  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var profileRx = Rxn<StudentProfileModel>();
  StudentProfileModel? get profile => profileRx.value;
  set profile(StudentProfileModel? value) => profileRx.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  void fetchProfileData() async {
    // Fetch from local database
    isLoading = true;
    final localData = await DBHelper.studentProfile.fetchProfile();
    if (localData != null) {
      profile = StudentProfileModel(
        name: localData['name'],
        dob: localData['dob'],
        address: localData['address'],
        email: localData['email'],
        department: localData['department'],
        rollNo: localData['rollNo'],
        program: localData['program'],
      );
      isLoading = false;
    } else {
      isLoading = true;
    }

    // Fetch from server
    User? user = SupabaseService.user.user;
    if (user == null) {
      isLoading = false;
      return;
    }

    final userResponse = await SupabaseService.user.getStudentProfilePageData();

    profile =
        StudentProfileModel.fromJson({...userResponse, "email": user.email});

    Map<String, dynamic> flattenedResponse = {
      "name": userResponse["name"],
      "dob": userResponse["dob"],
      "address": userResponse["address"],
      "department": userResponse["Department"]["name"],
      "rollNo": userResponse["Student"][0]["rollNo"],
      "program":
          "${userResponse["Student"][0]["Program"]["level"]} at ${userResponse["Student"][0]["Program"]["name"]}",
      "email": user.email,
    };

    // Update local database
    await DBHelper.studentProfile.clearProfile();
    await DBHelper.studentProfile.insertProfile(flattenedResponse);

    isLoading = false;
  }

  String formatDate(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    int month = parsedDate.month;
    int day = parsedDate.day;
    int year = parsedDate.year;
    return "${[
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][month - 1]} ${day.toString().padLeft(2, '0')}, $year";
  }

  String? get name => profile?.name;
  String? get dob => profile?.dob != null ? formatDate(profile!.dob) : null;
  String? get address => profile?.address;
  String? get department => profile?.department;
  String? get rollNo => profile?.rollNo;
  String? get program => profile?.program;
  String? get email => profile?.email;
}
