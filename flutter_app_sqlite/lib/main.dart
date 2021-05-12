import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sqlite/LoginPage.dart';
import 'package:flutter_app_sqlite/models/contact.dart';
import 'package:flutter_app_sqlite/utils/database_helper.dart';

const dartBlueColor = Color(0xff486579);

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda build By Nguepi using Sqlite db',
      theme: ThemeData(
        primaryColor: dartBlueColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), //MyHomePage(title: 'Agenda build By Nguepi using Sqlite db'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Contact _contact = Contact();
  final _formKey = GlobalKey<FormState>();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper ;
  final _ctrlName = TextEditingController();
  final _ctrlMobile = TextEditingController();


  @override
  void initState(){
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Center(
            child: Text(widget.title,
              style: TextStyle(color:Colors.white),
            )),
      ),
      drawer: Drawer(
        child: ListView(
          children:<Widget> [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.orange[600],
              child:Column(
                children:<Widget> [
                  //Insertion de l'image de profile de l'utilisateur connecter
                  Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.only(top: 15, bottom: 10,),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/profil2.png'),
                            fit: BoxFit.fill  //pour donner la bonne forme a notre image
                        )
                    ),
                  ),
                  // Les informations de l'utilisateur connecter
                  Text("Idriss Nguepi" ,style: TextStyle(fontSize: 22,color: Colors.black),),
                  Text("+221 774595679", style: TextStyle(fontSize:18, color: Colors.black),),
                  Text('nguepiidriss07@gmail.com',style: TextStyle(fontSize: 18,color: Colors.black),)
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.width/50,), //Ajout de l'espace entre le container d'image et les differents options

            ListTile(
              leading: Icon(Icons.build,color: Colors.orange[600],size: 28,),
              title: Text(
                'Parameter',
                style: TextStyle(
                    fontSize: 18,color: Colors.black
                ),
              ),
              onTap: (){
              },
            ),

            Divider(
              color: Colors.orange[600],
            ),
            ListTile(
                leading: Icon(Icons.power_settings_new,color: Colors.orange[600],size: 28,),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 18,color: Colors.black
                  ),
                ),
                onTap:() {
                  Navigator.of(context).pop();
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=>LoginPage()));
                }
            ),
            Divider(
              color: Colors.orange[600],
            ),
          ],
        ),

      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
            _list()
          ],
        ),
      ),
    );
  }
  _form() => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _ctrlName,
            decoration: InputDecoration(labelText: 'Full Name'),
            onSaved: (val) => setState(() => _contact.name=val),
            validator: (val) => (val.length==0 ? 'This field is reauired':null) ,
          ),
          TextFormField(
            controller: _ctrlMobile,
            decoration: InputDecoration(labelText: 'Mobile'),
            onSaved: (val) => setState(() => _contact.mobile=val) ,
            validator: (val) => (val.length<10 ? 'At least 10 characters required':null) ,
          ),
        Container(
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            onPressed: () => _onSubmit(),
            child: Text('Submit'),
            color: dartBlueColor,
            textColor: Colors.white,
          ),
        )
        ],
      ),
    ),
  );

  _refreshContactList() async{
    List<Contact> x = await _dbHelper.fetchContacts();
    setState((){
      _contacts = x;
    });
  }

  _onSubmit() async{
    var form = _formKey.currentState;
    if (form.validate()){
    form.save();;p[.]
    if(_contact.id == null){
      print(_contact.mobile);
      await _dbHelper.insertContact(_contact);
    }else {
      await _dbHelper.updateContact(_contact);
      print(_contact.name);
    }
    _refreshContactList();
    _resetForm();

    }
  }
  _resetForm(){
    setState((){
    _formKey.currentState.reset();
     _ctrlName.clear();
     _ctrlMobile.clear();
     _contact.id = null;
    });
  }

  _list() => Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _contacts.length,
          itemBuilder:(context,index){
            return Column(
              children: [
               ListTile(
                 leading: Icon(Icons.account_circle,color:dartBlueColor,size: 40.0,),
                 title: Text(_contacts[index].name.toUpperCase(),
                    style: TextStyle(color: dartBlueColor,fontWeight: FontWeight.bold),
               ),
                 subtitle: Text(_contacts[index].mobile),
                 trailing:IconButton(
                          icon:Icon(Icons.delete_sweep,color:dartBlueColor),
                   onPressed:()async{
               await _dbHelper.deleteContact(_contacts[index].id);
                  _resetForm();
                  _refreshContactList();
                   }
            ),
                onTap:(){
                   setState((){
                    _contact = _contacts[index] ;
                    _ctrlName.text = _contacts[index].name;
                    _ctrlMobile.text = _contacts[index].mobile;
                   });
                   }
                 ),
                Divider(
                 height: 5.0,
                )
              ],
            );

          },

      ),
    ),
  );
}


