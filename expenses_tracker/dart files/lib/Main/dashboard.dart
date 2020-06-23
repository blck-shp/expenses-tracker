import 'dart:convert';
import 'dart:io';
import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Extras/sizes.dart';
import 'package:expenses_tracker/Main/modify_record.dart';
import 'package:flutter/material.dart';
import 'list_records.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;


class Overview{
  double income;
  double expenses;

  Overview({this.income , this.expenses});

  factory Overview.parseOverview(Map<String, dynamic> parsedJson){
    return Overview(
      income: parsedJson['income'],
      expenses: parsedJson['expenses']
    );
  }
}

class Dashboard extends StatefulWidget{
  final String hash;

  Dashboard({this.hash});

  @override
  _Dashboard createState() => _Dashboard(hash: hash);
}

class _Dashboard extends State<Dashboard>{

  List<String> icons = [
    "/images/ic_food_drinks.png",
    "/images/ic_groceries.png",
    "/images/ic_clothes.png",
    "/images/ic_electronics.png",
    "/images/ic_healthcare.png",
    "/images/ic_gifts.png",
    "/images/ic_transportation.png",
     "/images/ic_education.png",
     "/images/ic_entertainment.png",
     "/images/ic_utilities.png",
     "/images/ic_rent.png",
     "/images/ic_household.png",
     "/images/ic_investments.png",
     "/images/ic_other.png",
  ];

  final String hash;

  _Dashboard({this.hash});

  Future<Overview> getOverview(String hash) async{
    final response = await http.get(
      'http://expenses.koda.ws/api/v1/records/overview',
      headers: {
        HttpHeaders.authorizationHeader: hash,
      },
    );

    if(response.statusCode == 200){
      return Overview.parseOverview(json.decode(response.body));
    }else{
      throw Exception('Failed to create account');
    }
  }

  @override
  Widget build(BuildContext context){
    print('The value of hash is in dashboard is $hash');
    return Scaffold(
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
          Route route = MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: true, hash: hash));
          Navigator.push(context , route);
        },
        backgroundColor: Color(0xff246c55),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<RecordsCategory>(
        future: getRecords(hash),
        builder: (context , snapshot){
          print('The snapshot is ${snapshot.data}');
          if(snapshot.hasData){
            if(snapshot.data.pagination.count == 0){
              return EmptyDashboard(hash: hash,);
            }else{
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Card(
                        child: Container(
                          width: displayWidth(context) * .90,
                          child: FutureBuilder<Overview>(
                            future: getOverview(hash),
                            builder: (context , snapshot){
                              if(snapshot.hasData){
                                return ChartsOverview(income: snapshot.data.income, expenses: snapshot.data.expenses,);
                              }else if(snapshot.hasError){
                                return Center(child: Text("Error"));
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Card(
                        child: Container(
                          width: displayWidth(context) * .90,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('RECENT',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: displayWidth(context) * .90,
                                  child: ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: snapshot.data.pagination.count >= 2 ? 2 : 1,
                                    itemBuilder: (BuildContext context , int index){
                                      String date = snapshot.data.records[index].date;
                                      String dateWithT = date.substring(0, 10);
                                      return ListTile(
                                        leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[index + 2]}')),
                                        title: Text('P ' + '${snapshot.data.records[index].amount}' + '0'),
                                        subtitle: Text('${snapshot.data.records[index].category.name}' + ' — ' + '${snapshot.data.records[index].notes}' , style: TextStyle(fontSize: 12.0),),
                                        trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0),),
                                      );
                                    }, 
                                    separatorBuilder: (BuildContext context , int index) => const Divider(), 
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListRecords(hash: hash,)));
                                    },
                                    child: Text('View More',
                                      style: TextStyle(
                                        fontSize: 16.0,
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
            }
          }else if(snapshot.hasError){
            return Center(child: Text("Error"));
          }
          if(snapshot == null){
            return Center(child: Text('Null'),);
          }
          return Center(child: CircularProgressIndicator());
        },
      )
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ModifyRecord(isEmpty: true, hash: hash,)));
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
      behaviors: [
        charts.ChartTitle(
          "OVERVIEW",
          maxWidthStrategy: charts.MaxWidthStrategy.truncate,
          outerPadding: 15,
          innerPadding: 10,
          titleOutsideJustification: charts.OutsideJustification.start,
        ),
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
    return barChart();
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


