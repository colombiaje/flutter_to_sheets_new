import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Generado automáticamente por Firebase CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); // ¡Faltaba el const y el cierre del main!
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi aplicación',
      home: const FormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final cuentaController = TextEditingController();
  final descripcionController = TextEditingController();
  final valorController = TextEditingController();

  Future<void> addItem(String cuenta, String descripcion, String valor) async {
    final url = 'https://script.google.com/macros/s/AKfycbxMDENvn6oKvqqGfSlkZXCleRnHy17EJnDtRsI3Pk6-yJpQi7uXqM-954Z3FIqE8mgU/exec';

    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'addItem',
        'cuenta': cuenta,
        'descripcion': descripcion,
        'valor': valor,
      });

      if (response.statusCode == 200) {
        print('✅ Datos enviados exitosamente');
        cuentaController.clear();
        descripcionController.clear();
        valorController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movimiento agregado')),
        );
      } else {
        print('❌ Error al enviar: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al enviar')),
        );
      }
    } catch (e) {
      print('❌ Excepción al enviar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🚀 Construyendo la interfaz...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi aplicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cuentaController,
              decoration: const InputDecoration(labelText: 'Cuenta'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final cuenta = cuentaController.text;
                final descripcion = descripcionController.text;
                final valor = valorController.text;
                addItem(cuenta, descripcion, valor);
              },
              child: const Text('Agregar movimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
