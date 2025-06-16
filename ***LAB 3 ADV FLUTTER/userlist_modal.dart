class UserList{
  final  List<dynamic> _users = [];

  void addUser(String name){
    _users.add(name);
  }
  void updateUser(int idx,String name){
    if(idx >=0 && idx < _users.length){
      _users[idx] = name;
    }
  }
  void deleteUser(int idx){
    if(idx >=0 && idx < _users.length){
      _users.removeAt(idx);
    }
  }
  List<dynamic> getUsers(){
    return _users;
  }

}