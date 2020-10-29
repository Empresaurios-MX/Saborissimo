class Address {
  final String street1;
  final String street2;
  final String colony;
  final String postalCode;
  final String references;

  Address(this.street1, this.street2, this.colony, this.postalCode,
      this.references);

  @override
  String toString() {
    return 'Address{street1: $street1, street2: $street2, colony: $colony, postalCode: $postalCode, references: $references}';
  }
}
