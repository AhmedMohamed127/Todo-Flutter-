
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled2/models/archived.dart';
import 'package:untitled2/models/tasks.dart';
import 'package:untitled2/shared/CubitTodo/states.dart';

import '../../models/done.dart';



class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(IntialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;

  Database  database;


  List<Map> NewTasks=[];
  List<Map> DoneTasks=[];
  List<Map> archivedTasks=[];
  List<Map> demoApp=[];


  List<Widget> Screens = [
    tasksScreen(),
    doneScreen(),
    archivedScreen(),
  ];
  List<String> titles = [
    'المهام',
    'المنجز',
    'الارشيف'
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeNavbarState());

  }

  void createDatabase()
  //async
  {
   // database = await
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) {
          print('database created');
          database.execute(
              ' CREATE TABLE TASKS (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,description TEXT,status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('error is${error.toString()}');
          });
        },
        onOpen: (database) {
          print('database opened');

          getDataFromDatabase(database);

        }
    ).then((value)
    {
      database=value;
      emit(AppCreatDatabaseState());

    });
  }

   InsertToDatabase({
     String title,
     String date,
     String time,
     String description

   }) async
  {
    return await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks (title,date,time,description,status) VALUES ("$title","$date","$time","$description","new")')
          .then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database).then((value)
        {

          emit(AppGetDatabaseState());
        });

      }).catchError((error) {
        print('there is an error ${error.toString()}');
      });
    });
  }

  //Future <List<Map>>
  getDataFromDatabase(database) //async
  {
    NewTasks=[];
    DoneTasks=[];
    archivedTasks=[];
    demoApp=[];

    //return await
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
     // tasks=value;print(tasks);
      value.forEach((element)
      {
        if(element['status'] == 'new')
          NewTasks.add(element);
        else if (element['status'] == 'done')
          DoneTasks.add(element);
        else  archivedTasks.add(element);

      });




      emit(AppGetDatabaseState());
      /*setState(() {
              tasks=value;
            });*/
    }
    );
  }

  UpdateDatabase({
     String status,
     int id,
})async
  {
     await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
     ).then((value) {

       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }

  DeleteDatabase({
     int id,
})async
  {
     await database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',[id]

     ).then((value) {

       getDataFromDatabase(database);
       emit(AppDeleteDatabaseState());
     });
  }


  bool isbottomsheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomsheet({
   bool isshow,
   IconData icons,
})
  {
    isbottomsheet=isshow;
    fabIcon=icons;
    emit(AppChangeBottomSheetState());

  }

  Future getdescription(Map model,context) async
  {
    return await('${model['description']}')  ;
  }

}