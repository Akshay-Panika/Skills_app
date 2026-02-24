import 'package:flutter/material.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  String selectedCategory = "Programming";
  bool isPaid = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final categories = [
    "Programming",
    "Design",
    "Marketing",
    "Teaching",
    "Music",
    "Fitness",
  ];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  InputDecoration chatDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Service"),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 18),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// IMAGE PICKER
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 36),
                            SizedBox(height: 6),
                            Text("Upload Service Image"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SERVICE TYPE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Service Type",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text("Unpaid"),
                            selected: !isPaid,
                            onSelected: (val) => setState(() => isPaid = false),
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.blueAccent,
                            selectedColor: Colors.lightBlueAccent.withOpacity(0.16),
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("Paid"),
                            selected: isPaid,
                            onSelected: (val) => setState(() => isPaid = true),
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.blueAccent,
                            selectedColor: Colors.lightBlueAccent.withOpacity(0.16),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// FORM
                  Column(
                    children: [
                      DropdownButtonFormField(
                        value: selectedCategory,
                        items: categories
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedCategory = value.toString()),
                        decoration: chatDecoration("Category"),
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: titleController,
                        decoration: chatDecoration("Service title"),
                        validator: (v) =>
                        v!.isEmpty ? "Please enter title" : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: descController,
                        minLines: 3,
                        maxLines: null,
                        decoration: chatDecoration("Describe your service"),
                      ),

                      /// PRICE FIELD ANIMATION
                      AnimatedSize(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        child: isPaid
                            ? Column(
                          children: [
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: chatDecoration("Price").copyWith(
                                prefixText: "₹ ",
                                prefixStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              validator: (v) {
                                if (isPaid && (v == null || v.isEmpty)) {
                                  return "Enter price";
                                }
                                return null;
                              },
                            )
                          ],
                        )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTapDown: (_) => setState(() {}),
                        child: AnimatedScale(
                          scale: 1,
                          duration: const Duration(milliseconds: 120),
                          child:InkWell(
                            onTap:  () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Service Posted")),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: const Text(
                                "Post Service",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}