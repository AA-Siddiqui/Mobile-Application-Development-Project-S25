import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  String? name;
  String? department;
  String? dob;
  String? email;
  String? address;
  String? rollNo;
  String? program;
  @override
  void initState() {
    super.initState();
    User? user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;
    String? id = user.id;
    email = user.email;

    Supabase.instance.client
        .from("User")
        .select(
            "name, dob, address, Department(name), Student(rollNo, Program(name, level))")
        .eq("id", id)
        .single()
        .then(
      (userResponse) {
        setState(
          () {
            name = userResponse['name'];
            dob = userResponse['dob'];
            address = userResponse['address'];
            department = userResponse['Department']['name'];
            rollNo = userResponse['Student'][0]['rollNo'];
            program =
                "${userResponse['Student'][0]['Program']['level']} at ${userResponse['Student'][0]['Program']['name']}";
            _isLoading = false;
          },
        );
      },
    );
  }

  String formatDate(String dateString) {
    DateTime parsedDate =
        DateTime.parse(dateString); // Convert String to DateTime

    // Extract month, day, and year
    int month = parsedDate.month;
    int day = parsedDate.day;
    int year = parsedDate.year;

    // Format manually
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

  Widget _buildTile(String title, String? value) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            value ?? title,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    child: BackButton(),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 64,
                              ),
                              Text(
                                name ?? "Name",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Department of ${department ?? "Department"}",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildTile("Program", program),
                              _buildTile("Roll No", rollNo),
                              _buildTile("Email", email),
                              _buildTile("Address", address),
                              _buildTile("Date of Birth",
                                  formatDate(dob ?? "2003-07-17")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
