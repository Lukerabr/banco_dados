import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async{

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );

    //print("Aberto: " + bd.isOpen.toString());

    return bd;

  }

  _salvar() async{

    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "Teste Nome Duplicação",
      "idade" : 35
    };
    int id = await db.insert("usuarios", dadosUsuario);
    print("salvo: $id");

  }

  _listarUsuarios() async{

    Database db = await _recuperarBancoDados();
    //String sql = "SELECT * FROM usuarios WHERE idade = 28";
    String sql = "SELECT * FROM usuarios WHERE idade = 40 OR idade = 28";
    List usuarios = await db.rawQuery(sql);

    for(var usuario in usuarios){
      print(
        "item id: " + usuario["id"].toString() +
        " nome: " + usuario["nome"] +
        " idade " + usuario["idade"].toString()
      );
    }

    //print("Usuários: " + usuarios.toString());

  }

  @override
  Widget build(BuildContext context) {

    //_salvar();
    _listarUsuarios();

    return Container();
  }
}

