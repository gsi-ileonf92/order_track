import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/theme/app_colors.dart';
import 'package:order_track/core/utils/size_config.dart';
import 'package:order_track/core/utils/utils.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/allocator/presentation/bloc/order_details_bloc.dart';

class ClientOrderDetailsPage extends StatelessWidget {
  final Order order;
  final DioClient dioClient = DioClient();
  final hasOrdersChanged = [false];

  ClientOrderDetailsPage({super.key, required this.order});

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
                child: _buildViewDetails(state),
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
}
