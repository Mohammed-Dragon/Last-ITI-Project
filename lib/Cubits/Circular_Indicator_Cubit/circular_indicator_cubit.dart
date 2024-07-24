import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'circular_indicator_state.dart';

class CircularIndicatorCubit extends Cubit<CircularIndicatorState> {
  CircularIndicatorCubit() : super(CircularIndicatorInitial());

  void Circular() async {
    emit(CircularIndicatorLoading()); // Emit loading state
    await Future.delayed(Duration(seconds: 3));
    emit(CircularIndicatorSuccess()); // Emit success state
  }
}
