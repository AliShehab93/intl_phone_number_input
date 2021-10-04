import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(appBar: AppBar(title: Text('Demo')), body: MyHomePage()),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              spacingBetweenFlagAndName: 2,
              aboveSearchBarPadding: 1,
              underSearchBarPadding: 1,
              betweenLineandlistElementPadding: 1,
              barColumnElementsColor: Colors.black,
              searchIconHeight: 44,
              searchIconWidth: 44,
              flagHeight: 40,
              flagWidth: 40,
              currentState: Navigator.of(context),
              backgroundPopUpBlurAndOpacityColor: Colors.white,
              heightOfTheCloseBottom: 2,
              widthOfTheCloseBottom: 2,
              topPaddingAlignHeaderText: 2,
              leftPaddingAlignHeaderText: 2,
              backgroundDialogOutsideWidget: Colors.white,
              arrowIconColor: Color(0XFF5A5A71B3),
              edgeInsetsLeft: 40,
              edgeInsetsRight: 10,
              edgeInsetsTop: 10,
              edgeInsetsBottom: 40,
              barColor: Colors.black,
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              backgroundDialogColor: Colors.white,
              closeBottonColor: Colors.black,
              countryNameStyle: TextStyle(color: Colors.black),
              dialCodeStyle: TextStyle(color: Colors.black),
              ignoreBlank: true,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: PhoneNumber(isoCode: 'NG'),
              textFieldController: controller,
              inputBorder: OutlineInputBorder(),
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              headerName: '',
              closeDialog: () => null,
              headerTextStyle: TextStyle(color: Colors.grey),
              backgroundColorForFields: Colors.white,
              hintStyle: TextStyle(),
              rightClosePadding: 1,
              topClosePadding: 1,
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
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    String parsableNumber = await PhoneNumber.getParsableNumber(number);
    controller.text = parsableNumber;

    setState(() {
      initialCountry = number.isoCode!;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
