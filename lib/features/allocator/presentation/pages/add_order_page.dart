import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_track/core/utils/size_config.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({super.key});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionTextController = TextEditingController();
  final _deliveryDateTextController = TextEditingController();

  var _carouselIndex = 0;
  var _selectedProduct = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  final carouselItemsList = [1, 2, 3, 4, 5];

  var quantityProducts = 0;

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva orden'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save the order
                context.pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //* products list
                Column(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          height: 200.h,
                          aspectRatio: 2,
                          viewportFraction: 0.7,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _carouselIndex = index;
                            });
                          }),
                      items: carouselItemsList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                debugPrint(
                                  "selected ${carouselItemsList[i - 1]}",
                                );
                                setState(() {
                                  _selectedProduct = i;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: _selectedProduct == i
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 8.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Product $i',
                                      style: TextStyle(fontSize: 36.sp),
                                    ),
                                  )),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: carouselItemsList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 4.w,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withValues(
                                alpha: _carouselIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                //* order description
                TextFormField(
                  controller: _descriptionTextController,
                  decoration: InputDecoration(
                    labelText: "Descripción",
                  ),
                ),
                SizedBox(height: 16.h),

                //* delivery date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _deliveryDateTextController,
                        decoration: InputDecoration(
                          labelText: "Fecha de entrega",
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null && context.mounted) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  pickedDate.day == DateTime.now().day &&
                                          pickedDate.month ==
                                              DateTime.now().month &&
                                          pickedDate.year == DateTime.now().year
                                      ? TimeOfDay.now()
                                      : TimeOfDay(hour: 0, minute: 0),
                            );
                            if (pickedTime != null) {
                              if (!mounted) return;
                              setState(() {
                                _deliveryDateTextController.text =
                                    "${_getMonthName(pickedDate.month)} ${pickedDate.day}, ${pickedDate.year} a las ${pickedTime.format(context)}";
                              });
                            }
                          }
                        },
                      ),
                    ),
                    TextButton(
                      child: Text('Limpiar'),
                      onPressed: () => setState(() {
                        _deliveryDateTextController.clear();
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                //* order status {Pendiente, En proceso, Completado}
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Estado de la orden",
                  ),
                  value: 'Nuevo',
                  items: <String>[
                    'Nuevo',
                    'Pendiente',
                    'En proceso',
                    'Completado'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      // Handle change if needed
                    });
                  },
                ),
                SizedBox(height: 12.h),

                //* number of items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cantidad de Productos",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantityProducts == 0) return;
                              quantityProducts--;
                            });
                          },
                        ),
                        Text(
                          quantityProducts.toString(),
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantityProducts++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                )

                //* allocate to a distributor (only for allocator)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
