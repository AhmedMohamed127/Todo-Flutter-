import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:intl/intl.dart';

import '../../shared/CubitTodo/cubit.dart';
import '../../shared/CubitTodo/states.dart';
import '../../shared/reusableComponents/reusableComponents.dart';

/*class homeScreen extends StatefulWidget
{
  @override
  _homeScreenState createState() => _homeScreenState();
}*/

class homeScreen extends StatelessWidget
{

  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var FormKey = GlobalKey<FormState>();
  var TextController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();
  var importaceCotroller = TextEditingController();

  /*void initState() {
    super.initState();

    createDatabase();
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(

        listener: (BuildContext context, AppStates state)
        {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }

        },
        builder: (BuildContext context, Object state)
        {

          AppCubit cubit=AppCubit.get(context);

          return Scaffold(
          key: ScaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body:  Conditional.single(
              context: context,
              conditionBuilder: (context)=>/*tasks.length>0*/ true,
              widgetBuilder: (context)=>cubit.Screens[cubit.currentIndex],
              fallbackBuilder:(context)=>Center(child: CircularProgressIndicator()) ),

          /*condition: tasks.length>0,
          builder: (context)=>Screens[currentIndex],
          fallback: (context)=>Center(child: CircularProgressIndicator()),*/


          floatingActionButton: FloatingActionButton(
            onPressed: () {

              /* getName().then((value){
                    print(value);
                    print('habiba');
                    throw('there is an error here');


                  }).catchError((error){
                    print('error ${error.toString()}');
                    returnCompleter<Never>().future;
                  });*/

              if (cubit.isbottomsheet) {
                if (FormKey.currentState.validate()) {
                  cubit.InsertToDatabase(
                      title: TextController.text,
                      date: dateController.text,
                      time: timeController.text,
                      description: descriptionController.text
                  );
                 /* InsertToDatabase(title: TextController.text,
                      time: TimeController.text,
                      date: DateController.text).then((value) {
                    Navigator.pop(context);
                    isbottomsheet = false;
                    /* setState(() {
                      fabIcon = Icons.edit;
                    });*/
                  });*/
                }
              } else {
                ScaffoldKey.currentState.showBottomSheet((context) =>
                    Form(
                      key: FormKey,
                      child: Container(
                        padding: EdgeInsets.all(15.0,),
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            deafultFormField(
                              controller: TextController,
                              type: TextInputType.text,
                              validator: (String  value) {
                                if (value.isEmpty) {
                                  return 'يجب ادخال عنوان';
                                }
                                return null;
                              },
                              label: 'عنوان الموضوع',
                              prefix: Icons.title,
                            ),
                            SizedBox(height: 15,),
                            deafultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              OnTap: () {
                                showTimePicker
                                  (context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text =
                                      value.format(context).toString();
                                });
                              },
                              validator: (String  value) {
                                if (value.isEmpty) {
                                  return 'يجب ادخال وقت';
                                }
                                return null;
                              },
                              label: 'وقت الموضوع',
                              prefix: Icons.title,
                            ),
                            SizedBox(height: 15,),
                            deafultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              OnTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse('2022-03-04'),
                                  firstDate: DateTime.parse('2022-03-04'),
                                  lastDate: DateTime.parse('2022-04-15'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                }
                                );
                              },
                              validator: (String  value) {
                                if (value.isEmpty) {
                                  return 'يجب ادخال تاريخ';
                                }
                                return null;
                              },
                              label: 'تاريخ الموضوع',
                              prefix: Icons.title,
                            ),
                            SizedBox(height: 15,),
                            deafultFormField(
                              controller: descriptionController,
                              type: TextInputType.text,
                              validator: (String  value) {
                                if (value.isEmpty) {
                                  return 'يجب ادخال وصف';
                                }
                                return null;
                              },
                              label: 'وصف الموضوع',
                              prefix: Icons.description_outlined,
                            ),
                            SizedBox(height: 15),
                            deafultFormField(
                              controller: importaceCotroller,
                              type: TextInputType.text,
                              validator: (String  value) {
                                if (value.isEmpty) {
                                  return 'يجب ادخال الاهمية';
                                }
                                return null;
                              },
                              label: 'اهمية الموضوع',
                              prefix: Icons.label_important,
                            )
                          ],
                        ),
                      ),
                    )
                ).closed.then((value) {
                  cubit.changeBottomsheet(isshow: false, icons: Icons.edit);
                });
                cubit.changeBottomsheet(isshow: true, icons: Icons.add);
                //isbottomsheet = true;
                /* setState(() {
                  fabIcon = Icons.add;
                });*/
              }
            },
            child: Icon(
               cubit.fabIcon
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              AppCubit.get(context).changeIndex(index);

              /* setState(() {
                currentIndex = index;
              });*/
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu),
                label: 'المهام',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline),
                label: 'المنجز',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),
                label: 'الارشيف',
              ),
            ],
          ),
        );},
      ),
    );
  }

   Future getName() async
  {
    return await('Ahmed Mohamed')  ;
  }





}




