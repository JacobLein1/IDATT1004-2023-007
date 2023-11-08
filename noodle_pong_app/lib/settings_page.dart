import 'package:flutter/material.dart';
import 'package:noodle_pong_app/noodle_pong_app.dart';
import 'package:noodle_pong_app/constants.dart';

enum FormStateVariant { saved, error, idle }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController(text: "");
  final _portController = TextEditingController(text: "");
  FormStateVariant _formStateVariant = FormStateVariant.idle;

  NoodlePongAppState get app => NoodlePongApp.of(context);

  @override
  void initState() {
    _ipController.text = app.ipAddress;
    _portController.text = app.port.toString();
    super.initState();
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _formStateVariant = FormStateVariant.error;
      });
    } else {
      app.setNetworkInfo(_ipController.text, int.parse(_portController.text));
      setState(() {
        _formStateVariant = FormStateVariant.saved;
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          setState(() {
            _formStateVariant = FormStateVariant.idle;
          });
        });
      });
    }
  }

  void _handleResetForm(BuildContext context) {
    _formKey.currentState!.reset();
    _ipController.clear();
    _portController.clear();
    setState(() {
      _formStateVariant = FormStateVariant.idle;
    });
  }

  _handleSetDefault(BuildContext context) {
    _handleResetForm(context);
    _ipController.text = DEFAULT_IP_ADDRESS;
    _portController.text = DEFAULT_PORT.toString();
  }

  @override
  Widget build(BuildContext context) {
    final app = NoodlePongApp.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Networking",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _ipController,
                validator: _ipValidator,
                decoration: const InputDecoration(
                  labelText: "IP-address",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _portController,
                validator: _portValidator,
                decoration: const InputDecoration(
                  labelText: "Port",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Builder(builder: (context) {
                Color? backgroundColor = null;
                switch (_formStateVariant) {
                  case FormStateVariant.saved:
                    backgroundColor = Colors.green;
                    break;
                  case FormStateVariant.error:
                    backgroundColor = Colors.red;
                    break;
                  default:
                }

                String text = "Save";
                switch (_formStateVariant) {
                  case FormStateVariant.saved:
                    text = "Saved";
                    break;
                  case FormStateVariant.error:
                    text = "Error";
                    break;
                  default:
                }

                IconData icon = Icons.save;
                switch (_formStateVariant) {
                  case FormStateVariant.saved:
                    icon = Icons.check;
                    break;
                  case FormStateVariant.error:
                    icon = Icons.error;
                    break;
                  default:
                }

                return FilledButton.icon(
                    onPressed: () => _handleSubmit(context),
                    style: ButtonStyle(
                      backgroundColor: backgroundColor != null
                          ? MaterialStateProperty.all(backgroundColor)
                          : null,
                    ),
                    label: Text(text),
                    icon: Icon(icon));
              }),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => _handleSetDefault(context),
                    child: Text("Set default values"),
                  ),
                  TextButton(
                    onPressed: () => _handleResetForm(context),
                    child: Text("Reset form"),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Divider(),
              SizedBox(
                height: 24,
              ),
              Text(
                "Preferences",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 24,
              ),
              SwitchListTile(
                title: Text("Dark mode"),
                value: app.isDarkMode,
                onChanged: (value) {
                  if (value) {
                    app.setBrightness(Brightness.dark);
                  } else {
                    app.setBrightness(Brightness.light);
                  }
                },
              ),
              SizedBox(
                height: 24,
              ),
              _buildColorSelectionWidget()
            ],
          ),
        ),
      ),
    );
  }

  String? _ipValidator(String? value) {
    final regExp = RegExp(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$');
    if (value == null) {
      return "IP-adress cannot be empty";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid IP-address";
    }
    return null;
  }

  String? _portValidator(String? value) {
    final regExp = RegExp(r'^[0-9]{1,5}$');
    if (value == null) {
      return "Port cannot be empty";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid port";
    }
    return null;
  }

  static final Map<String, MaterialColor> _colorMap = {
    "Green": Colors.green,
    "Blue": Colors.blue,
    "Red": Colors.red,
    "Yellow": Colors.yellow,
    "Purple": Colors.purple,
    "Orange": Colors.orange,
  };

  String _selectedColor = "Green";

  void handleColorSelection(String color) {
    setState(() {
      _selectedColor = color;
    });
  }

  Widget _buildColorSelectionWidget() {
    return Wrap(
      spacing: 8,
      children: _colorMap.keys.map<Widget>(
        (name) {
          final color = _colorMap[name]!;
          final selectedColor = color.withOpacity(0.5);
          final isSelected = _selectedColor == name;

          late final Color textColor;
          if (isSelected) {
            textColor = Colors.black;
          } else {
            textColor =
                color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
          }

          return ChoiceChip(
            label: Text(
              name,
              style: TextStyle(color: textColor),
            ),
            selected: isSelected,
            backgroundColor: color,
            selectedColor: selectedColor,
            onSelected: (value) {
              setState(() {
                _selectedColor = name;
                NoodlePongApp.of(context).setColorSeed(color);
              });
            },
          );
        },
      ).toList(),
    );
  }
}
