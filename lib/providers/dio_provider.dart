import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class DioProvider {

  Future<dynamic> getToken(String email, String password)async{
    try {
      var response = await Dio().post("http://10.0.2.2:8000/api/login",
        data: {'email':email,'password':password},
      );

      if(response.statusCode ==200&& response.data !=''){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('Token', response.data);
        return true;
      }else{
        return false;
      }
    } catch (e) {
      return print("error is $e");
    }
  }

  Future<dynamic> getUser(String token) async{
    try{
      var user = await Dio().get("http://10.0.2.2:8000/api/user",
      options: Options(headers: {
        "Accept": "application/json",
        'Authorization' : 'Bearer $token',},
        followRedirects: false,
        validateStatus: (status) { return status! < 500; }
      ));

      if(user.statusCode==200 && user.data!=''){
        return json.encode(user.data);
      }
    }catch(e){
      return "error is $e";
    }
  }

  Future<dynamic> registerUser(String name,String email,String password) async{
    try{
      var user = await Dio().post("http://10.0.2.2:8000/api/register",
        data: {'name': name, 'email':email,'password':password},
      );

      if(user.statusCode==201 && user.data!=''){
        return true;
      }else{ return false;}
    }catch(e){
      return print("error is ${e}");
    }
  }

  Future<dynamic> bookAppointment(String date,String day,String time,int doctor,String token) async{
    try{
      var response = await Dio().post("http://10.0.2.2:8000/api/book",
        data: {'date': date, 'day':day,'time':time, 'doctor_id':doctor},
        options: Options(headers: {'Authorization' : 'Bearer $token'})
      );

      if(response.statusCode==200 && response.data!=''){
        return response.statusCode;
      }else{ return "error";}
    }catch(e){
      return e;
    }
  }

  Future<dynamic> storeReviews(String reviews,double ratings,int id,int doctor,String token) async{
    try{
      var response = await Dio().post("http://10.0.2.2:8000/api/reviews",
        data: {'reviews': reviews, 'ratings':ratings,'appointment_id':id, 'doctor_id':doctor},
        options: Options(headers: {'Authorization' : 'Bearer $token'})
      );

      if(response.statusCode==200 && response.data!=''){
        return response.statusCode;
      }else{ return "error";}
    }catch(e){
      return e;
    }
  }


  Future<dynamic> storeFavDoc(List<dynamic> favList,String token) async{
    try{
      var response = await Dio().post("http://10.0.2.2:8000/api/fav",
        data: {'favList':favList},
        options: Options(headers: {'Authorization' : 'Bearer $token'})
      );

      if(response.statusCode==200 && response.data!=''){
        return response.statusCode;
      }else{ return "error";}
    }catch(e){
      return e;
    }
  }

  Future<dynamic> logout(String token) async{
    try{
      var response = await Dio().post("http://10.0.2.2:8000/api/logout",
        options: Options(headers: {'Authorization' : 'Bearer $token'})
      );

      if(response.statusCode==200 && response.data!=''){
        return response.statusCode;
      }else{ return "error";}
    }catch(e){
      return e;
    }
  }

  Future<dynamic> getAppointments(String token) async{
    try{
      var response = await Dio().get("http://10.0.2.2:8000/api/appointments",
          options: Options(headers: {'Authorization' : 'Bearer $token'})
      );

      if(response.statusCode==200 && response.data!=''){
        return json.encode(response.data);
      }else{ return "error";}
    }catch(e){
      return e;
    }
  }

}