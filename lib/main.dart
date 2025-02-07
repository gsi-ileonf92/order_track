import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/theme/app_theme.dart';
import 'package:order_track/features/allocator/data/datasources/order_remote_data_source.dart';
import 'package:order_track/features/allocator/data/datasources/product_remote_data_source.dart';
import 'package:order_track/features/allocator/data/repositories/order_repository_impl.dart';
import 'package:order_track/features/allocator/data/repositories/product_repository_impl.dart';
import 'package:order_track/features/allocator/domain/usecases/order_usecase.dart';
import 'package:order_track/features/allocator/domain/usecases/product_usecase.dart';
import 'package:order_track/features/allocator/presentation/bloc/orders_bloc.dart';
import 'package:order_track/features/allocator/presentation/bloc/product_bloc.dart';
import 'package:order_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:order_track/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:order_track/features/auth/domain/usecases/login_usecase.dart';
import 'package:order_track/features/auth/domain/usecases/logout_usecase.dart';
import 'package:order_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:order_track/features/client/data/datasources/client_datasource.dart';
import 'package:order_track/features/client/data/repository/client_order_repository_impl.dart';
import 'package:order_track/features/client/domain/usecases/client_get_orders_usecase.dart';
import 'package:order_track/features/client/domain/usecases/confirm_order_received_usecase.dart';
import 'package:order_track/features/client/presentation/bloc/client_bloc.dart';
import 'package:order_track/features/distributor/data/datasources/distributor_orders_datasource.dart';
import 'package:order_track/features/distributor/data/repository/distributor_order_repository_impl.dart';
import 'package:order_track/features/distributor/domain/usecases/distributor_get_orders_usecase.dart';
import 'package:order_track/features/distributor/presentation/bloc/distributor_orders_bloc.dart';

import 'core/network/endpoints.dart';
import 'core/router/app_router.dart';
import 'core/utils/size_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Endpoints.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RepositoryProvider(
      create: (context) => AuthRepositoryImpl(
        remoteDataSource: FirebaseAuthRemoteDataSource(),
        firestore: FirebaseFirestore.instance,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              loginUseCase: LoginUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
              logoutUseCase: LogoutUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => OrdersBloc(
              getOrdersUseCase: GetOrdersUsecase(
                  OrderRepositoryImpl(OrderRemoteDataSourceImpl(DioClient()))),
              addOrderUsecase: AddOrderUsecase(
                  OrderRepositoryImpl(OrderRemoteDataSourceImpl(DioClient()))),
              updateOrderUsecase: UpdateOrderUsecase(
                  OrderRepositoryImpl(OrderRemoteDataSourceImpl(DioClient()))),
              deleteOrderUsecase: DeleteOrderUsecase(
                  OrderRepositoryImpl(OrderRemoteDataSourceImpl(DioClient()))),
            )..add(FetchOrdersEvent()),
          ),
          BlocProvider(
            create: (context) => DistributorOrdersBloc(
              getOrdersUseCase: DistributorGetOrdersUsecase(
                DistributorOrderRepositoryImpl(
                    remoteDataSource:
                        DistributorOrderRemoteDataSourceImpl(DioClient())),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ClientBloc(
              getOrdersUsecase: ClientGetOrdersUsecase(
                ClientRepositoryImpl(
                  remoteDataSource: ClientRemoteDataSourceImpl(DioClient()),
                ),
              ),
              confirmOrderReceivedUseCase: ConfirmOrderReceivedUseCase(
                ClientRepositoryImpl(
                    remoteDataSource: ClientRemoteDataSourceImpl(DioClient())),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              getProductsUsecase: GetProductsUsecase(ProductRepositoryImpl(
                  ProductRemoteDataSourceImpl(DioClient()))),
              getProductByIdUsecase: GetProductByIdUsecase(
                  ProductRepositoryImpl(
                      ProductRemoteDataSourceImpl(DioClient()))),
              updateProductUsecase: UpdateProductUsecase(ProductRepositoryImpl(
                  ProductRemoteDataSourceImpl(DioClient()))),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Order Track',
          darkTheme: AppTheme.dark,
          theme: AppTheme.light,
          routerConfig: router,
        ),
      ),
    );
  }
}
