import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_database_example/utils/database%20helper.dart';

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
    // TODO: implement initState
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
                decoration: InputDecoration(labelText: 'Full Name'),
                onSaved: (val) => setState(
                  () => _apartmentDetail.ownerName = val!,
                ),
                validator: (val) =>
                    val!.length <= 2 ? 'This field is required' : null,
              ),
              TextFormField(
                controller: _controlPhoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onSaved: (val) => setState(
                  () => _apartmentDetail.phoneNumber = val!,
                ),
                validator: (val) =>
                    val!.length < 0 ? 'This field is required' : null,
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
      form.save();
      if (_apartmentDetail.id == null)
        await _dbHelper.insertApartmentDetail(_apartmentDetail);
      else
        await _dbHelper.updateApartmentDetail(_apartmentDetail);
      await _dbHelper.insertApartmentDetail(_apartmentDetail);
      _refreshApartmentList();
      // setState(() {
      //   _apartmentDetails.add(ApartmentDetail(
      //       ownerName: _apartmentDetail.ownerName,
      //       phoneNumber: _apartmentDetail.phoneNumber));
      // });
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
                    icon: Icon(
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
