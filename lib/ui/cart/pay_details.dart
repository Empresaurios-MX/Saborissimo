import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Address.dart';
import 'package:saborissimo/data/model/Client.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/cart/pay_confirm.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/widgets/body_label.dart';
import 'package:saborissimo/widgets/input/long_text_field_empty.dart';
import 'package:saborissimo/widgets/input/phone_field_empty.dart';
import 'package:saborissimo/widgets/input/text_field_empty.dart';
import 'package:saborissimo/widgets/sub_title_label.dart';

class PayDetails extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final MenuOrder menuOrder;

  PayDetails(this.menuOrder);

  @override
  _PayDetailsState createState() => _PayDetailsState();
}

class _PayDetailsState extends State<PayDetails> {
  String _name;
  String _phone;
  String _extras;
  String _comments;
  String _street1;
  String _street2;
  String _colony;
  String _references;
  bool _order = false;

  @override
  void initState() {
    _name = '';
    _phone = '';
    _extras = '';
    _comments = '';
    _street1 = '';
    _street2 = '';
    _colony = '';
    _references = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text('Datos del pedido')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () => validateForm(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: widget._key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SubTitleLabel('Por favor, ingrese sus datos de contacto'),
                TextFieldEmpty(
                  hint: 'Nombre *',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _name = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                PhoneFieldEmpty(
                  hint: 'Teléfono *',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _phone = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                LongTextFieldEmpty(
                  hint: 'Extras',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _extras = value),
                ),
                LongTextFieldEmpty(
                  hint: 'Comentarios',
                  theme: Palette.primary,
                  textListener: (value) => setState(() => _comments = value),
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
                if (_order) SubTitleLabel('Por favor, ingrese su dirección'),
                if (_order)
                  TextFieldEmpty(
                    hint: 'Calle *',
                    theme: Palette.primary,
                    textListener: (value) => setState(() => _street1 = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (_order)
                  TextFieldEmpty(
                    hint: 'Entre calles *',
                    theme: Palette.primary,
                    textListener: (value) => setState(() => _street2 = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (_order)
                  TextFieldEmpty(
                    hint: 'Colonia *',
                    theme: Palette.primary,
                    textListener: (value) => setState(() => _colony = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (_order)
                  LongTextFieldEmpty(
                    hint: 'Referencias',
                    theme: Palette.primary,
                    textListener: (value) =>
                        setState(() => _references = value),
                    validator: () => {},
                  ),
                Container(
                  width: double.infinity,
                  child: BodyLabel('* Campos obligatorios'),
                ),
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
        0,
        false,
        widget.menuOrder,
        _order ? Order.isOrder : Order.isReserved,
        _extras,
        _comments,
        Address(0, _street1, _street2, _colony, _references),
        Client(0, _name, _phone),
      );

      NavigationUtils.push(context, PayConfirm(order));
    }
  }

  String _getErrorMessage(empty) {
    if (empty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
}
