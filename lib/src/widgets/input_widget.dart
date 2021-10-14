import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:intl_phone_number_input/src/utils/widget_view.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart';
import 'package:libphonenumber/libphonenumber.dart';

/// Enum for [SelectorButton] types.
///

class LoadingCountry {
  LoadingCountry(
      {this.initialValue, this.mounted, this.selectorConfig, this.sendPort});
  PhoneNumber? initialValue;
  SelectorConfig? selectorConfig;
  bool? mounted;
  SendPort? sendPort;
}

///
/// Available type includes:
///   * [PhoneInputSelectorType.DROPDOWN]
///   * [PhoneInputSelectorType.BOTTOM_SHEET]
///   * [PhoneInputSelectorType.DIALOG]
enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

/// A [TextFormField] for [InternationalPhoneNumberInput].
///
/// [initialValue] accepts a [PhoneNumber] this is used to set initial values
/// for phone the input field and the selector button
///
/// [selectorButtonOnErrorPadding] is a double which is used to align the selector
/// button with the input field when an error occurs
///
/// [locale] accepts a country locale which will be used to translation, if the
/// translation exist
///
/// [countries] accepts list of string on Country isoCode, if specified filters
/// available countries to match the [countries] specified.
class InternationalPhoneNumberInput extends StatefulWidget {
  //!  close button padding
  final double rightClosePadding;
  final double topClosePadding;
  //!
  final bool withBlur;
  //! Color background of the popup color blur with opacity
  final Color backgroundPopUpBlurAndOpacityColor;
  //!
  //! Navigator state
  final NavigatorState currentState;
  //!
  //! Flag height and width
  final double flagHeight;
  final double flagWidth;
  //!
  //! Color of bar Column Elements
  final Color barColumnElementsColor;
  //!
  //! padding from above and under the search bar and the padding  from title to the search icon
  final double aboveSearchBarPadding;
  final double underSearchBarPadding;
  final double betweenLineandlistElementPadding;
  //!
  //! padding left right the flag in textfield
  final double leftTextFieldFlag;
  final double rightTextFieldFlag;
  //!
  //! spacing between flags and name
  final double spacingBetweenFlagAndName;
  //!
  final Color colorOfTheArrowAndTheBarAtTheRight;
  //!
  final double closeIconClickAreaHeightSize;
  final double closeIconClickAreaWidthSize;
  //!
  final SelectorConfig selectorConfig;
  final String headerName;
  final double elementsListingSpacing;
  final Color arrowIconColor;
  final double iconSize;
  final Color barColor;
  final bool hasError;
  final Function closeDialog;
  final TextStyle headerTextStyle;
  final ValueChanged<PhoneNumber>? onInputChanged;
  final ValueChanged<bool>? onInputValidated;
  final VoidCallback? onSubmit;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final ValueChanged<PhoneNumber>? onSaved;
  final double leftPaddingAlignElement;
  final TextEditingController? textFieldController;
  final TextInputType keyboardType;
  final TextInputAction? keyboardAction;
  final Color backgroundDialogOutsideWidget;
  final PhoneNumber? initialValue;
  final String? hintText;
  final String? errorMessage;
  //! left Padding From DialCode
  final double leftPaddingFromDialCode;
  //! close bottom
  final double widthOfTheCloseBottom;
  final double heightOfTheCloseBottom;
  //! Arrow hight and width
  final double arrowHeight;
  final double arrowWidth;
  //!
  //! header of pop -up countries
  final double leftPaddingAlignHeaderText;
  final double topPaddingAlignHeaderText;
  //! search icon height and width
  final double searchIconHeight;
  final double searchIconWidth;
  //!
  final double selectorButtonOnErrorPadding;

  /// Ignored if [setSelectorButtonAsPrefixIcon = true]
  final double spaceBetweenSelectorAndTextField;
  final int maxLength;

