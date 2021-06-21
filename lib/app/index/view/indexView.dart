import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test_twiscode/app/index/controller/indexController.dart';

class IndexView extends StatelessWidget {
  final controller = Get.put(IndexController());
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) => controller.loadProducts());

    return Scaffold(
      appBar: AppBar(title: Text("TWISDEV")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartBottom();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart),
            Obx(
              () => Text(
                controller.cartList.length.toString(),
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.isTrue) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.isError.isTrue) {
            return Center(child: Text("Terjadi Masalah"));
          } else {
            return GridView.count(
              childAspectRatio: Get.width / (Get.height / 1.2),
              primary: false,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: List<Widget>.generate(controller.productList.length, (index) {
                return GridTile(
                  child: InkWell(
                    splashColor: Colors.blueAccent,
                    onTap: () {
                      var data = {
                        "index": index,
                        "id": controller.productList[index]['id'],
                        "merk": controller.productList[index]['title'],
                        "img": controller.productList[index]['default_photo']['img_path'],
                        "harga": controller.productList[index]['price'],
                        "condition": controller.productList[index]['condition_of_item']['name'],
                        "count": 1
                      };
                      controller.addToCart(data);
                    },
                    child: Card(
                      //color: Colors.white54,
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            child: controller.imageLoader(
                              controller.productList[index]['default_photo']['img_path'],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  controller.productList[index]['title'],
                                ),
                                Text(
                                  "Rp ${controller.productList[index]['price'].toString()}",
                                  style: TextStyle(fontSize: 30, color: Colors.orange),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.place),
                                    Text(
                                      controller.productList[index]['location_name'],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.place),
                                    Text(
                                      controller.productList[index]['location_type'],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 8,
                                          child: controller.isAvailable(controller.productList[index]['stock'])),
                                      Expanded(
                                        flex: 4,
                                        child: controller.isHalal(controller.productList[index]['is_halal']),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }
        }),
      ),
    );
  }

  void cartBottom() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 150,
                              child: controller.imageLoader(
                                controller.cartList[index]['img'],
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.cartList[index]['merk'], style: TextStyle(fontSize: 30)),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            controller.cartList[index]['price'] == null
                                                ? Text(
                                                    "Rp 0",
                                                    style: TextStyle(fontSize: 35, color: Colors.orangeAccent),
                                                  )
                                                : Text(
                                                    "Rp ${controller.cartList[index]['price'] == null}",
                                                    style: TextStyle(fontSize: 35, color: Colors.orangeAccent),
                                                  ),
                                            controller.cartList[index]['condition'] == ""
                                                ? Text("${controller.cartList[index]['condition']}")
                                                : Text("-"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: [
                                            Container(
                                              color: Colors.red,
                                              width: 40,
                                              height: 40,
                                              child: InkWell(
                                                onTap: () {
                                                  controller.decrementItem(index);
                                                },
                                                child: Icon(Icons.remove, color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 40,
                                              height: 40,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Obx(
                                                  () => Text(controller.cartList[index]['count'].toString(),
                                                      style: TextStyle(color: Colors.black54, fontSize: 40)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.blue,
                                              width: 40,
                                              height: 40,
                                              child: InkWell(
                                                onTap: () {
                                                  controller.incrementItem(index);
                                                },
                                                child: Icon(Icons.add, color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: Get.width / 1.5,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Total Harga",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(
                          () => Text(
                            "Rp " + controller.totalPrice.toString(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.orangeAccent,
                      child: Text(
                        "Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
