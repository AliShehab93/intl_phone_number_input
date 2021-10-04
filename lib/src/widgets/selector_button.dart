import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/widgets/countries_search_list_widget.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';
import 'package:intl_phone_number_input/src/widgets/item.dart';

class SelectorButton extends StatefulWidget {
  final bool withBlur;
  final String headerName;
  //! pop up backgroud blur and opacity colo
  final Color backgroundPopUpBlurAndOpacityColor;
  //! close bottom
  final double widthOfTheCloseBottom;
  final double heightOfTheCloseBottom;
  //! padding left right the flag in textfield
  final double leftTextFieldFlag;
  final double rightTextFieldFlag;
  //!
  //! Navigator state
  final NavigatorState currentState;
  //!
  //!  close button padding
  final double rightClosePadding;
  final double topClosePadding;
  //!
  //! Flag height and width
  final double flagHeight;
  final double flagWidth;
  //!
  //! search icon height and width
  final double searchIconHeight;
  final double searchIconWidth;
  //!
  //! Color of bar Column Elements
  final Color barColumnElementsColor;
  //!
  //! padding from above and under the search bar and the padding  from title to the search icon
  final double aboveSearchBarPadding;
  final double underSearchBarPadding;
  final double betweenLineandlistElementPadding;
  //!
  final Color colorOfTheArrowAndTheBarAtTheRight;
  //! spacing between flags and name
  final double spacingBetweenFlagAndName;
  //!

  //! Arrow hight and width
  final double arrowHeight;
  final double arrowWidth;
  //!
  final double leftPaddingAlignElement;
  final double elementsListingSpacing;
  final double leftPaddingAlignHeaderText;
  final double topPaddingAlignHeaderText;
  final double rightPaddingAlignElement;
  final Function closeDialog;
  final TextStyle headerTextStyle;
  final double edgeInsetsLeft;
  final Color barColor;
  final double edgeInsetsRight;
  final double edgeInsetsTop;
  final double edgeInsetsBottom;
  final Color backgroundDialogColor;
  final Color backgroundDialogOutsideWidget;
  final List<Country> countries;
  final Country? country;
  final Color closeBottonColor;
  final TextStyle dialCodeStyle;
  final TextStyle countryNameStyle;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;
  final Color arrowIconColor;
  final double iconSize;

  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    this.withBlur = false,
    required this.headerName,
    required this.backgroundPopUpBlurAndOpacityColor,
    required this.widthOfTheCloseBottom,
    required this.heightOfTheCloseBottom,
    required this.currentState,
    required this.rightClosePadding,
    required this.topClosePadding,
    this.leftPaddingAlignElement = 10,
    this.elementsListingSpacing = 22,
    required this.leftPaddingAlignHeaderText,
    required this.topPaddingAlignHeaderText,
    this.rightPaddingAlignElement = 10,
    required this.closeDialog,
    required this.headerTextStyle,
    required this.edgeInsetsLeft,
    required this.barColor,
    required this.edgeInsetsRight,
    required this.edgeInsetsTop,
    required this.edgeInsetsBottom,
    required this.backgroundDialogColor,
    required this.backgroundDialogOutsideWidget,
    required this.countries,
    required this.country,
    required this.closeBottonColor,
    required this.dialCodeStyle,
    required this.countryNameStyle,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.isEnabled,
    required this.isScrollControlled,
    required this.onCountryChanged,
    required this.flagHeight,
    required this.flagWidth,
    required this.searchIconHeight,
    required this.searchIconWidth,
    required this.barColumnElementsColor,
    required this.aboveSearchBarPadding,
    required this.underSearchBarPadding,
    required this.betweenLineandlistElementPadding,
    required this.spacingBetweenFlagAndName,
    required this.arrowIconColor,
    required this.iconSize,
    this.leftTextFieldFlag = 15,
    this.rightTextFieldFlag = 8.67,
    this.arrowHeight = 5.86,
    this.arrowWidth = 11.71,
    this.colorOfTheArrowAndTheBarAtTheRight = Colors.black,
  }) : super(key: key);

  @override
  _SelectorButtonState createState() => _SelectorButtonState();
}

class _SelectorButtonState extends State<SelectorButton> {
  late Country? selected = widget.country;

