import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, this.title, this.route,this.icon
  ,this.actions});


  final String? title;
  final String? route;
  final FaIcon? icon;
  final List<Widget>? actions;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.title!, style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.bold,color: config.primaryColor),
      ),
      leading: widget.icon != null ? Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: config.primaryColor
        ),
        child: IconButton(
          onPressed: (){
            if(widget.route != null){
              Navigator.of(context).pushNamed(widget.route!);
            }else{
              Navigator.of(context).pop();
            }
          },
          icon: widget.icon!,
          color: Colors.white,
          iconSize: 16,
        ),
      ): null,
      actions: widget.actions,
    );
  }
}
