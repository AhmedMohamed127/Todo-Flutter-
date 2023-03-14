
import 'package:untitled2/layouts/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:untitled2/shared/CubitTodo/cubit.dart';

Widget deafultFormField({
   TextEditingController controller,
   TextInputType type,
   Function validator,
  OnTap,
  IconData  prefix,
  String  label,
})=>TextFormField(
  controller: controller,
  keyboardType: type,
  validator: (String  value){
    return validator(value);
  },
  decoration: InputDecoration(
    prefixIcon: Icon(
      prefix
    ),
    labelText: label,
    border: OutlineInputBorder()
  ),
  onTap: OnTap,

);

Widget BuildTaskItem(Map model,context)=>InkWell(
  onTap: (){
  },
  child:   Dismissible(

    key: Key(model['id'].toString()),

    child:  Padding(

      padding: const EdgeInsets.all(15.0),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          CircleAvatar(


            radius: 50.0,

            child: Text(

              '${model['time']}',

              style: TextStyle(

                  color:
                  Colors.white,

                  fontSize: 20.0

              ),

            ),

          ),



          SizedBox(

            width: 20.0,

          ),

          Expanded(

            child: Column(

              children: [

                Text(

                  '${model['title']}',

                  style: TextStyle(

                      color: Colors.black,

                      fontSize: 30.0

                  ),

                ),



                Text(

                  '${model['date']}',

                  style: TextStyle(

                      color: Colors.grey,

                      fontSize: 15.0

                  ),

                ),

                Text(

                  '${model['description']}',

                  style: TextStyle(

                      color: Colors.black,

                      fontSize: 10.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed:()
              {
                AppCubit.get(context).UpdateDatabase(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,

              )
          ),



          IconButton(
              onPressed:()
              {
                AppCubit.get(context).UpdateDatabase(status: 'archived', id: model['id']);
              },
              icon: Icon(
                Icons.archive,

                color: Colors.black38,

              )
          ),
        ],
      ),
    ),

    onDismissed: (direction)

    {

      AppCubit.get(context).DeleteDatabase(id: model['id']);

    },

    background: Container(

      color: Colors.redAccent,

      child: Icon(

        Icons.delete

      ),

        alignment: Alignment.centerRight

    ),
    confirmDismiss: (DismissDirection direction) async {
      return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you want to delete this task?"),
            actions: <Widget>[
              MaterialButton(
                  onPressed: ()=> Navigator.of(context).pop(true),
                  child: const Text("DELETE")
              ),
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              ),
            ],
          );
        },
      );
    },

  ),
);



TaskBuilder({
     List<Map>tasks,
   BuildContext context
  })=> Conditional.single(
    context: (context),
    conditionBuilder: (context)=>tasks.length>0,
    widgetBuilder:(context)=>ListView.separated(itemBuilder: (context,index)=>BuildTaskItem(tasks[index],context)
        , separatorBuilder: (context,index)=>Container(
          width: double.infinity,
          color: Colors.grey,
        )
        , itemCount: tasks.length
    ) ,
    fallbackBuilder:(context)=> Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey,
              size: 40.0,
            ),
            Text('No Tasks yet',
              style: TextStyle(
                  color: Colors.grey
              ),
            )
          ],
        )),
  );

deafultChallengeFormField({
   TextEditingController controller,
   TextInputType type,
  IconData  prefix,
  IconData  suffix,
  String  HintText,
})=>TextFormField(
  controller: controller,
  keyboardType: type,
  decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
      ),
      filled: true,
      fillColor: Colors.white,
      hintText: HintText,
      prefixIcon: Icon(prefix),
    suffixIcon: Icon(suffix),


  ),

);


Widget deafultbutton({
 // double width=double.infinity,
  Color background ,
  bool IsUpperCase=true,
  //double radius=0.0,
  dynamic  buttonIcon,
   Function function,
   String text,

})=>Container(
  //width: width,
  child: SizedBox(
    height: 50,
    width: 100,
    child: MaterialButton(
      onPressed:(){
        function();
      },
      child: Text(
        IsUpperCase?text.toUpperCase():text,
        style:TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color:background,
    image:buttonIcon,
  ),
);

void NavigateTo(context,widget) => Navigator.push(context,
    MaterialPageRoute(
        builder: (context)=> widget
    ));







