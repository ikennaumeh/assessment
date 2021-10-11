import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_test/core/data/response_model/medication_model.dart';
import 'package:new_test/ui/views/home/home_view_model.dart';
import 'package:new_test/ui/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final _auth = FirebaseAuth.instance;

  String? name = '';

  Future getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("username");
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, ';
    }
    if (hour < 17) {
      return 'Good Afternoon, ';
    }
    return 'Good Evening, ';
  }

  @override
  void initState() {
    super.initState();
    getName();
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: greeting(),
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: name,
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]
                      ),
                    ),
                    const SizedBox(height: 30,),
                    FutureBuilder(
                      future: model.getMedication(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        if(snapshot.hasData){
                          MedicationModel medication = snapshot.data;
                          final data = medication.problems[0].diabetes[0].medications[0].medicationsClasses[0];
                          return ListView(
                            shrinkWrap: true,
                            children: [
                            ListTile(
                            title: Text(
                              data.className[0].associatedDrug[0].name
                              ),
                              subtitle: Text(
                                  data.className[0].associatedDrug[0].strength
                              ),
                              trailing: Text(
                                data.className[0].associatedDrug[0].dose!.isEmpty ? "twice a day" : data.className[0].associatedDrug[0].dose!,
                              ),
                            ),
                              ListTile(
                                title: Text(
                                    data.className[0].associatedDrug2[0].name
                                ),
                                subtitle: Text(
                                    data.className[0].associatedDrug2[0].strength
                                ),
                                trailing: Text(
                                  data.className[0].associatedDrug2[0].dose!.isEmpty ? "once a day" : data.className[0].associatedDrug2[0].dose!,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                    data.className2[0].associatedDrug[0].name
                                ),
                                subtitle: Text(
                                    data.className2[0].associatedDrug[0].strength
                                ),
                                trailing: Text(
                                  data.className2[0].associatedDrug[0].dose!.isEmpty ? "twice a day" : data.className2[0].associatedDrug[0].dose!,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                    data.className2[0].associatedDrug2[0].name
                                ),
                                subtitle: Text(
                                    data.className2[0].associatedDrug2[0].strength
                                ),
                                trailing: Text(
                                  data.className2[0].associatedDrug2[0].dose!.isEmpty ? "once a day" : data.className2[0].associatedDrug2[0].dose!,
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError){
                          return Center(child: Text('${snapshot.error}'));
                        }

                        return const Center(child: CircularProgressIndicator(),);
                      },
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app_outlined),
        onPressed: ()async{
          await _auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginView()));
        },
      ),
    ),);
  }
}
