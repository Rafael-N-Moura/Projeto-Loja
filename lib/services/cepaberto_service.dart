import 'dart:io';

import 'package:dio/dio.dart';
import 'package:projeto_budega/models/cepaberto_address.dart';

const token = 'c7d75a0fecf424211af8d70e4e72372e';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
