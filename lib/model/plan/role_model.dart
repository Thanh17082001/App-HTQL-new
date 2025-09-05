class RoleModel {
  // tài khoản thuộc ban này sẽ được chọn (1) để duyệt bước 1
  final List<String> roles = [
    "Ban thị trường - Giám đốc kinh doanh",
    "Ban thị trường - Giám đốc dự án",
    "Ban thị trường - Trưởng ban",
    "Ban thị trường - Nhân viên kinh doanh",
    "Ban thị trường - Giám đốc chi nhánh",
    "Ban thị trường - Phó ban",
    "Ban sản phẩm - Phó ban",
    "Ban sản phẩm - Trưởng ban",
  ];

  // tài khoản thuộc ban tài chính kế toán duyệt bước 2
  final List<String> rolesAccountant = [
    "Ban tài chính, kế hoạch - Trưởng ban",
    "Ban tài chính, kế hoạch - Phó ban"
  ];

  // tài khoản thuộc ban hành chánh duyệt bước 3
  final List<String> rolesAdministrative = [
    "Ban pháp chế, hành chính, nhân sự - Trưởng ban",
    "Ban pháp chế, hành chính, nhân sự - Phó ban"
  ];

}
