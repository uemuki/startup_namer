import 'package:dio/dio.dart';
import '../model/result.dart';

import 'api.dart';

class YKDAPIManager {
  static YKDAPIManager _instance = YKDAPIManager._internal();

  APIManager _manager;
  factory YKDAPIManager() => _instance;

  YKDAPIManager._internal() {
    _manager = APIManager();
  }

  /// QUERY
  ///
  /// 通用查询
  query(Map<String, dynamic> params, String returnClassName,
      String paramClassName) {
    return _manager.post(
        '/api/commonquery/query?returnClassName=$returnClassName&paramClassName=$paramClassName',
        params: params);
  }

  /// 通用分页查询
  queryForPage(Map<String, dynamic> params, String returnClassName,
      String paramClassName,
      {int pageNum = 0, int pageSize = 15}) {
    return _manager.post(
        '/api/commonquery/queryForPage?returnClassName=$returnClassName&paramClassName=$paramClassName&pageSize=$pageSize&pageNum=$pageNum',
        params: params);
  }

  /// 根据id查询
  findById(Map<String, dynamic> params, String returnClassName,
      String paramClassName, String id) {
    return _manager.post(
        '/api/commonquery/findById?returnClassName=$returnClassName&paramClassName=$paramClassName&id=$id',
        params: params);
  }

  /// 查询一个
  findOne(Map<String, dynamic> params, String returnClassName,
      String paramClassName, String id,
      {String collectionName}) {
    String clName = "";
    if (collectionName.isNotEmpty) {
      clName = "&collectionName=" + collectionName;
    }
    return _manager.post(
        '/api/commonquery/findOne?returnClassName=$returnClassName&paramClassName=$paramClassName$clName',
        params: params);
  }

  /// 根据ids查询
  findByIds(Map<String, dynamic> params, String returnClassName,
      String paramClassName, List<String> ids) {
    return _manager.post(
        '/api/commonquery/findByIds?returnClassName=$returnClassName&paramClassName=$paramClassName&ids=$ids',
        params: params);
  }

  /// MUTATION
  ///
  /// 通用保存，根据指定的参数，后端类路径完成数据存储
  save(dynamic data, String modelClassName, {String collectionName}) {
    String clName = "";
    if (collectionName.isNotEmpty) {
      clName = "&collectionName=" + collectionName;
    }
    return _manager.post(
        '/api/commonmutation/save?modelClassName=$modelClassName$clName',
        data: data);
  }

  /// 通用批量保存，根据指定的参数，后端类路径完成数据存储
  batchSave(List<dynamic> models, String modelClassName,
      {String collectionName}) {
    String clName = "";
    if (collectionName.isNotEmpty) {
      clName = "&collectionName=" + collectionName;
    }
    return _manager.post(
        '/api/commonmutation/batchSave?modelClassName=$modelClassName$clName',
        data: models);
  }

  /// 通用的删除，自动将isDelete置位空
  del(String id, String modelClassName) {
    return _manager
        .post('/api/commonmutation/del?modelClassName=$modelClassName&id=$id');
  }

  /// 通用的删除
  delAny(
      Map<String, dynamic> params, String modelClassName, String paramClassName,
      {String collectionName}) {
    String clName = "";
    if (collectionName.isNotEmpty) {
      clName = "&collectionName=" + collectionName;
    }
    return _manager.post(
        '/api/commonmutation/delAny?paramClassName=$paramClassName&modelClassName=$modelClassName$clName');
  }
}
