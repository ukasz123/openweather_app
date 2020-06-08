import 'package:flutter/material.dart';

typedef void OnCityNameEntered(String city);

class AddCityCard extends StatelessWidget {
  final OnCityNameEntered onCityNameEntered;

  const AddCityCard({Key key, @required this.onCityNameEntered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var color = theme.disabledColor;
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: color,
          )),
      child: InkWell(
        splashColor: color.withOpacity(0.4),
        onTap: () => _showCityNameDialog(context),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.6,
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constraints) => Icon(
                      Icons.add_circle_outline,
                      color: color,
                      size: constraints.biggest.height,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Add city',
                  style: theme.textTheme.subtitle2.copyWith(color: color),
                )
              ],
              mainAxisSize: MainAxisSize.max,
            ),
          ),
        ),
      ),
    );
  }

  void _showCityNameDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(
                'Add city',
              ),
            content: _AddCityDialogForm(),
         );
      },
    ).then((value) {
      this.onCityNameEntered(value);
    });
  }
}

class _AddCityDialogForm extends StatefulWidget {
  const _AddCityDialogForm({
    Key key,
  }) : super(key: key);

  @override
  _AddCityDialogFormState createState() => _AddCityDialogFormState();
}

class _AddCityDialogFormState extends State<_AddCityDialogForm> {

  TextEditingController _cityNameController;
  @override
  void initState() {
    _cityNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter the city name',
            labelText: 'City name',
          ),
          controller: _cityNameController,
        ),
        SizedBox(height: 4.0),
        RaisedButton(child: Text('OK'), onPressed:(){
          var name = _cityNameController.text;
      Navigator.of(context).pop(name);
    }, )
      ],
    );
  }
}
