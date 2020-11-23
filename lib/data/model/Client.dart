class Client {
  final int id;
  final String name;
  final String phone;

  Client(this.id, this.name, this.phone);

  @override
  String toString() {
    return 'Client{id: $id, name: $name, phone: $phone}';
  }
}
