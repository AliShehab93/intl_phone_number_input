import 'dart:isolate';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/filter_processing.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:flutter/material.dart';

import 'close_widget.dart';

/// Creates a list of Countries with a search textfield.!dsfsdf
final UniqueKey _key = UniqueKey();
final UniqueKey _keySearch = UniqueKey();
final UniqueKey _keyClose = UniqueKey();
final UniqueKey keyCountryList = UniqueKey();

class CountrySearchListWidget extends StatefulWidget {
  //! Navigator state
  final NavigatorState currentState;
  //!
  final double edgeInsetsLeft;
  final double edgeInsetsRight;
  final double edgeInsetsTop;
  final double edgeInsetsBottom;
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
  //! spacing between flags and name
  final double spacingBetweenFlagAndName;
  //!
  //! search icon height and width
  final double closeIconClickAreaHeightSize;
  final double closeIconClickAreaWidthSize;
  //!
  final String headerName;
  final double heightOfTheCloseBottom;
  final double widthOfTheCloseBottom;
  final double elementsListingSpacing;
  final double leftPaddingAlignElement;
  final double leftPaddingAlignHeaderText;
  final double topPaddingAlignHeaderText;
  final double rightPaddingAlignElement;
  final Function closeDialog;
  final TextStyle headerTextStyle;
  final Color barColor;
  final Color closeBottonColor;
  final TextStyle dialCodeStyle;
  final TextStyle countryNameStyle;
  final Country byDefaultySelectedCountry;
  final List<Country> countries;
  final Color backgroundDialogColor;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;

  CountrySearchListWidget(
    this.countries,
    this.locale,
    this.headerName,
    this.barColor,
    this.countryNameStyle,
    this.headerTextStyle,
    this.closeDialog,
    this.closeBottonColor,
    this.dialCodeStyle, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.elementsListingSpacing = 10,
    this.leftPaddingAlignElement = 20,
    this.rightPaddingAlignElement = 20,
    required this.backgroundDialogColor,
    required this.byDefaultySelectedCountry,
    required this.leftPaddingAlignHeaderText,
    required this.topPaddingAlignHeaderText,
    required this.heightOfTheCloseBottom,
    required this.widthOfTheCloseBottom,
    required this.currentState,
    required this.edgeInsetsLeft,
    required this.edgeInsetsRight,
    required this.edgeInsetsTop,
    required this.edgeInsetsBottom,
    required this.rightClosePadding,
    required this.topClosePadding,
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
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<Country>> _valueNotifierListCountriesFiltred =
      ValueNotifier([]);
  // late List<Country> filteredCountries = [];
  late Isolate? _isolate;
  late ReceivePort? _receivePort;

  @override
  void initState() {
    super.initState();
    _receivePort = ReceivePort();
    filterCountriesIsolate();
  }

  void filterCountriesIsolate({String? value, bool noListening = false}) async {
    try {
      final FilterProcessing data = FilterProcessing(
        countries: widget.countries,
        sendPort: _receivePort!.sendPort,
        text: value == null ? _searchController.text.trim() : value,
      );
      await Isolate.spawn<FilterProcessing>(
        filterSeperatally,
        data,
      ).then<void>((Isolate isolate) {
        this._isolate = isolate;
      });
      if (!noListening)
        _receivePort!.listen((dynamic message) {
          if (message is List<Country>) {
            // Timer(Duration(milliseconds: 205), () {
            {
              // setState(() {

              setState(() {
                _valueNotifierListCountriesFiltred.value = message;
              });
              // filteredCountries = message;
              // });
              // _isolate!.pause();
            }
            // });
          }
        });
    } catch (e) {
      print("Error: $e");
    }
  }

  //spawn accepts only static methods or top-level functions

  void filterSeperatally(
    FilterProcessing data,
  ) {
    final SendPort? sender = data.sendPort;
    var response = filterCountries(
      countries: data.countries!,
      text: data.text!,
    );
    sender!.send(response);
  }

  static String? getCountryName(
      {required Country country, required String local}) {
    if (country.nameTranslations != null) {
      String? translated = country.nameTranslations![local];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
    return country.name;
  }

  List<Country> filterCountries({
    required String text,
    required List<Country> countries,
  }) {
    final value = text.trim();

    if (value.isNotEmpty) {
      return countries
          .where(
            (Country country) =>
                country.alpha3Code!.toLowerCase().startsWith(
                      value.toLowerCase(),
                    ) ||
                getCountryName(country:country, local: widget.locale??"") !.toLowerCase().contains(value.toLowerCase()) ||
                country.dialCode!.contains(value.toLowerCase()),
          )
          .toList();
    }

    return countries;
  }

  @override
  void dispose() {
    if (_isolate != null) _isolate!.kill();
    _receivePort!.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CountrySearchListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      print('${widget.backgroundDialogColor}');
    });
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(labelText: 'Search by country name or dial code');
  }

