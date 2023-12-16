import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:meta/meta.dart';
import 'package:noname_demo/src/core/components/rest_client/rest_client.dart';

/// {@macro rest_client}
@immutable
abstract base class RestClientBase implements RestClient {
  /// {@macro rest_client}
  const RestClientBase();
  static final _jsonUTF8 = json.fuse(utf8);

  /// Encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, Object?> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(message: 'Error occured during encoding $e'),
        stackTrace,
      );
    }
  }

  /// Decodes [body] from JSON \ UTF8
  @protected
  @visibleForTesting
  FutureOr<Map<String, Object?>?> decodeResponse(
    Object? body, {
    int? statusCode,
  }) async {
    if (body == null) return null;
    try {
      Map<String, Object?> result;
      if (body is String) {
        if (body.length > 1000) {
          result = await Isolate.run(
            () => json.decode(body) as Map<String, Object?>,
          );
        } else {
          result = json.decode(body) as Map<String, Object?>;
        }
      } else if (body is Map<String, Object?>) {
        result = body;
      } else if (body is List<int>) {
        if (body.length > 10000) {
          result = await Isolate.run(
            () => json.decode(utf8.decode(body)) as Map<String, Object?>,
          );
        } else {
          result = json.decode(utf8.decode(body)) as Map<String, Object?>;
        }
      } else {
        throw WrongResponseTypeException(
          message: 'Unexpected response body type: ${body.runtimeType}',
          statusCode: statusCode,
        );
      }

      return result;
    } on ClientException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(message: 'Error occured during decoding $e'),
        stackTrace,
      );
    }
  }
}
