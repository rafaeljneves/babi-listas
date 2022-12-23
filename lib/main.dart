import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(MyApp());
}

class Tarefa {
  late String nome;
  late bool riscado;

  Tarefa(this.nome, this.riscado);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['riscado'] = this.riscado;
    
    return data;
  }

}

class FileStorage{

  List<int> lista = [1,2];

  Future<String?> get _localPath async {
    final currentDirectory = await getApplicationDocumentsDirectory();
    return currentDirectory.path;
  }
  Future<File> get _localFile async {
    final currentPath = await _localPath;
    return File('$currentPath/ab.bin');
  }
  Future writeFile() async {
    final file = await _localFile;
    await file.writeAsBytes(lista, mode: FileMode.append).whenComplete(() => lista.removeAt(0));
        }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lista de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  TextStyle _strikeout = TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, decorationThickness: 2.0,);
  TextStyle _normal = TextStyle(fontSize: 18);

  List<Tarefa> tarefas = [];

  List _items = []; //para recuperar do Json

  String? nome_da_lista;

 /*@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJson();
    });
  }*/

  _onSelected(int index) {
        setState(() => _selectedIndex = index);
  }

 bool _carregouLista = false;

 final listaTarefasBD = [
    Tarefa("banana", false),
    Tarefa("queijo", false),
    Tarefa("goiabada", false),
    Tarefa("leite", false),
    Tarefa("mate", false)
  ];