  /// Returns the country name of a [Country]. if the locale is set and translation in available.
  /// returns the translated name.
  // String? getCountryName(Country country) {
  //   if (widget.locale != null && country.nameTranslations != null) {
  //     String? translated = country.nameTranslations![widget.locale!];
  //     if (translated != null && translated.isNotEmpty) {
  //       return translated;
  //     }
  //   }
  //   return country.name;
  // }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return GestureDetector(
      onTap: () => print('inside'),
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.edgeInsetsLeft - 2,
          right: widget.edgeInsetsRight - 2,
          top: widget.edgeInsetsTop - 5,
          bottom: widget.edgeInsetsBottom,
        ),
        child: Material(
          key: keyCountryList,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(.4),
          color: Colors.transparent,
          borderOnForeground: false,
          animationDuration: const Duration(milliseconds: 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
            side: BorderSide.none,
          ),
          child: Container(
            margin: EdgeInsets.only(
              left: 2,
              right: 2,
              top: 3,
              bottom: 0,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundDialogColor,
              borderRadius: BorderRadius.circular(23),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //! header text widget
                    // Expanded(
                    //   flex: 5,
                    //   child:
                    Padding(
                      padding: EdgeInsets.only(
                        top: widget.topPaddingAlignHeaderText,
                        left: widget.leftPaddingAlignHeaderText,
                      ),
                      child: Text(
                        widget.headerName,
                        overflow: TextOverflow.ellipsis,
                        style: widget.headerTextStyle,
                      ),
                    ),
                    // ),
                    //! Close button Icon
                    GestureDetector(
                      onTap: () async {
                        if (widget.currentState.canPop()) {
                          widget.currentState.pop(
                            (widget.byDefaultySelectedCountry),
                          );
                        }
                      },
                      child: //! Close button Icon
                          Container(
                        alignment: Alignment.topRight,
                        color: Colors.transparent,
                        width: widget.closeIconClickAreaWidthSize,
                        height: widget.closeIconClickAreaHeightSize,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: widget.topClosePadding,
                            right: widget.rightClosePadding,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            height: widget.heightOfTheCloseBottom,
                            width: widget.heightOfTheCloseBottom,
                            child: CustomPaint(
                              painter: CloseWithStroke1(
                                color: widget.closeBottonColor,
                                value: widget.heightOfTheCloseBottom,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //! under title
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.leftPaddingAlignElement,
                    right: widget.rightPaddingAlignElement,
                    top: widget.aboveSearchBarPadding,
                    bottom: widget.underSearchBarPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //! search Icon
                      Padding(
                        padding: EdgeInsets.only(
                            right: widget.spacingBetweenFlagAndName),
                        child: Container(
                          color: Colors.transparent,
                          width: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: widget.searchIconWidth,
                                height: widget.searchIconWidth,
                                child: Icon(
                                  Icons.search,
                                  color: widget.closeBottonColor,
                                ),
                                //  SvgPicture.asset(
                                //   'assets/svgs/search_country.svg',
                                //   key: _keySearch,
                                //   semanticsLabel: 'search',
                                //   color: widget.closeBottonColor,
                                //   fit: BoxFit.cover,
                                //   package: 'intl_phone_number_input',
                                //   placeholderBuilder: (context) =>
                                //       const SizedBox.shrink(),
                                //   clipBehavior: Clip.antiAliasWithSaveLayer,
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //! search textfield
                      Flexible(
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: widget.barColor,
                          key: Key(TestHelper.CountrySearchInputKeyValue),
                          decoration: widget.searchBoxDecoration,
                          style: widget.countryNameStyle,
                          controller: _searchController,
                          autofocus: widget.autoFocus,
                          onChanged: (value) => filterCountriesIsolate(
                            value: value,
                            noListening: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 1,
                  width: double.infinity,
                  color: widget.barColor,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: widget.leftPaddingAlignElement,
                      right: widget.rightPaddingAlignElement,
                    ),
                    child: ValueListenableBuilder<List<Country>>(
                        valueListenable: _valueNotifierListCountriesFiltred,
                        child: //! under lining bar elements
                            Container(
                          height: 0.2,
                          width: double.infinity,
                          color: widget.barColumnElementsColor,
                        ),
                        builder: (context, value, child) {
                          return ListView.builder(
                            key: _key,
                            padding: const EdgeInsets.all(0),
                            controller: widget.scrollController,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            // addAutomaticKeepAlives: false,
                            // shrinkWrap: true,
                            itemCount: value.isNotEmpty ? value.length : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  //! Sized
                                  SizedBox(
                                    height: index == 0
                                        ? widget.betweenLineandlistElementPadding +
                                            widget.elementsListingSpacing
                                        : widget.elementsListingSpacing,
                                  ),
                                  ListTile(
                                    horizontalTitleGap:
                                        widget.spacingBetweenFlagAndName,
                                    minVerticalPadding: 0,
                                    minLeadingWidth: 0,
                                    key: Key(TestHelper.countryItemKeyValue(
                                        value.isNotEmpty
                                            ? value[index].alpha2Code
                                            : '')),
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: widget.showFlags!
                                        ? _Flag(
                                            country: value.isNotEmpty
                                                ? value[index]
                                                : null,
                                            useEmoji: widget.useEmoji,
                                            height: widget.flagHeight,
                                            width: widget.flagWidth,
                                          )
                                        : null,
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                              '${value.isNotEmpty ? getCountryName(country:value[index], local: widget.locale??"") : ''}',
                                              overflow: TextOverflow.ellipsis,
                                              style: widget.countryNameStyle,
                                              textAlign: TextAlign.start),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '${value.isNotEmpty ? value[index].dialCode ?? '' : ''}',
                                            overflow: TextOverflow.ellipsis,
                                            textDirection: TextDirection.ltr,
                                            style: widget.dialCodeStyle,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      if (widget.currentState.canPop()) {
                                        widget.currentState.pop(
                                          value.isNotEmpty
                                              ? value[index]
                                              : null,
                                        );
                                      }
                                    },
                                  ),

                                  child!,
                                ],
                              );
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;
  final double? height;
  final double? width;
  const _Flag(
      {Key? key,
      this.country,
      this.useEmoji,
      this.height = 40,
      this.width = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? SizedBox(
                    height: height,
                    width: width,
                    child: Text(
                      Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )
                : country?.flagUri != null
                    ? SizedBox(
                        height: height,
                        width: width,
                        child: SvgPicture.asset(
                          country!.flagUri,
                          fit: BoxFit.fill,
                          package: 'intl_phone_number_input',
                          placeholderBuilder: (context) =>
                              const SizedBox.shrink(),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                        ),
                      )
                    : const SizedBox.shrink(),
          )
        : const SizedBox.shrink();
  }
}
