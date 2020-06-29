import 'dart:convert';
import 'dart:io';
import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Extras/sizes.dart';
import 'package:expenses_tracker/Main/modify_record.dart';
import 'package:flutter/material.dart';
import 'list_records.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';


class Dashboard extends StatefulWidget{
  final String hash;

  Dashboard({this.hash});

  @override
  _Dashboard createState() => _Dashboard(hash: hash);
}

class _Dashboard extends State<Dashboard>{

  final String hash;

  _Dashboard({this.hash});

  List<String> _icons = [];
  double income;
  double expenses;

  @override
  void dispose(){
    super.dispose();
  }

  Future getList() async{
    final response = await http.get('http://expenses.koda.ws/api/v1/categories');

    _categoryName(Map<String, dynamic> parsedJson){
        _icons.add(parsedJson['icon']);
    }

    _category(Map<String, dynamic> parsedJson){
      var list = parsedJson['categories'] as List;
      list.map((e) => _categoryName(e)).toList();
      
    }

    if(response.statusCode == 200){
      _category(json.decode(response.body));
      return _icons;
    }else{
      throw Exception('Failed to get the icons');
    }

  }

  Future<String> getOverview(String hash) async{
    final response = await http.get(
      'http://expenses.koda.ws/api/v1/records/overview',
      headers: {
        HttpHeaders.authorizationHeader: hash,
      },
    );

    parseGetOverview(Map<String, dynamic> parsedJson){
      income = parsedJson['income'];
      expenses = parsedJson['expenses'];
    }

    if(response.statusCode == 200){
      parseGetOverview(json.decode(response.body));
      return 'Success';
    }else{
      throw Exception('Failed to create account');
    }
  }

