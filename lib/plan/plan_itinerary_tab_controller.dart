import 'package:flutter/material.dart';

import 'package:trufi_app/trufi_models.dart';

typedef OnTabCallback = void Function();

class PlanItineraryTabPages extends StatefulWidget {
  final TabController tabController;
  final List<PlanItinerary> itineraries;
  final OnTabCallback onTabCallback;

  PlanItineraryTabPages(
      this.tabController, this.itineraries, this.onTabCallback)
      : assert(itineraries != null && itineraries.length > 0);

  @override
  PlanItineraryTabPagesState createState() => PlanItineraryTabPagesState();
}

class PlanItineraryTabPagesState extends State<PlanItineraryTabPages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              _handleArrowButtonPress(context, -1);
            },
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTapDown: _onTabDownDetected,
                    child: Icon(Icons.keyboard_arrow_down)),
                Expanded(
                  child: TabBarView(
                    controller: widget.tabController,
                    children: widget.itineraries
                        .map<Widget>((PlanItinerary itinerary) {
                      return _buildItinerary(context, itinerary);
                    }).toList(),
                  ),
                ),
                TabPageSelector(
                  selectedColor: Colors.black,
                  controller: widget.tabController,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              _handleArrowButtonPress(context, 1);
            },
          ),
        ],
      ),
    );
  }

  void _handleArrowButtonPress(BuildContext context, int delta) {
    if (!widget.tabController.indexIsChanging) {
      widget.tabController.animateTo(
        (widget.tabController.index + delta)
            .clamp(0, widget.itineraries.length - 1),
      );
    }
  }

  _buildItinerary(BuildContext context, PlanItinerary itinerary) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          PlanItineraryLeg leg = itinerary.legs[index];
          return Row(
            children: <Widget>[
              Icon(leg.iconData()),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.body2,
                      text: leg.toInstruction(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: itinerary.legs.length,
      ),
    );
  }

  void _onTabDownDetected(TapDownDetails details) {
    widget.onTabCallback();
  }
}
