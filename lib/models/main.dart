import 'package:scoped_model/scoped_model.dart';

import 'connected-model.dart';

class MainModel extends Model
    with ConnectedModel, ThemeModel, UserModel, NoteModel {}
