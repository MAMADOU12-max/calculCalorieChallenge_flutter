import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calcul Calories'),
      debugShowCheckedModeBanner: false,
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


  bool interrupteur = false;
  bool women = true;
  double taille = 135;
  double poids;
  int calorieBase;
  int calorieAvecActivite;


  // function for adapt color
  adaptColor () {
    Color adaptColor = women ? Colors.pink : Colors.blue;
    return adaptColor;
  }

  textWithStyle(String data, {fontSize: 15.0, color: Colors.white}) {   // for give default value some property
    return new Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fontSize,
          color: color
      ),
    );
  }

  // ------------------------------------------------------------------------- Radio -----------------------------------------------------------------------//

  int radioSelected;

  Map activities = {
     0: 'Faible' ,
     1: 'Modérée' ,
     2: 'Forte' ,
  };

   Row radio() {
      List<Widget> thisSelected = [];
      activities.forEach((key, value) {
           Column colonne =  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 new Radio(
                   fillColor: MaterialStateProperty.all(adaptColor()),
                   //    activeColor: adaptColor(),
                      value: key,                                               // key of list
                      groupValue: radioSelected,
                      onChanged: (Object i) {
                      setState(() {
                           radioSelected = i;
                      });
                    }
                ),
                textWithStyle(value, color:adaptColor())
             ],
          );
          thisSelected.add(colonne);
      });

      return new Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: thisSelected,
      );
  }


  Padding padding(double x) {
      return new Padding(padding: EdgeInsets.only(top: x));
  }

  double age;
  // for date
  Future<Null> showPicker() async {
      DateTime choice = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1983),
          lastDate: DateTime.now(),
           initialDatePickerMode: DatePickerMode.year,
      );
      if( choice != null )  {
           var difference = new DateTime.now().difference(choice);  // for getting difference
           var jours = difference.inDays;   // convert differce to day
           var ans = (jours / 365);     // convert day to year
           setState(() {
                age = ans;
           });
      }
  }

  void calculerNombredeCalories() {
      if(age !=  null && poids != null && radioSelected != null) {
           if(women) {
               calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.07750 * age)).toInt() ;
           } else {
               calorieBase = (655.0955 + (9.5616 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt() ;
           }
           switch(radioSelected) {
               case 0:
                   calorieAvecActivite = (calorieBase * 1.2).toInt() ;
                   break;
               case 1:
                   calorieAvecActivite = (calorieBase * 1.2).toInt() ;
                   break;
               case 2:
                   calorieAvecActivite = (calorieBase * 1.2).toInt() ;
                   break;
                default:
                 calorieAvecActivite = calorieBase;
                 break;
           }

           setState(() {
               dialogValid();
           });

      } else {
         // Alert pas assez d'element!
        alertNotValid();
      }
  }

  Future<Null> alertNotValid() async {
      return showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext buildContext) {
              return new AlertDialog(
                  title: textWithStyle('Erreur'),
                  content: textWithStyle('Tous les champs ne sont pas remplis!', color: Colors.black ),
                  actions: <Widget>[
                       new TextButton(
                           onPressed: () {
                               Navigator.pop(buildContext);
                           },
                           child: textWithStyle( 'OK', color: Colors.red ),
                       ),
                  ],
              );
      });
  }

  Future<Null> dialogValid() async{
     return showDialog(
         context: context,
         builder: (BuildContext buildContext) {
            return new SimpleDialog(
                title: textWithStyle('Votre besoin en colories', color: adaptColor()),
                contentPadding: EdgeInsets.all(15.0),
                children: [
                   textWithStyle('Votre besoin de base est de : ${calorieBase}', color: Colors.black),
                    padding(10),
                   textWithStyle('Votre besoin avec activité sportive est de : $calorieAvecActivite', color: Colors.black),
                   TextButton(
                       onPressed: () {
                          Navigator.pop(buildContext);
                       },
                       child: textWithStyle('Ok'),
                        style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all<Color>(adaptColor()),
                        ),
                   ),
                ],
            );
         }
     );
  }

  @override
  Widget build(BuildContext context) {

    if(Platform.isIOS) {
        print('nous sommes sur ios');
    } else {
      print('Nous ne sommes pas sur ios');
    }

    return GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
        child:   Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            backgroundColor:  adaptColor(),
            titleTextStyle: TextStyle(

            ),
            elevation: 45.0,
            // foregroundColor: Colors.green,
            shadowColor: Colors.white,
            toolbarTextStyle: TextStyle(
                backgroundColor: Colors.green
            ),
          ),
          body: Container(
              padding: EdgeInsets.all(10),
              child:  SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      padding(25.0),
                      textWithStyle('Remplissez toutes les champs pour obtenir votre besoin de calories', fontSize :17.0, color: adaptColor()),
                      padding(25.0),
                      Card(
                          elevation: 12.0,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    textWithStyle('Femme', color: Colors.pinkAccent),
                                    Switch(
                                        value: interrupteur,
                                        activeColor: Colors.blue,
                                        inactiveThumbColor: Colors.pink,
                                        onChanged: (bool b) {
                                          setState(() {
                                            interrupteur = b;
                                            women = !women;
                                          });
                                        }
                                    ),
                                    textWithStyle('Homme', color: Colors.blue),
                                  ],
                                ),
                                padding(25.0),
                                ElevatedButton(
                                  onPressed: showPicker,
                                  child: textWithStyle(
                                      (age == null) ? 'Appuyez pour entrez votre age' : 'Votre êtes agé de ${age.toInt()} ans' ,
                                      fontSize: 16.0,
                                      color: Colors.white
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(adaptColor()),
                                  ),
                                ),
                                padding(40.0),
                                textWithStyle('Votre taille est de ${taille.toInt()}', fontSize: 16.0, color: adaptColor()),
                                Slider(
                                    value: taille,
                                    min: 0.0,
                                    max: 200,
                                    divisions: 200,
                                    activeColor: adaptColor(),
                                    inactiveColor: Colors.grey[700],
                                    onChanged: (double selctedTaille) {
                                      setState(() {
                                        taille = selctedTaille;
                                      });
                                    }
                                ),
                                padding(25.0),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Entrez votre poids en kilos.',
                                    labelStyle: TextStyle(
                                      color: adaptColor(),
                                    ),
                                  ),
                                  onChanged: (String string) {
                                     setState(() {
                                         poids = double.tryParse(string);        //convert get value to string
                                     });
                                  },
                                ),
                                padding(40.0),
                                textWithStyle('Quel est votre activité sportive ?', fontSize: 17.0, color: adaptColor()),
                                padding(10.0),
                                // radio
                                radio(),
                              ],
                            ),
                          )
                      ),
                      padding(25.0),
                      ElevatedButton(
                        onPressed: calculerNombredeCalories,
                        child: textWithStyle('Calculer', fontSize: 16.0),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(adaptColor()),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        ),
    );

  }
}
