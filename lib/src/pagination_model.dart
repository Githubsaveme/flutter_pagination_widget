class PaginationModel{
  final int from;
  final int to;
  final int total;
  final int currentPage;
  final int lastPage;

  const PaginationModel({
    required this.from,
    required this.to,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
}
