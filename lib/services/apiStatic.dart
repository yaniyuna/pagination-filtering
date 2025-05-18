import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_pagination/model/petani.dart';

class ApiStatic{
  //static final host='http://192.168.43.189/webtani/public';
  static final host='https://dev.wefgis.com/api/petani?s';
  static var _token="8|x6bKsHp9STb0uLJsM11GkWhZEYRWPbv0IqlXvFi7";

  static Future<List<Petani>> getPetaniFilter(int pageKey, String _s,String _selectedChoice) async{
    try {
      // getPref();
      final response= await http.get(Uri.parse("$host/api/petani?page="+pageKey.toString()+"&s="+_s+"&publish="+_selectedChoice),
      headers: {
        'Authorization':'Bearer '+_token,
      });      
      if (response.statusCode==200) {
        var json=jsonDecode(response.body);
        //print(json);
        final parsed=json['data'].cast<Map<String, dynamic>>();
        return parsed.map<Petani>((json)=>Petani.fromJson(json)).toList();
      } else {
        return [];
      }
      } catch (e) {
        return [];
    }
  }

  static Future<bool> updatePetani(Petani petani) async {
  try {
    final response = await http.put(
      Uri.parse("https://dev.wefgis.com/api/petani/${petani.idPenjual}"),
      // headers: {
      //   'Authorization': 'Bearer $_token',
      //   'Content-Type': 'application/json',
      // },
      body: jsonEncode(petani.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Failed to update petani: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Exception updatePetani: $e');
    return false;
  }
}


  static Future<bool> deletePetani(String idPenjual) async {
  try {
    final response = await http.delete(
      Uri.parse("https://dev.wefgis.com/api/petani/$idPenjual"),
      // headers: {
      //   'Authorization': 'Bearer $_token',
      // },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Failed to delete petani: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Exception deletePetani: $e');
    return false;
  }
}

}