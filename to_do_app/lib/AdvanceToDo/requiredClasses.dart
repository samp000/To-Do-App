class SingleModalUserData {
  int? id;
  String name;
  String mobileNo;
  String password;

  SingleModalUserData(
      {this.id,
      required this.name,
      required this.mobileNo,
      required this.password});

  Map<String, String> getUserMap() {
    return {
      "name": name,
      "mobileNo": mobileNo,
      "password": password,
    };
  }
}

class SingleModalClass {
  int? id;
  String title;
  String description;
  String date;
  int? completed;

  SingleModalClass(
      {required this.title,
      required this.description,
      required this.date,
      this.id,
      this.completed});

  Map<String, dynamic> dataMap() {
    return {
      "id": id,
      "title": title,
      "desc": description,
      "date": date,
      "completed": completed
    };
  }

  @override
  String toString() {
    return "id:$id title:$title desc:$description date:$date";
  }
}

class ToDoInfo {
  String pending;
  String completed;

  ToDoInfo({required this.pending, required this.completed});
}
