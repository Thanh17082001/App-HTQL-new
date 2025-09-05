import 'package:app_flutter/model/plan/working_content_model.dart';
import 'package:flutter/material.dart';

class WorkingContentManager with ChangeNotifier {
  final List<WorkingContentModel> _items = [];

  List<WorkingContentModel> get works {
    return _items;
  }

  bool addWorkingContent(WorkingContentModel work) {
    _items.add(work);
    notifyListeners();
    return true;
  }

  deleteAt(item) {
    _items.remove(item);
    notifyListeners();
  }
}
