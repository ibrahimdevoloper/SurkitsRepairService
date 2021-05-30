import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../models/user_data.dart';

part 'admin_select_worker_for_adisplayed_request_state.dart';

class AdminSelectWorkerForAdisplayedRequestCubit extends Cubit<AdminSelectWorkerForAdisplayedRequestState> {
  AdminSelectWorkerForAdisplayedRequestCubit() : super(AdminSelectWorkerForAdisplayedRequestInitial()){
    // print("AdminSelectWorkerForAdisplayedRequestCubit");
    getWorkers();
  }

  List<UserData> _usersData=[];
  var _selectedCategory="sd";

  getWorkers() async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      // var query = FirebaseFirestore.instance
      //     .collection('requests')
      //     .orderBy(
      //       Request.Appointment_Date,
      //   descending: _isDescending
      //     ).where(Request.Category, isEqualTo: _selectedCategory,);
      var query = FirebaseFirestore.instance
          .collection('users').where("role",isEqualTo: "worker");
      var mapList =await FirebaseFirestore.instance
          .collection('users').where("role",isEqualTo: "worker").get();

      _usersData= [];
      mapList.docs
        ..forEach((element) {
          print(element.data());
          _usersData.add(UserData.fromJson(element.data()));
        });
      emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));

      if(_selectedCategory.isNotEmpty)
      {

      }
      else{
        // var query = FirebaseFirestore.instance
        //     .collection('requests')
        //     .orderBy(
        //     Request.Appointment_Date,
        //     descending: _isDescending
        // );
        // var mapList =await query.get();
        //
        // _requests= [];
        // mapList.docs
        //   ..forEach((element) {
        //     // print(element.data());
        //     _requests.add(Request.fromJson(element.data(), element.id));
        //   });
        // emit(AdminDisplayRequestsLoaded(_requests));
      }
      // var mapList =await query.get();
      //
      //   _requests= [];
      //   mapList.docs
      //     ..forEach((element) {
      //       // print(element.data());
      //       _requests.add(Request.fromJson(element.data(), element.id));
      //     });
    } catch (e) {
      //TODO: handle errors
      print("error: $e");
      emit(AdminSelectWorkerForAdisplayedRequestError());
    }
  }

  get selectedCategory => _selectedCategory;

  set selectedCategory(value) {
    _selectedCategory = value;
  }

  List<UserData> get usersData => _usersData;

  set usersData(List<UserData> value) {
    _usersData = value;
  }
}
