class Admin {
  final String username;
  final String password;

  Admin(this.username, this.password);

  @override
  String toString() {
    return 'Admin{username: $username, password: $password}';
  }
}