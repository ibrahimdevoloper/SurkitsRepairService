import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/Widgets/LocationPage.dart';
import 'package:an_app/models/request.dart';
import 'package:flutter/material.dart';

class RequestListItem extends StatelessWidget {
  Request _request;
  // String _requesterName;
  // String _category;
  // String _imagePath;
  // String _requestText;
  // String _recordURL;

  // bool _isPlaying;
  // String _appointmentDate;

  // Function _onPlayButtonPressed;

  Widget _playIconButton;
  Function _onItemClicked;

  RequestListItem({
    Key key,
    @required Request request,
    // @required String requesterName,
    // @required String category,
    // @required String imagePath,
    // @required String requestText,
    // @required String recordURL,
    // @required bool isPlaying,
    // @required String appointmentDate,
    // @required Function onPlayButtonPressed,
    @required Widget playIconButton,
    @required Function onItemClicked,
  })  :
        // this._requesterName = requesterName,
        // this._category = category,
        // this._imagePath = imagePath,
        // this._requestText = requestText,
        // this._recordURL = recordURL,
        // this._isPlaying = isPlaying,
        // this._appointmentDate = appointmentDate,
        // this._onPlayButtonPressed = onPlayButtonPressed,
        this._playIconButton = playIconButton,
        this._request = request,
        this._onItemClicked = onItemClicked,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: _onItemClicked,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Customer:${_request.requesterName}",
                              style: titileStyleBlack,
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              "Category: ${_request.category}",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              "Appointment: ${dateFormater(_request.appointmentDate.toDate())}",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              _request.workerName.isNotEmpty
                                  ? "Assigned to: ${_request.workerName}"
                                  : "Not Assigned to a worker",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              _request.assignedByName.isNotEmpty
                                  ? "Assigned by: ${_request.assignedByName}"
                                  : "Not Assigned by an Admin",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                            // Text(
                            //   _request.assignedByName.isNotEmpty?"Assigned by: ${_request.assignedByName}":"Not Assigned by an Admin",
                            //   style: TextStyle(
                            //       fontFamily: 'Avenir',
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 16),
                            //   textDirection: TextDirection.ltr,
                            // ),
                            Text(
                              "Status: ${_request.status}",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        //TODO : go to location
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LocationPage(_request.location),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _request.imagePath.isNotEmpty
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          _request.imagePath,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _request.recordPath.isNotEmpty
                        ? _playIconButton
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    _request.requestText.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _request.requestText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
