import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:startup_namer/api/api.dart';
import 'package:startup_namer/provider/ykd_view_state.dart';
import 'package:dio/dio.dart';

class YKDViewModel extends ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  /// 当前的页面状态,默认为busy,可在viewModel的构造方法中指定;
  YKDViewState _viewState;

  /// 根据状态构造
  ///
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  YKDViewModel({YKDViewState viewState})
      : _viewState = viewState ?? YKDViewState.idle {
    debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  /// ViewState
  YKDViewState get viewState => _viewState;

  set viewState(YKDViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    notifyListeners();
  }

  /// ViewStateError
  YKDViewStateError _viewStateError;

  YKDViewStateError get viewStateError => _viewStateError;

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨
  ///
  /// get
  bool get isBusy => viewState == YKDViewState.busy;

  bool get isIdle => viewState == YKDViewState.idle;

  bool get isEmpty => viewState == YKDViewState.empty;

  bool get isError => viewState == YKDViewState.error;

  /// set
  void setIdle() {
    viewState = YKDViewState.idle;
  }

  void setBusy() {
    viewState = YKDViewState.busy;
  }

  void setEmpty() {
    viewState = YKDViewState.empty;
  }

  /// [e]分类Error和Exception两种
  void setError(e, stackTrace, {String message}) {
    YKDViewStateErrorType errorType = YKDViewStateErrorType.defaultError;

    /// 见https://github.com/flutterchina/dio/blob/master/README-ZH.md#dioerrortype
    if (e is DioError) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        // timeout
        errorType = YKDViewStateErrorType.networkTimeOutError;
        message = e.error;
      } else if (e.type == DioErrorType.RESPONSE) {
        // incorrect status, such as 404, 503...
        message = e.error;
      } else if (e.type == DioErrorType.CANCEL) {
        // to be continue...
        message = e.error;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          stackTrace = null;
          errorType = YKDViewStateErrorType.unauthorizedError;
        } else if (e is NotSuccessException) {
          stackTrace = null;
          message = e.message;
        } else if (e is SocketException) {
          errorType = YKDViewStateErrorType.networkTimeOutError;
          message = e.message;
        } else {
          message = e.message;
        }
      }
    }
    viewState = YKDViewState.error;
    _viewStateError = YKDViewStateError(
      errorType,
      message: message,
      errorMessage: e.toString(),
    );
    printErrorStack(e, stackTrace);
    onError(viewStateError);
  }

  void onError(YKDViewStateError viewStateError) {}

  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (viewStateError != null || message != null) {
      Future.microtask(() {
        showToast(message, context: context);
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }
}

/// [e]为错误类型 :可能为 Error , Exception ,String
/// [s]为堆栈信息
printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
