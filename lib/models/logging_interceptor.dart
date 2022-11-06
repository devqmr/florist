import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("############## Start RequestData ##############");
    print(data.toString());
    print("############## End RequestData ##############");

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("############## Start ResponseData ##############");
    print(data.toString());
    print("############## End ResponseData ##############");

    return data;
  }

}