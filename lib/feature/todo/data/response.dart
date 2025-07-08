 
import 'package:desktopme/core/enums/view_state.dart';

class ApiResponse<T> {
  final StatusApp? status;
  final T? data;
  final String? message;

  const ApiResponse._({required this.status, this.data, this.message});

     ApiResponse.loading() : this._(status: StatusApp.Loading);

    ApiResponse.completed(T data) : this._(status: StatusApp.Completed, data: data);

     ApiResponse.error(String message) : this._(status: StatusApp.Error, message: message);

  @override
  String toString() {
    return "Status: $status\nMessage: $message\nData: $data";
  }
}
