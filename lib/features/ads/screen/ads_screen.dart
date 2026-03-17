import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/service_list_by_user_controller.dart';
import '../repository/service_list_byuser_repository.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  final controller = Get.put(
    ServiceListByUserController(
      repository: ServiceListByUserRepository(),
    ),
  );

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
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "Sell"),
              Tab(text: "Buy"),
            ],
          ),
        ),

        body: TabBarView(
          children: [

            Obx(() {
              if (controller.isLoading.value) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(color: Colors.blueAccent,minHeight: 2,));
              }

              if (controller.serviceList.isEmpty) {
                return  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 70,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "No Bookings Yet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Your bookings will appear here",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.serviceList.length,
                itemBuilder: (context, index) {
                  final service = controller.serviceList[index];

                  return AdCard(
                    title: service.serviceName,
                    price: service.serviceAmount != null
                        ? "₹ ${service.serviceAmount}"
                        : "Free",
                    location: "India",
                    views: "0 views",
                    image: service.serviceImage,
                    status: service.serviceStatus ? "Active" : "Inactive",
                  );
                },
              );
            }),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No Bookings Yet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your bookings will appear here",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
}

class AdCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String views;
  final String status;
  final String image;

  const AdCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.views,
    required this.status,
    required this.image,
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
                  color: Colors.grey.withOpacity(0.16),
                  image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)
                ),
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