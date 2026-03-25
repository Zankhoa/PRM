import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/service/discount_service.dart';
import 'package:shop_owner_screen/data/models/discount_dto.dart';

class CreateDiscountScreen extends StatefulWidget {
  const CreateDiscountScreen({super.key});

  @override
  State<CreateDiscountScreen> createState() =>
      _CreateDiscountScreenState();
}

class _CreateDiscountScreenState extends State<CreateDiscountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController codeController = TextEditingController();
  final TextEditingController percentController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Discount")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(labelText: "Code"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: percentController,
                decoration:
                    const InputDecoration(labelText: "Percent"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: startController,
                decoration:
                    const InputDecoration(labelText: "Start Date"),
              ),

              TextFormField(
                controller: endController,
                decoration:
                    const InputDecoration(labelText: "End Date"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  await DiscountService.create({
                    "discountCode": codeController.text,
                    "percentDiscount":
                        int.tryParse(percentController.text) ?? 0,
                    "startDate": startController.text,
                    "endDate": endController.text,
                    "isActive": true
                  });

                  Navigator.pop(context);
                },
                child: const Text("Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}