import 'package:flutter/material.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("My Ads"),
          centerTitle: false,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Inactive"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            /// ACTIVE ADS
            ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                AdCard(
                  title: "iPhone 13 Pro Max",
                  price: "₹ 85,000",
                  location: "Pune, Maharashtra",
                  views: "120 views",
                  status: "Active",
                ),
                AdCard(
                  title: "Flutter App Development Service",
                  price: "₹ 1,500",
                  location: "Remote",
                  views: "45 views",
                  status: "Active",
                ),
              ],
            ),

            /// INACTIVE ADS
            ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                AdCard(
                  title: "Office Chair",
                  price: "₹ 2,000",
                  location: "Mumbai",
                  views: "30 views",
                  status: "Inactive",
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}

/// ================= AD CARD =================
class AdCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String views;
  final String status;

  const AdCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.views,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == "Active";

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 8,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),

              const SizedBox(width: 12),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),

                    const SizedBox(height: 4),

                    Text(price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),


                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(views,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12)),

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withOpacity(.12)
                                : Colors.grey.withOpacity(.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),


            ],
          ),
        ),
        
        Positioned(
            right: 0,top: 0,
            child:  IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ))
      ],
    );
  }
}