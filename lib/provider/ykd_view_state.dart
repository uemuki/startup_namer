/// 页面状态类型
enum YKDViewState {
  idle,
  busy, //加载中
  empty, //无数据
  error, //加载失败
}

/// 错误类型
enum YKDViewStateErrorType {
  defaultError,
  networkTimeOutError, //网络错误
  unauthorizedError //为授权(一般为未登录)
}

class YKDViewStateError {
  YKDViewStateErrorType _errorType;
  String message;
  String errorMessage;

  YKDViewStateError(this._errorType, {this.message, this.errorMessage}) {
    _errorType ??= YKDViewStateErrorType.defaultError;
    message ??= errorMessage;
  }

  YKDViewStateErrorType get errorType => _errorType;

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨
  get isDefaultError => _errorType == YKDViewStateErrorType.defaultError;
  get isNetworkTimeOut =>
      _errorType == YKDViewStateErrorType.networkTimeOutError;
  get isUnauthorized => _errorType == YKDViewStateErrorType.unauthorizedError;

  @override
  String toString() {
    return 'YKDViewStateError{errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }
}
