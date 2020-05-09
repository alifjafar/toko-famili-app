class Meta {
  Pagination pagination;
  int httpStatus;

  Meta(this.pagination, this.httpStatus);

  Meta.fromJson(Map<String, dynamic> json)
    : pagination = json.containsKey("pagination") ? Pagination.fromJson(json['pagination']) : null,
      httpStatus = json['http_status'];
}

class Pagination {
  int currentPage;
  String firstPageUrl;
  int from;
  int lastPage;
  String perPage;
  int to;
  int total;

  Pagination({
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
  });

  Pagination.fromJson(Map<String, dynamic> json)
    : currentPage = json['current_page'],
      firstPageUrl = json['first_page_url'],
      from = json['from'],
      lastPage = json['last_page'],
      perPage = json['per_page'].toString(),
      to = json['to'],
      total = json['total'];
}