import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../utils/db_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  void fetchProfileData() async {
    // Fetch from local database
    isLoading.value = true;
    final localData = await DBHelper().fetchProfile();
    if (localData != null) {
      profile.value = ProfileModel(
        name: localData['name'],
        dob: localData['dob'],
        address: localData['address'],
        email: localData['email'],
        department: localData['department'],
        rollNo: localData['rollNo'],
        program: localData['program'],
      );
      isLoading.value = false;
    } else {
      isLoading.value = true;
    }

    // Fetch from server
    User? user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    String? id = user.id;

    final userResponse = await Supabase.instance.client
        .from("User")
        .select(
            "name, dob, address, Department(name), Student(rollNo, Program(name, level))")
        .eq("id", id)
        .single();

    profile.value =
        ProfileModel.fromJson({...userResponse, "email": user.email});

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
    await DBHelper().clearProfile();
    await DBHelper().insertProfile(flattenedResponse);

    isLoading.value = false;
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

  String? get name => profile.value?.name;
  String? get dob =>
      profile.value?.dob != null ? formatDate(profile.value!.dob) : null;
  String? get address => profile.value?.address;
  String? get department => profile.value?.department;
  String? get rollNo => profile.value?.rollNo;
  String? get program => profile.value?.program;
  String? get email => profile.value?.email;
}
