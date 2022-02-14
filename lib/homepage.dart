import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sql_database_example/utils/database_helper.dart';

import 'models/apartment_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApartmentDetail _apartmentDetail = ApartmentDetail();

  List<ApartmentDetail> _apartmentDetails = [];
  final _formKey = GlobalKey<FormState>();
  final _controlName = TextEditingController();
  final _controlPhoneNumber = TextEditingController();

  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshApartmentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_form(), _list()],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controlName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) =>
                    val!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                controller: _controlPhoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (val) =>
                    val!.isEmpty ? 'This field is required' : null,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: () => _onSubmit(),
                  child: Text('Submit'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  _refreshApartmentList() async {
    List<ApartmentDetail> x = await _dbHelper.fetchApartmentDetails();
    setState(() {
      _apartmentDetails = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      if (_apartmentDetail.id == null) {
        await _dbHelper.insertApartmentDetail(
          ApartmentDetail(
            id: DateTime.now().millisecondsSinceEpoch,
            ownerName: _controlName.text,
            phoneNumber: _controlPhoneNumber.text,
          ),
        );
      } else {
        await _dbHelper.updateApartmentDetail(_apartmentDetail);
      }
      _refreshApartmentList();
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      _controlName.clear();
      _controlPhoneNumber.clear();
      _apartmentDetail.id = null;
    });
  }

  _list() => Expanded(
          child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final datadetail = _apartmentDetails[index];
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(datadetail.ownerName!.toUpperCase()),
                  subtitle: Text(datadetail.phoneNumber!),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      await _dbHelper
                          .deleteApartmentDetail(_apartmentDetails[index].id!);
                      _resetForm();
                      _refreshApartmentList();
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _apartmentDetail = _apartmentDetails[index];
                      _controlName.text = _apartmentDetails[index].ownerName!;
                      _controlPhoneNumber.text =
                          _apartmentDetails[index].phoneNumber!;
                    });
                  },
                ),
                Divider(
                  height: 5,
                ),
              ],
            );
          },
          itemCount: _apartmentDetails.length,
        ),
      ));
}
