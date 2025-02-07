import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_track/core/constants/enums.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/theme/app_colors.dart';
import 'package:order_track/core/utils/size_config.dart';
import 'package:order_track/core/utils/utils.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/allocator/presentation/bloc/order_details_bloc.dart';
import 'package:order_track/features/allocator/presentation/bloc/product_bloc.dart';

class DistributorOrderDetailsPage extends StatelessWidget {
  final Order order;
  final DioClient dioClient = DioClient();
  final hasOrdersChanged = [false];
  final _formKey = GlobalKey<FormState>();

  DistributorOrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsBloc(order: order, dioClient: dioClient),
      child: BlocListener<OrderDetailsBloc, OrderDetailsState>(
        listener: (context, state) {
          // Show success message when updating is complete
          if (!state.isLoading && state.isUpdated && state.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Orden actualizada!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<OrderDetailsBloc>().add(ResetUpdateStatus());
          }

          // Show success message when deleting is complete
          if (!state.isLoading && state.isDeleted && state.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Orden eliminada!'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Show error message if there's an error
          if (state.isLoading == false && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error actualizando orden!"),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Detalles de orden'),
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            leading: BackButton(
              onPressed: () {
                context.pop(hasOrdersChanged[0]);
              },
            ),
          ),
          body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: state.isEditMode
                    ? _buildEditForm(context)
                    : _buildViewDetails(state),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetails(OrderDetailsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ID Orden: ${state.order.id}', style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 10.h),
        Text('Nombre del cliente: ${state.order.clientName}',
            style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 10.h),
        Text('Descripción: ${state.order.orderDescription}',
            style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 10.h),
        Text('Fecha de entrega: ${state.order.deliveryDate}',
            style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 10.h),
        Text(
            'Estado de orden: ${Utils.getTranslatedOrderStatus(state.order.orderStatus)}',
            style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 10.h),
        Text('Cantidad de productos: ${state.order.prodQuantity}',
            style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 10.h),
        Text('ID Repartidor: ${state.order.distributorId}',
            style: TextStyle(fontSize: 18.sp)),
      ],
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue:
                "ID Orden: ${context.read<OrderDetailsBloc>().state.order.id}",
            enabled: false,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          SizedBox(height: 10.h),
          TextFormField(
            initialValue:
                context.read<OrderDetailsBloc>().state.order.orderDescription,
            decoration: InputDecoration(labelText: 'Descripción'),
            onChanged: (value) => context.read<OrderDetailsBloc>().add(
                  UpdateOrderDescription(value),
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "La descripción es requerida";
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          TextFormField(
            initialValue:
                context.read<OrderDetailsBloc>().state.order.deliveryDate,
            decoration: InputDecoration(labelText: 'Fecha de entrega'),
            onTap: () => _selectDeliveryDate(context),
            readOnly: true,
          ),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            value: context.read<OrderDetailsBloc>().state.order.orderStatus,
            items: EnumOrderStatus.values.map(
              (status) {
                return DropdownMenuItem<String>(
                  value: status.name,
                  child: Text(Utils.getTranslatedOrderStatus(status.name)),
                );
              },
            ).toList(),
            onChanged: (value) =>
                context.read<OrderDetailsBloc>().add(UpdateOrderStatus(value!)),
            decoration: InputDecoration(labelText: 'Estado de orden'),
          ),
          SizedBox(height: 10.h),
          _buildQuantityCounter(context),
          SizedBox(height: 10.h),
          BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
            builder: (context, state) {
              debugPrint(state.order.distributorId);
              return state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButtonFormField<String>(
                      value: state.order.distributorId,
                      items: state.distributors
                          .map(
                            (distributor) => DropdownMenuItem(
                              value: distributor.id,
                              child: Text(
                                  '${distributor.name} (${distributor.id})'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => context
                          .read<OrderDetailsBloc>()
                          .add(UpdateDistributorId(value!)),
                      decoration: InputDecoration(labelText: 'Repartidor'),
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityCounter(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Cantidad de productos", style: TextStyle(fontSize: 18.sp)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: context.read<ProductBloc>().state
                          is! ProductLoading
                      ? () {
                          final product =
                              context.read<ProductBloc>().state.product;
                          final order = state.order;
                          if (product.isAvailable && order.prodQuantity > 0) {
                            //* remove one item from the order
                            context.read<OrderDetailsBloc>().add(
                                UpdateProductQuantity(order.prodQuantity - 1));
                            //* add removed item from order to the stock
                            context
                                .read<ProductBloc>()
                                .add(AdjustProductStock(1));
                          }
                        }
                      : null,
                ),
                Text(state.order.prodQuantity.toString(),
                    style: TextStyle(fontSize: 18.sp)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: context.read<ProductBloc>().state
                          is! ProductLoading
                      ? () {
                          final product =
                              context.read<ProductBloc>().state.product;
                          final order = state.order;
                          if (product.isAvailable) {
                            if (product.stock > 0) {
                              //* add from stock to order
                              context.read<OrderDetailsBloc>().add(
                                    UpdateProductQuantity(
                                        order.prodQuantity + 1),
                                  );
                              context
                                  .read<ProductBloc>()
                                  .add(AdjustProductStock(-1));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('No hay más artículos en stock!'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'El artículo no está disponible en estos momentos!',
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && context.mounted) {
      context
          .read<OrderDetailsBloc>()
          .add(UpdateDeliveryDate(pickedDate.toString()));
    }
  }
}
