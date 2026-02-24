import 'package:flutter/material.dart';

import '../../chat/screen/chating_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          /// IMAGE SECTION
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor:Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.16),
                ),
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 100, color: Colors.white),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SERVICE TITLE & PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          "Flutter App Development",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.circle,size: 14,color: Colors.green,),
                          Text(
                            "Unpaid",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12,color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// LOCATION + DISTANCE
                  Row(
                    children: const [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.lightBlueAccent),
                      SizedBox(width: 4),
                      Text(
                        "5 km away, Pune",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// DESCRIPTION
                  const Text(
                    "Description",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "I provide high-quality Flutter app development services for your business and personal projects. Fully responsive and production ready.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 20),

                  /// SELLER INFO
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                         CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.withOpacity(0.16),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Akshay Panika",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("I am a flutter developer at 1.4+ years",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),

      /// CHAT BUTTON
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(left: 16.0,right: 16,bottom: 30),
        child: SizedBox(
          height: 50,
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatingScreen(),)),
                  icon: const Icon(Icons.chat,color: Colors.white,),
                  label: const Text("Chat With Mentor", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              ElevatedButton(onPressed: () => null, child: Icon(Icons.bookmark_border,color: Colors.white,),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),)
            ],
          ),
        ),
      ),
    );
  }
}