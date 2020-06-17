import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// void main() => runApp(ChartsDemo());
// void main(){
//   runApp(
//     MaterialApp(
//       home: ChartsDemo(),
//     ),
//   );
// }

// class ChartsDemo extends StatefulWidget{

//   ChartsDemo() : super();

//   final String title = "Charts Demo";

//   @override
//   ChartsDemoState createState() => ChartsDemoState();
// }

// class ChartsDemoState extends State<ChartsDemo>{

//   List<charts.Series> seriesList;

//   static List<charts.Series<Sales, String>> _createRandomData(){
//     final random = Random();
//     final desktopSalesData = [
//       Sales('2015' , random.nextInt(100)),
//       Sales('2016' , random.nextInt(100)),
//       Sales('2017' , random.nextInt(100)),
//       Sales('2018' , random.nextInt(100)),
//       Sales('2019' , random.nextInt(100)), 
//     ];

//     final tabletSalesData = [
//       Sales('2015' , random.nextInt(100)),
//       Sales('2016' , random.nextInt(100)),
//       Sales('2017' , random.nextInt(100)),
//       Sales('2018' , random.nextInt(100)),
//       Sales('2019' , random.nextInt(100)), 
//     ];

//     final mobileSalesData = [
//       Sales('2015' , random.nextInt(100)),
//       Sales('2016' , random.nextInt(100)),
//       Sales('2017' , random.nextInt(100)),
//       Sales('2018' , random.nextInt(100)),
//       Sales('2019' , random.nextInt(100)), 
//     ];

//     return [
//       charts.Series<Sales, String>(
//         id: 'Sales',
//         domainFn: (Sales sales, _) => sales.year,
//         measureFn: (Sales sales, _) => sales.sales,
//         data: desktopSalesData,
//         fillColorFn: (Sales sales, _){
//           return (sales.year == '2016')
//           ? charts.MaterialPalette.red.shadeDefault
//           : charts.MaterialPalette.blue.shadeDefault;
//         }
//       ),
//       charts.Series<Sales, String>(
//         id: 'Sales',
//         domainFn: (Sales sales, _) => sales.year,
//         measureFn: (Sales sales, _) => sales.sales,
//         data: tabletSalesData,
//         fillColorFn: (Sales sales, _){
//           return (sales.year == '2016')
//           ? charts.MaterialPalette.green.shadeDefault
//           : charts.MaterialPalette.blue.shadeDefault;
//         }
//       ),
//       charts.Series<Sales, String>(
//         id: 'Sales',
//         domainFn: (Sales sales, _) => sales.year,
//         measureFn: (Sales sales, _) => sales.sales,
//         data: mobileSalesData,
//         fillColorFn: (Sales sales, _){
//           return (sales.year == '2016')
//           ? charts.MaterialPalette.yellow.shadeDefault
//           : charts.MaterialPalette.blue.shadeDefault;
//         }
//       ),
//     ];
//   }

//   barChart(){
//     return charts.BarChart(
//       seriesList,
//       animate: true,
//       vertical: false,
//       barGroupingType: charts.BarGroupingType.stacked,
//       defaultRenderer: charts.BarRendererConfig(
//         groupingType: charts.BarGroupingType.stacked,
//         strokeWidthPx: 10.0,
//       ),
//       domainAxis: charts.OrdinalAxisSpec(
//         renderSpec: charts.NoneRenderSpec(),
//       ),
//     );
//   }
  

//   @override
//   void initState(){
//     super.initState();
//     seriesList = _createRandomData();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20.0),
//         child: barChart(),
//       ),
//     );
//   }
// }

// class Sales{
//   final String year;
//   final int sales;

//   Sales(this.year, this.sales);


// }

// ====================================

void main(){
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}


Future<Overview> getOverview() async{
  final response = await http.get(
    'http://expenses.koda.ws/api/v1/records/overview',
    headers: {
      HttpHeaders.authorizationHeader: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNX0.DOueXZ9-xQcdSz294L21oe4ZLOkOty9Au_FxniFMD64',
      // HttpHeaders.authorizationHeader: hash,
    },
  );

  print('The status is ${response.statusCode}');
  return postFromJsonOverView(response.body);
}

Overview postFromJsonOverView(String str){
  print('The string is $str');
  final jsonData = json.decode(str);
  print('The jsonData is $jsonData');
  var value = Overview.fromJson(jsonData);
  print('The value is $value');
  return value;
}

class Overview{
  final double income;
  final double expenses;

  Overview({this.income , this.expenses});

  factory Overview.fromJson(Map<String , dynamic> parsedJson){
    return Overview(
      income: parsedJson['income'],
      expenses: parsedJson['expenses'],
    );
  }
}

class MyApp extends StatefulWidget{

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:FutureBuilder<Overview>(
        future: getOverview(),
        builder: (context , snapshot){
          if(snapshot.hasData){

            return Charts(income: snapshot.data.income , expenses: snapshot.data.expenses,);
          }else if(snapshot.hasError){
            return Center(child: Text("Error"));
          }
          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}

class OverviewData{
  final String category;
  final double amount;

  OverviewData(this.category , this.amount);
}



class Charts extends StatefulWidget{

  final double income;
  final double expenses;

  Charts({this.income , this.expenses});

  @override
  _Charts createState() => _Charts(income: income , expenses: expenses);
}

class _Charts extends State<Charts>{

  final double income;
  final double expenses;

  _Charts({this.income , this.expenses});

  List<charts.Series> seriesList;

    @override
    void initState(){
      super.initState();
      seriesList = _createOverviewData();
    }

    barChart(){
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,

    );
  }

    List<charts.Series<OverviewData, String>> _createOverviewData(){
    final overviewData = [
      OverviewData('Income' , income),
      OverviewData('Expenses' , expenses),
    ];

    return [
      charts.Series<OverviewData, String>(
        id: 'Overview',
        domainFn: (OverviewData overview, _) => overview.category,
        measureFn: (OverviewData overview, _) => overview.amount,
        data: overviewData,
        fillColorFn: (OverviewData overview, _){
          return (overview.category == 'Income')
          ? charts.MaterialPalette.green.shadeDefault
          : charts.MaterialPalette.red.shadeDefault;
        }
      ),
    ];
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: barChart(),
      ),
    );
  }
}