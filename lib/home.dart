import 'package:flutter/material.dart';
import 'package:minhasanotacoes/helper/Anota%C3%A7%C3%A3oHelper.dart';
import 'package:minhasanotacoes/model/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro(){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título"
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição"
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child:Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){
                    _salvarAnotacao();
                    Navigator.pop(context);
                  },
                  child:Text("Salvar")
              ),
            ],
          );
        }
    );

  }

  _recuperarAnotacao() async {

    List anotacoesRecuperadas = await _db.recuperarAnotacao();

    List<Anotacao> ListTemp = List<Anotacao>();
    for(var item in anotacoesRecuperadas){

      Anotacao anotacao = Anotacao.fromMap(item);
      ListTemp.add(anotacao);

    }

    setState(() {
      _anotacoes = ListTemp;
    });
    ListTemp = null;

    print("Lista: " + anotacoesRecuperadas.toString());

  }

  _salvarAnotacao() async {

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    //print("data atual:" + DateTime.now().toString());
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    print("save: " + resultado.toString());

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacao();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount:  _anotacoes.length,
                  itemBuilder: (context, index){

                    final item = _anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text(item.titulo),
                        subtitle: Text("${item.data} - ${item.descricao}"),
                      ),
                    );
                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
          onPressed: (){
            _exibirTelaCadastro();
          }
      ),
    );
  }
}
