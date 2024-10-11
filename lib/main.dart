import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharma',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pharma'),
    );
    // This is the theme of your application.
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<List<dynamic>> filtre = [];
  final TextEditingController controller = TextEditingController();
  List<List<dynamic>> suggestions =[];
  List<List<dynamic>> trouve =[];


  @override
  void initState() {
    lireCSV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: (value) {
                trouve=[];
                filtresuggestions(value); // Filtrer les suggestions en fonction de l'entrée utilisateur
              },
              decoration: InputDecoration(
                labelText: 'Entrez le nom d\' une molécule',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: filtre.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filtre[index][2]),
                    onTap: () {
                      controller.text = filtre[index][2];

                      trouve_medoc(filtre[index][0]);
                      filtresuggestions(''); // Vider les suggestions après sélection

                    },
                  );
                },
              ),
            ),
            Visibility(

              visible: trouve.isNotEmpty,
              child: Expanded(
                flex:3,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trouve.length,
                  itemBuilder: (context, index) {
                    return Material(child:ListTile(
                      title: Text("${trouve[index][1]}: ${trouve[index][2]}"),
                      tileColor: trouve[index][1]=='G'?Colors.blue[200]:Colors.red[200],
                    )
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> lireCSV() async {
    final String contenu = await rootBundle.loadString('assets/tableau1.csv').catchError((error, stackTrace) => (error).toString());

    List<List<dynamic>> donnees = const CsvToListConverter(fieldDelimiter: ';').convert(contenu);
    print(donnees[0]);
    suggestions = donnees;
  }

  void trouve_medoc(int num ){
    trouve = suggestions.where((element) => element[0] ==num).toList();
    setState(() {
      trouve;
    });
  }

  void filtresuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        filtre = [];
      });
    } else {
      setState(() {
        filtre = suggestions
            .where((suggestion) {

          return suggestion[2].toLowerCase().contains(query.toLowerCase());
        })
            .toList();
      });
    }
  }

}