  @override
  Widget build(BuildContext context){ 
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
      home: Scaffold(
        backgroundColor: Color(0xffeeeeee),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Color(0xff246c55),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Container(
            color: Color(0xff246c55),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: IconLink(text: "HOME" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Dashboard(hash: hash,)),
                      ),
                      Expanded(
                        child: IconLink(text: "RECORDS" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: ListRecords(hash: hash,)),
                      ),
                      Expanded(
                        child: IconLink(text: "LOGOUT" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Onboarding()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: true, hash: hash)));
          },
          backgroundColor: Color(0xff246c55),
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: getList(),
          builder: (context , listIcons){
            if(listIcons.hasData){
              return FutureBuilder<RecordsCategory>(
                future: getRecords(hash),
                builder: (context , listRecords){
                  if(listRecords.hasData){
                    if(listRecords.data.pagination.count != 0){       
                      return Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  width: displayWidth(context) * .90,
                                  child: FutureBuilder<String>(
                                    future: getOverview(hash),
                                    builder: (context , listOverview){
                                      if(listOverview.hasData){
                                        return ChartsOverview(income: income, expenses: expenses);
                                      }else if(listOverview.hasError){
                                        return Center(child: Text("Error"));
                                      }
                                      return Container();
                                    },
                                  )
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Card(
                                child: Container(
                                  width: displayWidth(context) * .90,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 40.0),
                                          alignment: Alignment.centerLeft,
                                          child: Text('RECENT',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          width: displayWidth(context) * .90,
                                          child: ListView.separated(
                                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: listRecords.data.pagination.count >= 5 ? 5 : listRecords.data.pagination.count,
                                            itemBuilder: (BuildContext context , int index){

                                              String converted = listRecords.data.records[index].date;
                                              DateTime date = DateTime.parse(converted.substring(0, 10));
                                              String dateWithT = formatDate(date, [MM , ' ' , dd , ', ' , yyyy]).toString();

                                              var currencyConverter = NumberFormat.currency(locale: 'fil', symbol: '\u20b1');

                                              String icon = listIcons.data[listRecords.data.records[index].category.id - 1];

                                              return ListTile(
                                                dense: true,
                                                leading: IconTheme(data: IconThemeData(size: 10.0), child: icon != null ? Image.asset('assets'+'$icon') : CircularProgressIndicator()),
                                                title: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text('${currencyConverter.format(listRecords.data.records[index].amount)}', 
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                          fontFamily: 'Nunito',
                                                          color: listRecords.data.records[index].recordType == 0 ? Colors.green : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(bottom: 20.0),
                                                        child: Text('$dateWithT',
                                                        textAlign: TextAlign.right,
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontFamily: 'Nunito',
                                                            color: Color(0xff888888),
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '${listRecords.data.records[index].category.name}',
                                                        style: TextStyle(
                                                          color: Color(0xffbbbbbb),
                                                          fontFamily: 'Nunito',
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' — ',
                                                        style: TextStyle(
                                                          color: Color(0xffaaaaaa),
                                                          fontFamily: 'Nunito',
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '${listRecords.data.records[index].notes}'.length > 20 ? '${listRecords.data.records[index].notes}'.substring(0, 20) + '...' : '${listRecords.data.records[index].notes}',
                                                        style: TextStyle(
                                                          color: Color(0xff888888),
                                                          fontFamily: 'Nunito',
                                                          fontStyle: FontStyle.italic,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: (){

                                                  String notes = listRecords.data.records[index].notes;
                                                  String amount = listRecords.data.records[index].amount.toString();

                                                  String date = listRecords.data.records[index].date.substring(0, 10);
                                                  DateTime finalDate = DateTime.parse(date);

                                                  String time = listRecords.data.records[index].date;
                                                  DateTime finalTime = DateTime.parse(time);

                                                  String categoryName = listRecords.data.records[index].category.name;

                                                  int recordType = listRecords.data.records[index].recordType;
                                                  int categoryId = listRecords.data.records[index].category.id;

                                                  int id = listRecords.data.records[index].id;

                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id, listCategory: categoryId - 1,))); 
                                                },
                                              );
                                            }, 
                                            separatorBuilder: (BuildContext context , int index) => const Divider(color: Color(0xffcccccc), height: 1.0), 
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListRecords(hash: hash,)));
                                            },
                                            child: Text('View More',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                        ],
                      );
                    }else{
                      return EmptyDashboard(hash: hash,);
                    }
                  }else if(listRecords.hasError){
                    return Center(child: Text("Error"));
                  }
                  if(listRecords == null){
                    return Center(child: Text('Null'),);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            }else if(listIcons.hasError){
              return Center(child: Text('Error'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ),
    );
  }
}

class EmptyDashboard extends StatelessWidget{

  final String hash;

  EmptyDashboard({this.hash});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Center(child: Image.asset('assets/images/empty_icon.png'),)
                ),
                Expanded(
                  child: Center(child: Text("There are no records here yet.", style: TextStyle(fontSize: 16.0 , color: Color(0xff555555)),),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Container(
                    child: MaterialButton(
                      height: displayHeight(context),
                      minWidth: displayWidth(context) * .75,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: true, hash: hash,)));
                      },
                      color: Color(0xffffffff),
                      child: Text(
                        "START TRACKING",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class OverviewData{
  final String category;
  final double amount;

  OverviewData(this.category , this.amount);
}


class ChartsOverview extends StatefulWidget{

  final double income;
  final double expenses;

  ChartsOverview({this.income , this.expenses});

  @override
  _ChartsOverview createState() => _ChartsOverview(income: income , expenses: expenses);
}

class _ChartsOverview extends State<ChartsOverview>{

  final double income;
  final double expenses;

  _ChartsOverview({this.income , this.expenses});

  List<charts.Series> seriesList;

    @override
    void initState(){
      super.initState();
      seriesList = _createOverviewData();
    }

    dynamic barChart(){
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          minimumPaddingBetweenLabelsPx: 0,
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            fontFamily: 'Nunito'
          ),
        ),
      ),

      behaviors: [
        charts.ChartTitle(
          "OVERVIEW",
          maxWidthStrategy: charts.MaxWidthStrategy.truncate,
          outerPadding: 10,
          innerPadding: 10,
          titleOutsideJustification: charts.OutsideJustification.start,
        ),
        // charts.SlidingViewport(),
        // charts.SeriesLegend(),
        // charts.PanAndZoomBehavior(),
        
        
      ],

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
    return Padding(
      padding: EdgeInsets.only(left: displayWidth(context) * .05 , right: displayWidth(context) * .05 ),
      child: barChart(),
    );
  }
}


Future<RecordsCategory> getRecords(String hash) async{
  final response = await http.get('http://expenses.koda.ws/api/v1/records',
    headers: {
      HttpHeaders.authorizationHeader: hash,
    },
  );

  return postFromJsonRecords(response.body);
}

RecordsCategory postFromJsonRecords(String str){
  final jsonData = json.decode(str);
  var value = RecordsCategory.fromJson(jsonData);
  return value;
}


class Pagination{
  final String currentUrl;
  final String nextUrl;
  final String previousUrl;
  final int current;
  final int perPage;
  final int pages;
  final int count;

  Pagination({this.currentUrl , this.nextUrl , this.previousUrl , this.current , this.perPage , this.pages , this.count});

  factory Pagination.fromJson(Map<String , dynamic> parsedJson){
    return Pagination(
      currentUrl: parsedJson['current_url'],
      nextUrl: parsedJson['next_url'],
      previousUrl: parsedJson['previous_url'],
      current: parsedJson['current'],
      perPage: parsedJson['per_page'],
      pages: parsedJson['pages'],
      count: parsedJson['count'],
    );
  }
}

class RecordsCategory{
  final List<RecordsName> records;
  final Pagination pagination;

  RecordsCategory({this.records , this.pagination});

  factory RecordsCategory.fromJson(Map<String , dynamic> parsedJson){

    var value1 = parsedJson['pagination'];
    Pagination parsedPagination = Pagination.fromJson(value1);
    
    var value2 = parsedJson['records'] as List;

    List<RecordsName> listRecords = value2.map((e) => RecordsName.fromJson(e)).toList();

    return RecordsCategory(
      records: listRecords,
      pagination: parsedPagination,
    );
  }
}

class RecordsName{
  final int id;
  final String date;
  final String notes;
  final Category category;
  final double amount;
  final int recordType;

  RecordsName({this.id , this.date , this.notes , this.category , this.amount , this.recordType});

  factory RecordsName.fromJson(Map<String , dynamic> parsedJson){
    var list = parsedJson['category'];

    Category objectCategory = Category.fromJson(list);

    return RecordsName(
      id: parsedJson['id'],
      date: parsedJson['date'],
      notes: parsedJson['notes'],
      category: objectCategory,
      amount: parsedJson['amount'],
      recordType: parsedJson['record_type'],
    );
  }
}

class Category{
  final int id;
  final String name;

  Category({this.id , this.name});

  factory Category.fromJson(Map<String , dynamic> parsedJson){
    return Category(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}


