import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

abstract class INetworkManager<T> {
  INetworkManager<T> addBaseUrl(String baseUrl);
  INetworkManager<T> addStatusModels(StatusModels? _statusModels);
  INetworkManager<T> addBaseHeader(MapEntry<String, String> value);
  INetworkManager<T> addTimeout(int value);
  INetworkManager<T> addLoggerRequest();

  T build();
}

class StatusModels {
  final int maximumValue;
  final int minumumValue;

  StatusModels({required this.maximumValue, required this.minumumValue}) : assert(maximumValue > minumumValue);
}

class NetworkDioManager implements INetworkManager<Dio> {
  Dio? _dio;
  String? _baseUrl;
  StatusModels? _statusModels;
  MapEntry<String, String>? _baseHeader;
  int? _timeOut;
  InterceptorsWrapper? _wrapper;

  @override
  INetworkManager<Dio> addBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  @override
  INetworkManager<Dio> addTimeout(int value) {
    _timeOut = value;
    return this;
  }

  @override
  INetworkManager<Dio> addStatusModels(StatusModels? statusModels) {
    _statusModels = statusModels;
    return this;
  }

  @override
  INetworkManager<Dio> addBaseHeader(MapEntry<String, String> value) {
    _baseHeader = value;
    return this;
  }

  @override
  INetworkManager<Dio> addLoggerRequest() {
    _wrapper = InterceptorsWrapper(
      onRequest: (options, handler) {
        Logger().i(options);
        handler.next(options);
      },
    );
    return this;
  }

  @override
  Dio build() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl ?? '',
      headers: Map.fromEntries([_baseHeader ?? const MapEntry('token', 'value')]),
      connectTimeout: _timeOut,
      validateStatus: (status) {
        if (status != null && _statusModels != null) {
          if (status >= _statusModels!.minumumValue && status < _statusModels!.maximumValue) {
            return true;
          }
        }

        return false;
      },
    ));

    if (_wrapper != null) {
      _dio?.interceptors.add(_wrapper!);
    }

    return _dio!;
  }
}
