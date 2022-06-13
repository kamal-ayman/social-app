import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/new_post/cubit/states.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(AppInitialState());

  static PostCubit get(context) => BlocProvider.of(context);


}
