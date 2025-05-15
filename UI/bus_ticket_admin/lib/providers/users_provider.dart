import 'package:bus_ticket_admin/models/user_upsert_model.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class UsersProvider extends BaseProvider<UserUpsertModel> {
  UsersProvider() : super('Users');

  @override
  UserUpsertModel fromJson(data) {
    return UserUpsertModel.fromJson(data);
  }
}
