class Address {
  final int id;
  final String street1;
  final String street2;
  final String colony;
  final String references;

  Address(this.id, this.street1, this.street2, this.colony, this.references);

  @override
  String toString() {
    return 'Address{id: $id, street1: $street1, street2: $street2, colony: $colony, references: $references}';
  }
}
