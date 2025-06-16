import '../utils/import_export.dart';


class UserListController{

  static UserList _userController = UserList();

  void addUser(String name){
    _userController.addUser(name);
  }

  void deleteUser(int id){
    _userController.deleteUser(id);
  }

  void updateUser(int idx, String name) {
    _userController.updateUser(idx, name);
  }

    List<dynamic> getUsers() {
      return _userController.getUsers();
    }

}