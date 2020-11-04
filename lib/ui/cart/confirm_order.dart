import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Address.dart';
import 'package:saborissimo/data/model/Client.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';

class ConfirmOrder extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final MenuOrder order;

  ConfirmOrder(this.order);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  String _name;
  String _phone;
  String _extras;
  String _comments;
  String _street1;
  String _street2;
  String _colony;
  String _postalCode;
  String _references;
  bool _order = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title:
            Text(Names.confirmOrderAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Form(
          key: widget._key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                createLabel(
                  'Por favor, ingrese sus datos de contacto',
                  Styles.subTitle(Colors.black),
                ),
                TextFormField(
                  decoration: createHint('Nombre *'),
                  cursorColor: Colors.red,
                  style: Styles.body(Colors.black),
                  onChanged: (value) => setState(() => _name = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                TextFormField(
                  decoration: createHint('Teléfono *'),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: Styles.body(Colors.black),
                  onChanged: (value) => setState(() => _phone = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                TextFormField(
                  decoration: createHint('Extras'),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 10,
                  style: Styles.body(Colors.black),
                  onChanged: (value) => setState(() => _extras = value),
                ),
                TextFormField(
                  decoration: createHint('Comentarios'),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 10,
                  style: Styles.body(Colors.black),
                  onChanged: (value) => setState(() => _comments = value),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _order,
                      activeColor: Palette.done,
                      onChanged: (value) => setState(() => _order = value),
                    ),
                    Text(("Quiero pedir a domicilio")),
                  ],
                ),
                if (_order)
                  createLabel(
                    'Por favor, ingrese su dirección',
                    Styles.subTitle(Colors.black),
                  ),
                if (_order)
                  TextFormField(
                    decoration: createHint('Calle *'),
                    style: Styles.body(Colors.black),
                    onChanged: (value) => setState(() => _street1 = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (_order)
                  TextFormField(
                    decoration: createHint('Entre calles *'),
                    style: Styles.body(Colors.black),
                    onChanged: (value) => setState(() => _street2 = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (_order)
                  TextFormField(
                    decoration: createHint('Colonia *'),
                    style: Styles.body(Colors.black),
                    onChanged: (value) => setState(() => _colony = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (_order)
                  TextFormField(
                      decoration: createHint('Referencias'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 10,
                      style: Styles.body(Colors.black),
                      onChanged: (value) => _references = value),
                createLabel(
                  '* Campos obligatorios',
                  Styles.subTitle(Colors.black54),
                ),
                createRoundedButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateForm() {
    if (widget._key.currentState.validate()) {
      Order order = Order(
        id: 0,
        state: false,
        order: widget.order,
        orderType: _order ? Order.isOrder : Order.isReserved,
        extras: _extras,
        comments: _comments,
        address: Address(0, _street1, _street2, _colony, _postalCode, _references),
        client: Client(0, _name, _phone),
      );

      print(order);

      Navigator.pop(context);
    }
  }

  Future<void> showSnack() {
    return Future.value(
      () => widget._scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Pedido realizado con exito'))),
    );
  }

  String _getErrorMessage(empty) {
    if (empty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  InputDecoration createHint(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.primaryLight),
      ),
    );
  }

  Widget createLabel(String text, TextStyle style) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget createRoundedButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(10),
        child: Text(
          'Realizar pedido',
          style: Styles.title(Colors.white),
        ),
        color: Palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => validateForm(),
      ),
    );
  }
}
