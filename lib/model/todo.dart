// model/todo.dart
import 'package:hive/hive.dart';
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  late String title;

  Todo(this.title);
}
