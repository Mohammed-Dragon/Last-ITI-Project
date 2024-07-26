import 'package:bloc/bloc.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  void Slider() {
    emit(AutoState());
  }

  void button() {
    emit(ButtonState());
  }
}
