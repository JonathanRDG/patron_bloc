import 'dart:convert';
import 'dart:io';
import 'package:patron_bloc/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:patron_bloc/src/preferencias_usuario/preferencias_usuario.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-5cbee.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

 Future<bool>createProduct(ProductoModel producto)async{
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url,body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print (decodedData);
   return true;
 }



  Future<bool>editarProduct(ProductoModel producto)async{
    final url = '$_url/productos/${ producto.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url,body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print (decodedData);
    return true;
  }


 Future<List<ProductoModel>> cargarProductos() async{

   final url = '$_url/productos.json?auth=${_prefs.token}';
   final resp = await http.get(url);

   final Map<String, dynamic> decodedData = json.decode(resp.body);
   final List<ProductoModel> productos = new List();
   
   if (decodedData == null) return [];

   decodedData.forEach((id, prod){
     final prodTemp = ProductoModel.fromJson(prod);
     prodTemp.id = id;
     productos.add(prodTemp);
   });

   //print(productos[0].id);
   return productos;
 }

 Future<int> borrarProducto(String id) async{
   final url = '$_url/productos/$id.json?auth=${_prefs.token}';
   final resp = await http.delete(url);
   
   print(json.decode(resp.body));

   return 1;
 }

 Future<String> subirImagen(File imagen) async{
   
   final url = Uri.parse('https://api.cloudinary.com/v1_1/dvmfmmhaa/image/upload?upload_preset=vm9ok9e2');
   final mineType = mime(imagen.path).split('/');

   final imageUploadRequest = http.MultipartRequest(
     'post',
     url
   );

   final file = await http.MultipartFile.fromPath(
       'file',
       imagen.path,
       contentType: MediaType(mineType[0], mineType[1])
   );

   imageUploadRequest.files.add(file);

   final StreamResponse = await imageUploadRequest.send();
   final resp = await http.Response.fromStream(StreamResponse);

   if (resp.statusCode !=200 && resp.statusCode !=201)
     {
       print('ya valio');
       print(resp.body);
       return null;
     }

   final respData = json.decode(resp.body);
   print(respData);
   return respData['secure_url'];

 }
}