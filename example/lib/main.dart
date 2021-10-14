import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var darkTheme = ThemeData.dark().copyWith(primaryColor: Colors.blue);

    return MaterialApp(
      title: 'Demo',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Demo')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: true ? 1 : 0,
                  color: true ? Colors.red : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(true ? 23 : 0),
              ),
              child: InternationalPhoneNumberInput(
                spacingBetweenFlagAndName: 7,
                aboveSearchBarPadding: 1,
                underSearchBarPadding: 1,
                betweenLineandlistElementPadding: 1,
                barColumnElementsColor: Colors.black,
                searchIconHeight: 15,
                searchIconWidth: 15,
                closeIconClickAreaHeightSize: 50,
                closeIconClickAreaWidthSize: 50,
                flagHeight: 40,
                flagWidth: 40,
                rightClosePadding: 1,
                topClosePadding: 1,
                currentState: Navigator.of(context),
                backgroundPopUpBlurAndOpacityColor: Colors.white,
                heightOfTheCloseBottom: 2,
                widthOfTheCloseBottom: 2,
                topPaddingAlignHeaderText: 2,
                leftPaddingAlignHeaderText: 2,
                backgroundDialogOutsideWidget: Colors.white,
                arrowIconColor: Color(0XFF5A5A71B3),
                edgeInsetsLeft: 40,
                edgeInsetsRight: 40,
                edgeInsetsTop: 10,
                edgeInsetsBottom: 40,
                barColor: Colors.black,
                backgroundDialogColor: Colors.white,
                closeBottonColor: Colors.black,
                countryNameStyle: TextStyle(color: Colors.black),
                dialCodeStyle: TextStyle(color: Colors.black),
                headerName: '',
                closeDialog: () => null,
                headerTextStyle: TextStyle(color: Colors.grey),
                backgroundColorForFields: Colors.white,
                hintStyle: TextStyle(),
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: controller,
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
                textStyle: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState!.validate();
              },
              child: Text('Validate'),
            ),
            ElevatedButton(
              onPressed: () {
                getPhoneNumber('+15417543010');
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState!.save();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
