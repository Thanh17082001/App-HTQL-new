import 'package:app_flutter/model/category_model.dart';
import 'package:flutter/material.dart';

import '../../../service/category/category_service.dart';

class CategoryManager with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _items = [];

  List<CategoryModel> get categories {
    return [..._items];
  }

  

  int get itemCount {
    return _items.length;
  }

  Future getAll() async {
    _items = await _categoryService.getAll();
    notifyListeners();
  }

  
}
