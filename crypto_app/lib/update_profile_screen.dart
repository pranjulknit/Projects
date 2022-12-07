import 'package:crypto_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController age = TextEditingController();
  Future<void> saveData(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, value);
  }

  void saveUserDetails() async {
    await saveData('name', name.text);
    await saveData('email', email.text);

    print('Data Saved');
  }

  bool isDarkModeEnabled = AppTheme.isDarkModeEnabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: Text("Profile Update"),
      ),
      body: Column(children: [
        customTextField("Name", name),
        customTextField("Email", email),
        customTextField('Age', age),
        ElevatedButton(
            onPressed: () {
              saveUserDetails();
            },
            child: Text("Save Details"))
      ]),
    );
  }

  Widget customTextField(String title, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkModeEnabled ? Colors.white : Colors.grey),
          ),
          hintText: title,
          hintStyle: TextStyle(color: isDarkModeEnabled ? Colors.white : null),
        ),
      ),
    );
  }
}