/*
var items = [
    "Apple",
    "Cherimoya",
    "Grapefruit",
    "Jostaberry",
    "Plumcot",
    "Pomegranate",
    "Quince",
    "Kiwi",
    "Kiwano",
    "Huckleberry",
    "Marionberry",
    "Mango",
    "Strawberry",
  ];

  items.map((item) => ListItem(item)).toList(),
*/

  List<String> listaTarefas = ['água de coco'];

  bool _value = false;

  List<bool> isStricked = [false];

  String? _dropdownValue;


  String label = "teste";
  final myController = TextEditingController();


  static const TextStyle optionStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
                                                        Text(
                                                          'Index 0: Tarefas',
                                                          style: optionStyle,
                                                        ),
                                                        Text(
                                                          'Index 1: Config',
                                                          style: optionStyle,
                                                        ),
                                                      ];

  void adicionaItem() {
     setState(() {
        label = myController.text;
        listaTarefas.add(label);
        print('listaTarefas: ${listaTarefas}');
        print('TAM listaTarefas: ${listaTarefas.length}');
        isStricked.insert(0, false);
        print('_carregouLista: ${_carregouLista}');
        _carregouLista = !_carregouLista;

        
        myController.clear();
     });
    Navigator.pop(context);
  }

  void adicionaItemBD() {
     setState(() {
        label = myController.text;
        listaTarefasBD.add(Tarefa(label, false));
        print('listaTarefas: ${listaTarefas}');
        print('TAM listaTarefas: ${listaTarefas.length}');
        //isStricked.insert(0, false);
        print('_carregouLista: ${_carregouLista}');
        _carregouLista = !_carregouLista;
        
        myController.clear();
     });
    Navigator.pop(context);
  }


  Future<void> readJson() async {

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      print('tempPath = $tempPath');

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      print('appDocPath = $appDocPath');

      final String response = await rootBundle.loadString('assets/data.json');
      final data = await json.decode(response);
      int len = data[nome_da_lista].length;
      print('length = $len');
      setState(() {
        _items = data[nome_da_lista];
        print('_items: ${_items}');
        for(var i=0;i<len;i++){            
            listaTarefas.add(_items[i]["nome"]);
            isStricked.insert(0, _items[i]["riscado"]);
            print(listaTarefas[i]);
        }
      });
  }


  Map<String,dynamic> a = {'a' : 'b', 'c' : {'d' : 'e'}};

    Future<void> _go () async  {

    //String dir = (await getTemporaryDirectory()).path; 
    //print('directory.path = ${dir}');
    
    //final File file = File('${dir}/a.json');
    //file.writeAsStringSync(json.encode(a));
    //Map<String, dynamic> myJson = await json.decode(await file.readAsString());
    //print(myJson.toString());

    final File file = File('assets/teste.json');
    print('file: $file');
    //String contents = await file.readAsString();
    //await carregaTarefas(file);

/*
    Tarefa novaTarefa = Tarefa('Teste NOVO',false);
    tarefas.add(novaTarefa);

    print("tarefas.length: ${tarefas.length}");

    tarefas  //convert list data  to json 
        .map(
          (tarefa) => tarefa.toJson(),
        )
        .toList();
         
      file.writeAsStringSync(json.encode(tarefas));
*/
    }


    Future<void> carregaTarefas (File file) async {   
    
        String contents = await file.readAsString();
        var jsonResponse = jsonDecode(contents);
        
        for(var p in jsonResponse){
            
            Tarefa tarefa = Tarefa(p['nome'],p['riscado']);
            tarefas.add(tarefa);
        }    
      
    }


  Widget carregaItens(BuildContext context){
  return Container(
      width: 300,//TAM_CARD_WIDTH,
      height:300,// TAM_CARD_HEIGHT,
      child: ListView.builder(
          itemCount: listaTarefas.length, 
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {                           
                         setState(() {
                           //listaTarefasBD[index].riscado = !listaTarefasBD[index].riscado;
                           bool temp = !isStricked[index];
                           isStricked.removeAt(index);
                           isStricked.insert(index, temp);
                         }); 
                        },
                title: Text(listaTarefas[index],    
                            style: isStricked[index] ? _strikeout : _normal,
                           ),   
              ),
            );
          }),
    );

   setState(() { 
         _carregouLista = true;
         print('_carregouLista: ${_carregouLista}');
         });   
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: tarefa(context)

        /* Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Itens:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Inclui item',
        child: Icon(Icons.add),
      ),
     */
    );
  }

  Widget tarefa(BuildContext context){
    return Container(
             child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Itens:',
            ),
            _carregouLista ? listaItens(context) : carregaItens(context) ,
            espacos(),
            Row(
             mainAxisAlignment: MainAxisAlignment.center ,
             children: <Widget>[
                SizedBox(width: 50),
                FloatingActionButton(
                    onPressed:  () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                            width: double.infinity,
                            height: 200.0,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Abrir arquivo - Selecione uma lista: ",
                                    //style: optionStyle,
                                    style: GoogleFonts.lato(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.grey[750],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: _dropdownValue,
                                    isExpanded: true,
                                    items: <String>[
                                      'compras',
                                      'presentes'

                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? selectedvalue) {
                                      _dropdownValue = selectedvalue!;
                                      this.setState(() {
                                        _dropdownValue = selectedvalue;
                                      });
                                      print(_dropdownValue);
                                      nome_da_lista = _dropdownValue;
                                      readJson();
                                      Navigator.pop(context);
                                     
                                    },
                                  ),
                                ],
                              ),
                            )),
                      );
                    });
              },




                    tooltip: 'Abrir lista',
                    child: Icon(Icons.folder_open),
                ), 
                Spacer(),
                FloatingActionButton(
                    onPressed:  () {                                
                                   final result = _showTextInputDialog(context);
                                   print('abriu tela de dialogo');
                                 },
                    tooltip: 'Inclui item',
                    child: Icon(Icons.add),
                ), 
                Spacer(),
                FloatingActionButton(
                    onPressed:  () => _go(),  

                    tooltip: 'Salvar lista',
                    child: Icon(Icons.save_alt),
                ), 
                SizedBox(width: 50),
            ],
           ), //Row
          ], 
        ),
      ),
    );

  
 }


    Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item'),
            content: TextField(
                    onChanged: (text) {
                                    //print('texto: $text');
                                  },
                    controller: myController,
                    autofocus: true,
                    onSubmitted: (_)=> adicionaItem(),
                    decoration: const InputDecoration(hintText: "nome do item" ),
                    ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Adicionar'),
                onPressed: () => adicionaItem(),  
              ),
            ],
          );
        });
  }


  Widget listaItens(BuildContext context){
    return Container(
      width: 300,//TAM_CARD_WIDTH,
      height:500,// TAM_CARD_HEIGHT,
      child: ListView.builder(
          itemCount: listaTarefas.length, //listaTarefasBD.length
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {                           
                         setState(() {
                           //listaTarefasBD[index].riscado = !listaTarefasBD[index].riscado;
                           bool temp = !isStricked[index];
                           isStricked.removeAt(index);
                           isStricked.insert(index, temp);
                         }); 
                        },
                title: Text(listaTarefas[index],    // listaTarefasBD[index].nome,   
                            style: isStricked[index] ? _strikeout : _normal,  //listaTarefasBD[index].riscado ? _strikeout : _normal,
                           ),   
              ),
            );
          }),
    );
  }


    Widget espacos(){
    return Padding(
      padding: EdgeInsets.all(64.0),   //64.0
      child: Row(
        children: [
          /*Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          */
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

}

