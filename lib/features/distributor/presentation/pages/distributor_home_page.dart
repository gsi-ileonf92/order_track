import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_track/core/constants/enums.dart';
import 'package:order_track/core/router/app_router.dart';
import 'package:order_track/core/theme/app_colors.dart';
import 'package:order_track/core/utils/size_config.dart';
import 'package:order_track/core/utils/utils.dart';
import 'package:order_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:order_track/features/distributor/presentation/bloc/distributor_orders_bloc.dart';

class DistributorHomePage extends StatelessWidget {
  const DistributorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido, Distribuidor!'),
        backgroundColor: AppColors.transparent,
        surfaceTintColor: AppColors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Órdenes",
              style: TextStyle(fontSize: 18.sp),
            ),
            Divider(),
            Expanded(
              child: BlocBuilder<DistributorOrdersBloc, DistributorOrdersState>(
                builder: (context, state) {
                  if (state is DistributorOrdersLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DistributorOrdersLoaded) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        final statusColorCompleted =
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.green[900]
                                : Colors.green[300];
                        final statusColorPending =
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.orange[900]
                                : Colors.orange[300];
                        final statusColorProcessing =
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.blue[900]
                                : Colors.blue[300];
                        return ListTile(
                          title: Text(
                            "ID Orden: ${order.id}",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: order.orderStatus ==
                                          EnumOrderStatus.completed.name
                                      ? statusColorCompleted
                                      : order.orderStatus ==
                                              EnumOrderStatus.pending.name
                                          ? statusColorPending
                                          : statusColorProcessing,
                                  borderRadius: BorderRadius.circular(5.w),
                                ),
                                child: Text(
                                  "Estado: ${Utils.getTranslatedOrderStatus(order.orderStatus)}",
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Text(
                                "Repartidor: ${order.distributorId}",
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            final authState = context.read<AuthBloc>().state;
                            final shouldRefreshList = await context.push(
                              AppRoutes.distributorOrder.replaceAll(
                                AppRoutes.id,
                                order.id.toString(),
                              ),
                              extra: order,
                            );
                            if (shouldRefreshList == true && context.mounted) {
                              //* refresh order list
                              if (authState is AuthSuccess) {
                                context.read<DistributorOrdersBloc>().add(
                                      GetDistributorOrdersEvent(
                                          authState.user.id),
                                    );
                              }
                            }
                          },
                        );
                      },
                    );
                  } else if (state is DistributorOrdersError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text('No orders found.'));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //* refresh the list of orders
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthSuccess) {
            context.read<DistributorOrdersBloc>().add(
                  GetDistributorOrdersEvent(authState.user.id),
                );
          }
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