  @override
  Widget build(BuildContext context) {
    return widget.selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? widget.countries.isNotEmpty && widget.countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                    country: widget.country,
                    showFlag: widget.selectorConfig.showFlags,
                    useEmoji: widget.selectorConfig.useEmoji,
                    leadingPadding: widget.selectorConfig.leadingPadding,
                    trailingSpace: widget.selectorConfig.trailingSpace,
                    textStyle: widget.selectorTextStyle,
                  ),
                  value: widget.country,
                  items: mapCountryToDropdownItem(widget.countries),
                  onChanged: widget.isEnabled ? widget.onCountryChanged : null,
                ),
              )
            : Item(
                country: widget.country,
                showFlag: widget.selectorConfig.showFlags,
                useEmoji: widget.selectorConfig.useEmoji,
                leadingPadding: widget.selectorConfig.leadingPadding,
                trailingSpace: widget.selectorConfig.trailingSpace,
                textStyle: widget.selectorTextStyle,
              )
        : GestureDetector(
            // key: Key(TestHelper.DropdownButtonKeyValue),
            onTap: () async {
              if (widget.countries.isNotEmpty &&
                  widget.countries.length > 1 &&
                  widget.isEnabled) {
                if (widget.selectorConfig.selectorType ==
                    PhoneInputSelectorType.BOTTOM_SHEET) {
                  selected = await showCountrySelectorBottomSheet(
                    context,
                    widget.countries,
                  );
                } else {
                  //! Dialog
                  // var value = await widget.currentState.push(
                  //   showCountrySelectorDialog(),
                  // );

                  var value = await widget.currentState.push(
                    showCountrySelectorDialog(),
                  );
                  if (value is Country) {
                    selected = value;
                  }
                }
                if (selected != null) {
                  widget.onCountryChanged(selected);
                }
              }
            },
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: widget.leftTextFieldFlag,
                    ),
                    child: Item(
                      country: widget.country,
                      showFlag: widget.selectorConfig.showFlags,
                      useEmoji: widget.selectorConfig.useEmoji,
                      leadingPadding: widget.selectorConfig.leadingPadding,
                      trailingSpace: widget.selectorConfig.trailingSpace,
                      textStyle: widget.selectorTextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.rightTextFieldFlag,
                    ),
                    child: SvgPicture.asset(
                      'assets/svgs/arrow_down.svg',
                      color: widget.colorOfTheArrowAndTheBarAtTheRight,
                      fit: BoxFit.cover,
                      package: 'intl_phone_number_input',
                      height: widget.arrowHeight,
                      width: widget.arrowWidth,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          showFlag: widget.selectorConfig.showFlags,
          useEmoji: widget.selectorConfig.useEmoji,
          textStyle: widget.selectorTextStyle,
          withCountryNames: false,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  ///
  /// //!Dialog
  showCountrySelectorDialog() {
    return PageRouteBuilder(
      opaque: false,
      transitionDuration: Duration(milliseconds: 200),
      reverseTransitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) =>
          CountrySearchListWidget(
        widget.countries,
        widget.locale,
        widget.headerName,
        widget.barColor,
        widget.countryNameStyle,
        widget.headerTextStyle,
        widget.closeDialog,
        widget.closeBottonColor,
        widget.dialCodeStyle,
        searchBoxDecoration: widget.searchBoxDecoration,
        showFlags: widget.selectorConfig.showFlags,
        useEmoji: widget.selectorConfig.useEmoji,
        autoFocus: widget.autoFocusSearchField,
        elementsListingSpacing: widget.elementsListingSpacing,
        leftPaddingAlignElement: widget.leftPaddingAlignElement,
        rightPaddingAlignElement: widget.rightPaddingAlignElement,
        backgroundDialogColor: widget.backgroundDialogColor,
        byDefaultySelectedCountry: selected!,
        leftPaddingAlignHeaderText: widget.leftPaddingAlignHeaderText,
        topPaddingAlignHeaderText: widget.topPaddingAlignHeaderText,
        heightOfTheCloseBottom: widget.heightOfTheCloseBottom,
        widthOfTheCloseBottom: widget.widthOfTheCloseBottom,
        currentState: widget.currentState,
        edgeInsetsLeft: widget.edgeInsetsLeft,
        edgeInsetsRight: widget.edgeInsetsRight,
        edgeInsetsTop: widget.edgeInsetsTop,
        edgeInsetsBottom: widget.edgeInsetsBottom,
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
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //! Curve animation
        var curve = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        //! gesture and under widget
        return GestureDetector(
          onTap: () async {
            if (widget.currentState.canPop()) {
              widget.currentState.pop(selected);
            }
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: widget.backgroundPopUpBlurAndOpacityColor
                .withOpacity(animation.value * 0.75),
            child: ScaleTransition(
              scale: curve,
              child: FadeTransition(
                opacity: curve,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(
    BuildContext context,
    List<Country> countries,
  ) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: widget.isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Stack(children: [
          GestureDetector(
            onTap: () {
              if (widget.currentState.canPop())
                widget.currentState.pop(selected);
            },
          ),
          DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: CountrySearchListWidget(
                  countries,
                  widget.locale,
                  widget.headerName,
                  widget.barColor,
                  widget.countryNameStyle,
                  widget.headerTextStyle,
                  widget.closeDialog,
                  widget.closeBottonColor,
                  widget.dialCodeStyle,
                  searchBoxDecoration: widget.searchBoxDecoration,
                  showFlags: widget.selectorConfig.showFlags,
                  useEmoji: widget.selectorConfig.useEmoji,
                  autoFocus: widget.autoFocusSearchField,
                  elementsListingSpacing: widget.elementsListingSpacing,
                  leftPaddingAlignElement: widget.leftPaddingAlignElement,
                  rightPaddingAlignElement: widget.rightPaddingAlignElement,
                  backgroundDialogColor: widget.backgroundDialogColor,
                  byDefaultySelectedCountry: selected!,
                  leftPaddingAlignHeaderText: widget.leftPaddingAlignHeaderText,
                  topPaddingAlignHeaderText: widget.topPaddingAlignHeaderText,
                  widthOfTheCloseBottom: widget.widthOfTheCloseBottom,
                  heightOfTheCloseBottom: widget.heightOfTheCloseBottom,
                  currentState: widget.currentState,
                  edgeInsetsLeft: widget.edgeInsetsLeft,
                  edgeInsetsRight: widget.edgeInsetsRight,
                  edgeInsetsTop: widget.edgeInsetsTop,
                  edgeInsetsBottom: widget.edgeInsetsBottom,
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
                ),
              );
            },
          ),
        ]);
      },
    );
  }
}
