import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hgkcb/model/course.dart';

/*
  数据库工具类
  written by liuwenkiii on 2019/09/10
 */
class DatabaseUtil {
  static final DatabaseUtil _instance = DatabaseUtil.internal();
  factory DatabaseUtil() => _instance;
  static Database _db;
  static final int version = 1;

  final String tableName = "course_data";
  final String id = "id";

  DatabaseUtil.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    var ourDb = await openDatabase(
        path,
        version: version,
        onCreate: _onCreate
    );
    return ourDb;
  }

  //创建课程表数据表
  _createCourseTable(Database db) async {
    final String name = "name";
    final String tName = "tName";
    final String place = "place";
    final String start = "start";
    final String end = "end";
    final String weekday = "weekday";
    final String week = "week";
    final String flag = "flag";
    await db.execute(
        "create table $tableName("
            "$id integer primary key,"
            "$name text not null,"
            "$tName text not null,"
            "$place text not null,"
            "$start integer not null,"
            "$end integer not null,"
            "$weekday integer not null,"
            "$week text not null,"
            "$flag integer not null )");
    print("Table: $tableName is created");
  }

  //创建数据表
  void _onCreate(Database db, int version) async {
    _createCourseTable(db);
  }

  //查询
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ");
    return result.toList();
  }

  //插入
  Future<int> insertCourseItem(Course course) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableName, course.toMap());
    print(res.toString());
    return res;
  }

  //根据id删除
  Future<int> deleteCourseItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$id = ?", whereArgs: [id]);
  }

  //删除所有课表数据
  Future<int> deleteAllCourse() async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$id > 0");
  }

  //根据id修改
  Future<int> updateCourseItem(Course course, int courseId) async {
    var dbClient = await db;
    return await dbClient.update(tableName, course.toMap(),
        where: "$id = ?", whereArgs: [courseId]);
  }

  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}