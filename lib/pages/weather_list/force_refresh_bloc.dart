import 'dart:async';

import 'package:objectdb/objectdb.dart';

class ForceRefreshBloc {
  final ObjectDB cacheData;

  final StreamController<bool> _refreshController = StreamController();

  ForceRefreshBloc(this.cacheData) {
    refresh = _refreshController.stream
        .asyncMap((event) => cacheData.remove({}).then((value) => cacheData.tidy()))
        .map((_) => true)
        .asBroadcastStream();
  }

  Stream<bool> refresh;

  void forceRefresh() {
    _refreshController.add(true);
  }

  void dispose() {
    _refreshController.close();
  }
}
