import 'package:flutter/material.dart';
import 'package:DumendenNav/widgets/edit_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {

  final _myBox = Hive.box('box');
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 40, top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: const Text(
                  "Lütfen devam edebilmek için aşağıdakileri doldurunuz. \n\nNot:Kişisel bilgileriniz sadece cihazınızda tutulmakta olup, herhangi bir internet ortamına aktarılmamaktadır.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "",
                widget: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'İsim')),
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextField(
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Yaş')),
                title: "",
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email')),
                title: "",
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}