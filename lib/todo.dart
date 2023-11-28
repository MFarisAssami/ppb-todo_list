class Todo {
  int? id;
  String nama;
  String deskripsi;
  bool done;

  Todo(this.deskripsi, this.nama, {this.done = false, this.id});

  static List<Todo> dummyData = [
    Todo("latihan memasak", "latihan lomba masak"),
    Todo("makan di resto", "makan malam"),
    Todo("berenang", "menyelam"),
  ];

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id' : id,
      'nama' : nama,
      'deskripsi' : deskripsi,
      'done' : done
    };
  }

  factory Todo.fromMap(Map<String,dynamic> map){
    return Todo(
      id: map['id'],
      map['nama'] as String,
      map['deskripsi'] as String,
      done: map['done'] == 0 ? false : true
    );
  }
}