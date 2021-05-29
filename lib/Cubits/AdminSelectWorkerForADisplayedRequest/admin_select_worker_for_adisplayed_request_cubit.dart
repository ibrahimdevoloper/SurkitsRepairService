import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_select_worker_for_adisplayed_request_state.dart';

class AdminSelectWorkerForAdisplayedRequestCubit extends Cubit<AdminSelectWorkerForAdisplayedRequestState> {
  AdminSelectWorkerForAdisplayedRequestCubit() : super(AdminSelectWorkerForAdisplayedRequestInitial());
}
