import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/domain/core/http_client/domain.dart';
import 'package:weather_app/domain/core/http_client/response.dart';

class AcceptType {
  static String json = 'application/json; charset=UTF-8';
  static String formData = 'multipart/form-data';
  static String urlEncode = 'application/x-www-form-urlencoded';
}

final Map<String, String> defaultHeader = {
  'Accept': AcceptType.json,
  'Content-Type': AcceptType.json,
};

final Map<String, String> encodeHeader = {
  'Accept': AcceptType.json,
//  'Content-Type': AcceptType.urlEncode,
};

final Map<String, String> formHeader = {
  'Accept': AcceptType.formData,
  'Content-Type': AcceptType.formData,
};

class HttpClient {
  static final String baseUrl = Domain.instance.baseUrl;
  static const int timeOutEx = 10;
  late Map<String, String> headers;
  late Map<String, String> config;
  late int timeOut;
  late String _urlRequest;
  String? userToken;
  bool useLoading;
  final Widget? showSnackBar;

  HttpClient({
    int? timeOut,
    String? url,
    required String route,
    this.useLoading = false,
    //required this.userToken,
    this.showSnackBar,
  }) {
    _urlRequest = url ?? '$baseUrl$route&key=${Domain.instance.token}';
    //Map<String, String> authHeader = {'Authorization': 'Bearer ${userToken!}'};
    config = {};
    headers = {
      ...defaultHeader,
      //...authHeader,
    };
    this.timeOut = timeOut ?? timeOutEx;
  }

  String get messageErrorDefault => 'Đã xảy ra lỗi, vui lòng thử lại!';

  Future<QAResponse?> _run(
      {required dynamic dataField, required TypeRequest type}) async {
    try {
      print(_urlRequest);
      http.Response response;
      switch (type) {
        case TypeRequest.get:
          {
            response = await http.get(Uri.parse(_urlRequest), headers: {
              ...headers,
              ...((dataField as _FieldsGet).query ?? {})
            });
            break;
          }
        case TypeRequest.post:
          {
            response = await http.post(Uri.parse(_urlRequest),
                body: (dataField).body,
                headers: {
                  ...headers,
                  ...encodeHeader
                }).timeout(Duration(seconds: timeOut));
            break;
          }
        case TypeRequest.put:
          {
            response = await http.put(Uri.parse(_urlRequest),
                body: (dataField as _FieldsPost).body,
                headers: {
                  ...headers,
                  ...encodeHeader
                }).timeout(Duration(seconds: timeOut));
            break;
          }
        case TypeRequest.delete:
          {
            response = await http.delete(Uri.parse(_urlRequest),
                body: (dataField as _FieldsPost).body,
                headers: {
                  ...headers,
                  ...encodeHeader
                }).timeout(Duration(seconds: timeOut));
            break;
          }
        case TypeRequest.formData:
          {
            var request = http.MultipartRequest('POST', Uri.parse(_urlRequest));
            request.headers.addAll({...headers, ...formHeader});
            request.fields.addAll((dataField as _FieldsFormData).fields ?? {});
            request.files.addAll(dataField.files);
            http.StreamedResponse res =
                await request.send().timeout(Duration(seconds: timeOut));
            response = await http.Response.fromStream(res);
            break;
          }
      }

      final myResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= QAResponse.success &&
          response.statusCode <= 299) {
        return Future.value(QAResponse(
          statusCode: response.statusCode,
          data: myResponse,
        ));
      }
      throw QAException(
        error: QAResponse(
          statusCode: response.statusCode,
          // message: myResponse['message'] ??
          //     QAResponse.checkMessage(response.statusCode),
        ),
      );
    } on TimeoutException catch (_) {
      throw QAException(
        error: QAResponse(
          statusCode: QAResponse.requestTimeout,
          message: 'Time out exception!',
        ),
      );
    } on SocketException {
      throw QAException(
        error: QAResponse(
          statusCode: QAResponse.noInternet,
          message: 'Mất kết nối, vui lòng thử lại!',
        ),
      );
    } on Error catch (_) {
      throw QAException(
        error: QAResponse(
          statusCode: QAResponse.errorServer,
          message: 'Something is wrong here!',
        ),
      );
    }
  }

  Future<QAResponse?> get({Map<String, String>? query}) {
    return _run(dataField: _FieldsGet(query: query), type: TypeRequest.get);
  }

  Future<QAResponse?> post({dynamic body}) {
    return _run(
      dataField: _FieldsPost(body: body),
      type: TypeRequest.post,
    );
  }

  Future<QAResponse?> put({dynamic body}) {
    return _run(
      dataField: _FieldsPost(body: jsonEncode(body)),
      type: TypeRequest.put,
    );
  }

  Future<QAResponse?> delete({dynamic body}) {
    return _run(
      dataField: _FieldsPost(body: jsonEncode(body)),
      type: TypeRequest.delete,
    );
  }

  Future<QAResponse?> postFormData({
    String? url,
    String? subUrl,
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
  }) {
    return _run(
        dataField: _FieldsFormData(files: files, fields: fields),
        type: TypeRequest.formData);
  }
}

enum TypeRequest { get, post, formData, put, delete }

abstract class _Fields {
  dynamic get data;
}

class _FieldsGet extends _Fields {
  final Map<String, String>? query;
  _FieldsGet({required this.query});

  @override
  get data => query;
}

class _FieldsPost extends _Fields {
  final Object? body;
  final Map<String, String>? headers;
  _FieldsPost({this.body, this.headers});

  @override
  get data => body;
}

class _FieldsFormData extends _Fields {
  final List<http.MultipartFile> files;
  final Map<String, String>? fields;

  _FieldsFormData({required this.files, this.fields});

  @override
  get data => {
        'files': files.map((e) => e.filename).toList(),
        'fields': fields,
      };
}
