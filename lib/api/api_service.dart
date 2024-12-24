import 'package:dio/dio.dart';
import 'package:requests_with_riverpod/models/auth_response.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'http://10.0.2.2:8000/api/v1')
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @GET('/cats/')
  Future<List<Cat>> getCats();

  @GET('/cat-detail/{id}')
  Future<Cat> getCatsDetail(@Path('id') int id);

  @POST('/create-cat/')
  Future<void> createCat(@Body() Map<String, dynamic> body);

  @POST('/token/')
  Future<AuthResponse> getAuthToken(@Body() Map<String, dynamic> body);

  @POST('/token/refresh/')
  Future<AuthResponse> refreshAuthToken(@Body() Map<String, dynamic> body);

  @POST('/cats/{id}/rate/')
  Future<void> rateCat(@Path('id') int id, @Body() Map<String, dynamic> body);

  @GET('/kinds/')
  Future<List<Kind>> getKinds();

  @GET('/cats/{id}/')
  Future<List<Cat>> getCatsByKind(@Path('id') int id);

  @GET('/cats-by-user/{user_id}/')
  Future<List<Cat>> getCatsByUser(@Path('user_id') int userId);

  @DELETE('/cat-delete/{id}/')
  Future<void> deleteCatById(@Path('id') int id);

  @PATCH('/cat-update/{id}/')
  Future<void> updateCatById(
      @Path('id') int id, @Body() Map<String, dynamic> body);

  @PUT('/cat-update/{id}/')
  Future<void> updateWholeCatById(
      @Path('id') int id, @Body() Map<String, dynamic> body);
}