  final bool isEnabled;
  final bool formatInput;
  final bool autoFocus;
  final bool autoFocusSearch;
  final AutovalidateMode autoValidateMode;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;
  final double height;
  final String? locale;
  final double edgeInsetsLeft;
  final double edgeInsetsRight;
  final double edgeInsetsTop;
  final double edgeInsetsBottom;
  final TextStyle? textStyle;
  final TextStyle? selectorTextStyle;
  final InputBorder? inputBorder;
  final InputDecoration? inputDecoration;
  final InputDecoration? searchBoxDecoration;
  final Color backgroundDialogColor;
  final Color closeBottonColor;
  final TextStyle countryNameStyle;
  final TextStyle dialCodeStyle;
  final Color? cursorColor;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final EdgeInsets scrollPadding;
  final Color backgroundColorForFields;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final TextStyle hintStyle;
  final double rightPaddingAlignElement;
  final List<String>? countries;

  InternationalPhoneNumberInput({
    Key? key,
    required this.rightClosePadding,
    required this.topClosePadding,
    this.withBlur = false,
    required this.backgroundPopUpBlurAndOpacityColor,
    required this.currentState,
    this.selectorConfig = const SelectorConfig(),
    required this.headerName,
    this.elementsListingSpacing = 11,
    required this.arrowIconColor,
    this.iconSize = 24,
    required this.barColor,
    this.hasError = false,
    required this.closeDialog,
    required this.headerTextStyle,
    required this.onInputChanged,
    this.onInputValidated,
    this.onSubmit,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.leftPaddingAlignElement = 15,
    this.textFieldController,
    this.keyboardType = TextInputType.phone,
    this.keyboardAction = TextInputAction.go,
    required this.backgroundDialogOutsideWidget,
    this.initialValue,
    this.hintText = 'Phone number',
    this.errorMessage = 'Invalid phone number',
    required this.widthOfTheCloseBottom,
    required this.heightOfTheCloseBottom,
    required this.leftPaddingAlignHeaderText,
    required this.topPaddingAlignHeaderText,
    this.selectorButtonOnErrorPadding = 24,
    this.spaceBetweenSelectorAndTextField = 12,
    this.maxLength = 15,
    this.isEnabled = true,
    this.formatInput = true,
    this.autoFocus = false,
    this.autoFocusSearch = false,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.ignoreBlank = false,
    this.countrySelectorScrollControlled = true,
    this.height = 20,
    this.locale,
    required this.edgeInsetsLeft,
    required this.edgeInsetsRight,
    required this.edgeInsetsTop,
    required this.edgeInsetsBottom,
    this.textStyle,
    this.selectorTextStyle,
    this.inputBorder,
    this.inputDecoration,
    this.searchBoxDecoration,
    required this.backgroundDialogColor,
    required this.closeBottonColor,
    required this.countryNameStyle,
    required this.dialCodeStyle,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.scrollPadding = const EdgeInsets.all(20.0),
    required this.backgroundColorForFields,
    this.focusNode,
    this.autofillHints,
    required this.hintStyle,
    this.rightPaddingAlignElement = 15,
    this.countries,
    required this.flagHeight,
    required this.flagWidth,
    required this.searchIconHeight,
    required this.searchIconWidth,
    required this.barColumnElementsColor,
    required this.aboveSearchBarPadding,
    required this.underSearchBarPadding,
    required this.betweenLineandlistElementPadding,
    required this.spacingBetweenFlagAndName,
    required this.closeIconClickAreaHeightSize,
    required this.closeIconClickAreaWidthSize,
    this.leftTextFieldFlag = 15,
    this.rightTextFieldFlag = 8.67,
    this.arrowHeight = 5.86,
    this.arrowWidth = 11.71,
    this.leftPaddingFromDialCode = 13.5,
    this.colorOfTheArrowAndTheBarAtTheRight = Colors.black,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InternationalPhoneNumberInput> {
  TextEditingController? controller;
  double selectorButtonBottomPadding = 0;

  Country? country;
  List<Country> countries = [];
  bool isNotValid = true;
  Future<bool?> isValidPhoneNumber(String phoneNumber, String isoCode) async {
    try {
      return await PhoneNumberUtil.isValidPhoneNumber(
        isoCode: isoCode,
        phoneNumber: phoneNumber,
      );
    } catch (_) {
      return false;
    }
  }

  //! Isolate
  late Isolate isolateForLoadingCountries;
  //! Receive Port
  late ReceivePort receivePortForLoadingCountries;

  @override
  void initState() {
    super.initState();
    loadingCountriesIsolate();
    // loadCountries();
    // controller = widget.textFieldController ?? TextEditingController();
    // initialiseWidget();
    controller = widget.textFieldController ?? TextEditingController();
    initialiseWidget();
  }

  @override
  void dispose() {
    receivePortForLoadingCountries.close();
    isolateForLoadingCountries.kill();
    super.dispose();
  }

  void loadingCountriesIsolate() async {
    receivePortForLoadingCountries = ReceivePort();

    try {
      final LoadingCountry data = LoadingCountry(
        mounted: this.mounted,
        initialValue: widget.initialValue,
        selectorConfig: widget.selectorConfig,
        sendPort: receivePortForLoadingCountries.sendPort,
      );
      await Isolate.spawn<LoadingCountry>(
        loadCountriesSeperatally,
        data,
      ).then<void>((Isolate isolate) {
        this.isolateForLoadingCountries = isolate;
      });
      print(this.mounted);
      receivePortForLoadingCountries.listen((dynamic message) {
        if (message is List)
          setState(() {
            this.countries = message[0];
            this.country = message[1];
          });
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  //spawn accepts only static methods or top-level functions

  static void loadCountriesSeperatally(
    LoadingCountry data,
  ) {
    final SendPort? sender = data.sendPort;
    var response = loadCountries(
        mounted: data.mounted,
        initialValue: data.initialValue,
        selectorConfig: data.selectorConfig);

    sender!.send(response);
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InputWidgetView(
      state: this,
    );
  }

  @override
  void didUpdateWidget(InternationalPhoneNumberInput oldWidget) {
    loadCountries(previouslySelectedCountry: country);
    if (oldWidget.initialValue?.hash != widget.initialValue?.hash) {
      if (country!.alpha2Code != widget.initialValue?.isoCode) {
        loadCountries();
      }
      initialiseWidget();
    }
    super.didUpdateWidget(oldWidget);
  }

  /// [initialiseWidget] sets initial values of the widget
  void initialiseWidget() async {
    if (widget.initialValue != null) {
      if (widget.initialValue!.phoneNumber != null &&
          widget.initialValue!.phoneNumber!.isNotEmpty &&
          (await isValidPhoneNumber(widget.initialValue!.phoneNumber!,
              widget.initialValue!.isoCode!))!) {
        String phoneNumber =
            await PhoneNumber.getParsableNumber(widget.initialValue!);

        controller!.text = widget.formatInput
            ? phoneNumber
            : phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

        phoneNumberControllerListener();
      }
    }
  }

  /// loads countries from [Countries.countryList] and selected Country
  static dynamic loadCountries(
      {Country? previouslySelectedCountry,
      PhoneNumber? initialValue,
      SelectorConfig? selectorConfig,
      bool? mounted}) {
    if (mounted != null && mounted) {
      List<Country> countries = CountryProvider.getCountriesData(countries: []);

      Country country = previouslySelectedCountry ??
          Utils.getInitialSelectedCountry(
            countries,
            initialValue?.isoCode ?? '',
          );

      // Remove potential duplicates
      countries = countries.toSet().toList();

      final CountryComparator? countryComparator =
          selectorConfig!.countryComparator;
      if (countryComparator != null) {
        countries.sort(countryComparator);
      }
      return [countries, country];
    }
  }

  /// Listener that validates changes from the widget, returns a bool to
  /// the `ValueCallback` [widget.onInputValidated]
  void phoneNumberControllerListener() {
    if (this.mounted) {
      String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      getParsedPhoneNumber(parsedPhoneNumberString, this.country?.alpha2Code)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          String phoneNumber =
              '${this.country?.dialCode}$parsedPhoneNumberString';

          if (widget.onInputChanged != null) {
            widget.onInputChanged!(PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: this.country?.alpha2Code,
                dialCode: this.country?.dialCode));
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(false);
          }
          this.isNotValid = true;
        } else {
          if (widget.onInputChanged != null) {
            widget.onInputChanged!(PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: this.country?.alpha2Code,
                dialCode: this.country?.dialCode));
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(true);
          }
          this.isNotValid = false;
        }
      });
    }
  }

  /// Returns a formatted String of [phoneNumber] with [isoCode], returns `null`
  /// if [phoneNumber] is not valid or if an [Exception] is caught.
  Future<String?> getParsedPhoneNumber(
      String phoneNumber, String? isoCode) async {
    if (phoneNumber.isNotEmpty && isoCode != null) {
      try {
        bool? isValidPhoneNumber = await PhoneNumberUtil.isValidPhoneNumber(
            phoneNumber: phoneNumber, isoCode: isoCode);

        if (isValidPhoneNumber!) {
          return await PhoneNumberUtil.normalizePhoneNumber(
              phoneNumber: phoneNumber, isoCode: isoCode);
        }
      } on Exception {
        return null;
      }
    }
    return null;
  }

  /// Creates or Select [InputDecoration]
  InputDecoration getInputDecoration(InputDecoration? decoration) {
    InputDecoration value = decoration ??
        InputDecoration(
          border: widget.inputBorder ?? UnderlineInputBorder(),
          hintText: widget.hintText,
        );

    if (widget.selectorConfig.setSelectorButtonAsPrefixIcon) {
      return value.copyWith(
        prefixIcon: SelectorButton(
          arrowIconColor: widget.arrowIconColor,
          iconSize: widget.iconSize,
          backgroundPopUpBlurAndOpacityColor:
              widget.backgroundPopUpBlurAndOpacityColor,
          heightOfTheCloseBottom: widget.heightOfTheCloseBottom,
          widthOfTheCloseBottom: widget.widthOfTheCloseBottom,
          elementsListingSpacing: widget.elementsListingSpacing,
          rightPaddingAlignElement: widget.rightPaddingAlignElement,
          barColor: widget.barColor,
          leftPaddingAlignElement: widget.leftPaddingAlignElement,
          edgeInsetsLeft: widget.edgeInsetsLeft,
          edgeInsetsRight: widget.edgeInsetsRight,
          edgeInsetsTop: widget.edgeInsetsTop,
          edgeInsetsBottom: widget.edgeInsetsBottom,
          headerName: widget.headerName,
          closeDialog: widget.closeDialog,
          headerTextStyle: widget.headerTextStyle,
          backgroundDialogOutsideWidget: widget.backgroundDialogOutsideWidget,
          backgroundDialogColor: widget.backgroundDialogColor,
          closeBottonColor: widget.closeBottonColor,
          countryNameStyle: widget.countryNameStyle,
          dialCodeStyle: widget.dialCodeStyle,
          country: country,
          countries: countries,
          onCountryChanged: onCountryChanged,
          selectorConfig: widget.selectorConfig,
          selectorTextStyle: widget.textStyle,
          searchBoxDecoration: widget.searchBoxDecoration,
          locale: locale,
          isEnabled: widget.isEnabled,
          autoFocusSearchField: widget.autoFocusSearch,
          isScrollControlled: widget.countrySelectorScrollControlled,
          leftPaddingAlignHeaderText: widget.leftPaddingAlignHeaderText,
          topPaddingAlignHeaderText: widget.topPaddingAlignHeaderText,
          withBlur: widget.withBlur,
          currentState: widget.currentState,
          rightClosePadding: widget.rightClosePadding,
          topClosePadding: widget.topClosePadding,
          flagHeight: widget.flagHeight,
          flagWidth: widget.flagWidth,
          searchIconHeight: widget.searchIconHeight,
          searchIconWidth: widget.searchIconWidth,
          barColumnElementsColor: widget.barColumnElementsColor,
          aboveSearchBarPadding: widget.aboveSearchBarPadding,
          underSearchBarPadding: widget.underSearchBarPadding,
          betweenLineandlistElementPadding:
              widget.betweenLineandlistElementPadding,
          spacingBetweenFlagAndName: widget.spacingBetweenFlagAndName,
          leftTextFieldFlag: widget.leftTextFieldFlag,
          rightTextFieldFlag: widget.rightTextFieldFlag,
          arrowHeight: widget.arrowHeight,
          arrowWidth: widget.arrowWidth,
          closeIconClickAreaHeightSize: widget.closeIconClickAreaHeightSize,
          closeIconClickAreaWidthSize: widget.closeIconClickAreaWidthSize,
        ),
      );
    }

    return value;
  }

  /// Validate the phone number when a change occurs
  void onChanged(String value) {
    phoneNumberControllerListener();
  }

  /// Validate and returns a validation error when [FormState] validate is called.
  ///
  /// Also updates [selectorButtonBottomPadding]
  String? validator(String? value) {
    bool isValid =
        this.isNotValid && (value!.isNotEmpty || widget.ignoreBlank == false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (isValid && widget.errorMessage != null) {
        setState(() {
          this.selectorButtonBottomPadding =
              widget.selectorButtonOnErrorPadding;
        });
      } else {
        setState(() {
          this.selectorButtonBottomPadding = 0;
        });
      }
    });

    return isValid ? widget.errorMessage : null;
  }

  /// Changes Selector Button Country and Validate Change.
  void onCountryChanged(Country? country) {
    setState(() {
      this.country = country;
    });
    phoneNumberControllerListener();
  }

  void _phoneNumberSaved() {
    if (this.mounted) {
      String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      String phoneNumber =
          '${this.country?.dialCode ?? ''}' + parsedPhoneNumberString;

      widget.onSaved?.call(
        PhoneNumber(
            phoneNumber: phoneNumber,
            isoCode: this.country?.alpha2Code,
            dialCode: this.country?.dialCode),
      );
    }
  }

  /// Saved the phone number when form is saved
  void onSaved(String? value) {
    _phoneNumberSaved();
  }

  /// Corrects duplicate locale
  String? get locale {
    if (widget.locale == null) return null;

    if (widget.locale!.toLowerCase() == 'nb' ||
        widget.locale!.toLowerCase() == 'nn') {
      return 'no';
    }
    return widget.locale;
  }
}

class _InputWidgetView
    extends WidgetView<InternationalPhoneNumberInput, _InputWidgetState> {
  final _InputWidgetState state;

  _InputWidgetView({Key? key, required this.state})
      : super(key: key, state: state);

  @override
  Widget build(BuildContext context) {
    final countryCode = state.country?.alpha2Code ?? '';
    final dialCode = state.country?.dialCode ?? '';

    return Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            left: 3.0,
            top: 5,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      // TODO
                      color: widget.colorOfTheArrowAndTheBarAtTheRight,
                      width: 0.251,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SelectorButton(
                      arrowIconColor: widget.arrowIconColor,
                      iconSize: widget.iconSize,
                      backgroundPopUpBlurAndOpacityColor:
                          widget.backgroundPopUpBlurAndOpacityColor,
                      heightOfTheCloseBottom: widget.heightOfTheCloseBottom,
                      widthOfTheCloseBottom: widget.widthOfTheCloseBottom,
                      elementsListingSpacing: widget.elementsListingSpacing,
                      rightPaddingAlignElement: widget.rightPaddingAlignElement,
                      barColor: widget.barColor,
                      edgeInsetsLeft: widget.edgeInsetsLeft,
                      leftPaddingAlignElement: widget.leftPaddingAlignElement,
                      edgeInsetsRight: widget.edgeInsetsRight,
                      edgeInsetsTop: widget.edgeInsetsTop,
                      edgeInsetsBottom: widget.edgeInsetsBottom,
                      headerName: widget.headerName,
                      backgroundDialogOutsideWidget:
                          widget.backgroundDialogOutsideWidget,
                      backgroundDialogColor: widget.backgroundDialogColor,
                      closeBottonColor: widget.closeBottonColor,
                      countryNameStyle: widget.countryNameStyle,
                      dialCodeStyle: widget.dialCodeStyle,
                      closeDialog: widget.closeDialog,
                      headerTextStyle: widget.headerTextStyle,
                      country: state.country,
                      countries: state.countries,
                      onCountryChanged: state.onCountryChanged,
                      selectorConfig: widget.selectorConfig,
                      selectorTextStyle: widget.textStyle,
                      searchBoxDecoration: widget.searchBoxDecoration,
                      locale: state.locale,
                      isEnabled: widget.isEnabled,
                      autoFocusSearchField: widget.autoFocusSearch,
                      isScrollControlled:
                          widget.countrySelectorScrollControlled,
                      leftPaddingAlignHeaderText:
                          widget.leftPaddingAlignHeaderText,
                      topPaddingAlignHeaderText:
                          widget.topPaddingAlignHeaderText,
                      withBlur: widget.withBlur,
                      currentState: widget.currentState,
                      rightClosePadding: widget.rightClosePadding,
                      topClosePadding: widget.topClosePadding,
                      flagHeight: widget.flagHeight,
                      flagWidth: widget.flagWidth,
                      searchIconHeight: widget.searchIconHeight,
                      searchIconWidth: widget.searchIconWidth,
                      barColumnElementsColor: widget.barColumnElementsColor,
                      aboveSearchBarPadding: widget.aboveSearchBarPadding,
                      underSearchBarPadding: widget.underSearchBarPadding,
                      betweenLineandlistElementPadding:
                          widget.betweenLineandlistElementPadding,
                      spacingBetweenFlagAndName:
                          widget.spacingBetweenFlagAndName,
                      leftTextFieldFlag: widget.leftTextFieldFlag,
                      rightTextFieldFlag: widget.rightTextFieldFlag,
                      arrowHeight: widget.arrowHeight,
                      arrowWidth: widget.arrowWidth,
                      colorOfTheArrowAndTheBarAtTheRight:
                          widget.colorOfTheArrowAndTheBarAtTheRight,
                      closeIconClickAreaHeightSize:
                          widget.closeIconClickAreaHeightSize,
                      closeIconClickAreaWidthSize:
                          widget.closeIconClickAreaWidthSize,
                    ),
                  ],
                ),
              ),
              //! spacing
              SizedBox(width: widget.leftPaddingFromDialCode),
              //! dial code
              Text(
                '($dialCode)',
                maxLines: 1,
                textDirection: TextDirection.ltr,
                softWrap: true,
                textWidthBasis: TextWidthBasis.parent,
                style: widget.selectorTextStyle,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: widget.rightTextFieldFlag),
            child: TextFormField(
              key: Key(TestHelper.TextInputKeyValue),
              textDirection: TextDirection.ltr,
              controller: state.controller,
              cursorColor: widget.cursorColor,
              focusNode: widget.focusNode,
              enabled: widget.isEnabled,
              autofocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              textInputAction: widget.keyboardAction,
              style: widget.textStyle,
              decoration: InputDecoration(
                isDense: true,
                alignLabelWithHint: true,
                isCollapsed: true,
                fillColor: widget.backgroundColorForFields,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      18,
                    ),
                    bottomRight: Radius.circular(
                      18,
                    ),
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      18,
                    ),
                    bottomRight: Radius.circular(
                      18,
                    ),
                  ),
                ),
              ),
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              onEditingComplete: widget.onSubmit,
              onFieldSubmitted: widget.onFieldSubmitted,
              autovalidateMode: widget.autoValidateMode,
              autofillHints: widget.autofillHints,
              validator: null,
              onSaved: state.onSaved,
              scrollPadding: widget.scrollPadding,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
                widget.formatInput
                    ? AsYouTypeFormatter(
                        isoCode: countryCode,
                        dialCode: dialCode,
                        onInputFormatted: (TextEditingValue value) {
                          state.controller!.value = value;
                        },
                      )
                    : FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: state.onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
