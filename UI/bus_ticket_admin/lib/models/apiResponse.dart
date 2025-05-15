class ApiResponse<T> {
  List<T> items;
  int totalCount;

  ApiResponse({required this.items, required this.totalCount});
}