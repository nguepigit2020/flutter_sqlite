import 'package:flutter_app_sqlite/custom_alert_dialog.dart';
import'package:flutter/material.dart';
import 'package:flutter_app_sqlite/main.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _keyForm2 = GlobalKey<FormState>();
  var _currencies = ['English','French'];
  var _currentItemSelected = 'English';
  String phone = '';
  String password = '';
  bool  checkboxValue = false;
  bool _obscureText = true;

  //Varriables pour changer de langue sur l'interface de connexion
  String _Login = 'Login';
  String login = 'Log in';
  String _phoneNumber = 'Mail address';
  String _password = 'Password';
  String _Remember = 'Remember credentials';
  String _ForgetPassword = 'Forget password';
  String passwordErrorMessage = 'Enter the correct password';
  String phoneErrorMessage = 'Enter the correct phone number';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 150,
              height: 100,
              margin: EdgeInsets.only(top: 100, bottom: 10,
              ),
              //pour que l image ne soit pas trop coller au bordure haute
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(image: AssetImage('assets/Login_imagee.PNG',),
                      fit: BoxFit.fill  //pour donner la bonne forme a notre image
                  )
              ),
            ),
            Text('$_Login',style: TextStyle(fontSize: 30,color: Colors.orange[600],),),

            //Ajout des champs de saissie du mot de pass et du nom d utilisateur
            new Container(
              padding: const EdgeInsets.all(20.0),
              child: new Form(
                key: _keyForm,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: '$_phoneNumber',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),)
                      ),
                      onChanged: (val) => phone = val,
                      validator: (val) => val.isEmpty || val.length < 9 ? '$phoneErrorMessage' : null,
                    ),
                    SizedBox(height: 15,),

                    //Password field for taking user credential
                    new TextFormField(
                      obscureText: _obscureText,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        labelText: "$_password",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye,color: Colors.orange[600],),
                            //Methode pour rendre le mot de passe soit visible soit invisible
                            onPressed:( ){
                              setState(() {
                                if( _obscureText ==  true) {
                                  _obscureText = false;
                                }else{
                                  _obscureText = true;
                                }
                              });
                            }
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onChanged: (val) => password = val,
                      validator: (val) => val.isEmpty || val.length < 8 ? '$passwordErrorMessage' : null,
                    ),

                    // Ajout de la composante qui permet de nous souvenir de notre mot de passe et nom d utilisateur
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end , //pour aligner l element a partie de la fin
                        children:<Widget>[
                          Text('$_Remember',style: TextStyle(fontSize: 15,color: Colors.black),),
                          Checkbox(
                            value: checkboxValue,
                            activeColor: Colors.orange[600],
                            onChanged: (bool value){
                              setState(() {
                                checkboxValue = value;
                                print(checkboxValue);
                              });
                            },
                          ),
                        ]
                    ),

                    //Ajout du bouton de connexion
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    new MaterialButton(
                      elevation: 5,
                      height: 40.0,
                      minWidth: 120.0,
                      color: Colors.orange[600],
                      splashColor: Colors.green,
                      textColor: Colors.white,
                      child: new Text('$login',style: TextStyle(fontSize: 22),),
                      onPressed: SignIn,
                    ),
                    SizedBox(height: 8.0,),

                    //Ajout du text clicable pour la reinitialisation du mot de passe
                    RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      child:Text('$_ForgetPassword',style: TextStyle(fontSize: 15,color: Colors.orange[600],),),
                      onPressed: (){showAlertDialog(context);},
                    ),
                    SizedBox(height:8.0,),

                    //Ajout du bouton deroulant pour le choix de la langue
                    DropdownButton<String>(
                      dropdownColor: Colors.white,
                      elevation: 0,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: false,
                      //creer de l espace entre le label et l icone
                      style: TextStyle(color: Colors.black, fontSize: 22.0,),
                      items: _currencies.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        // My code to execute, when the item is selected
                        setState(() {
                          this._currentItemSelected = newValueSelected;
                          if(newValueSelected == 'French'){
                            _Login = 'Connexion';
                            login = 'Se connecter';
                            _phoneNumber = 'Adresse email';
                            _password = 'Mot de passe';
                            _Remember = 'Mémoriser mes identifiants';
                            _ForgetPassword = 'Mot de passe oublié';
                            passwordErrorMessage = 'Entrez le mot de passe correct';
                            phoneErrorMessage = 'Entrez le numéro de téléphone correct';
                          }else{
                            _Login = 'Login';
                            login = 'Log in';
                            _phoneNumber = 'Mail address';
                            _password = 'Password';
                            _Remember = 'Remember credentials';
                            _ForgetPassword = 'Forget password';
                            passwordErrorMessage = 'Enter the correct password';
                            phoneErrorMessage = 'Enter the correct phone number';
                          }
                        }); //we have to use statefulwidet for the method setState()
                      },
                      value: _currentItemSelected,
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
  void showAlertDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          TextEditingController _emailControllerField = TextEditingController();
          return CustomAlertDialog(
            content: Container(
              margin: EdgeInsets.only(bottom: 8.0),
              color: Colors.white,
              child: SingleChildScrollView(
                  child: Column(
                    children:<Widget> [
                      Text("Please enter your mail addres.",style: TextStyle(fontSize: 22),),
                      Divider(
                        color: Colors.grey,
                      ),
                      Form(
                        key: _keyForm2,
                      child:TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailControllerField,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black
                                )
                            ),
                            hintText: "example@gmail.com",
                            labelText: "email",
                            labelStyle: TextStyle(color: Colors.black,fontSize: 18)
                        ),
                      ),
              ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0.0),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.amber[700],
                          child: MaterialButton(
                            minWidth:(MediaQuery.of(context).size.width + MediaQuery.of(context).size.height)/4,
                            padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
                            child: Text(
                              "Send Reset Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: (){
                              if (_keyForm2.currentState.validate()) {
                            FirebaseAuth.instance.sendPasswordResetEmail(email: _emailControllerField.text );
                            Navigator.of(context).pop();
                              }
                              },
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),

          );
        }
    );
  }
  Future<void> SignIn() async{
    final formState = _keyForm.currentState;
    if(formState.validate()){
      formState.save();
      try{
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email:phone, password: password);
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Agenda build By Nguepi'),));
        //TODO: Navite to home
      }catch(e){
      print(e.message);
      }

    }
  }
}

