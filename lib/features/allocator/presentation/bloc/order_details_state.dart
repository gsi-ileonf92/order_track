part of 'order_details_bloc.dart';

class OrderDetailsState extends Equatable {
  final Order order;
  final bool isEditMode;
  final List<DistributorModel> distributors;
  final int availableStock;
  final bool isLoading;
  final bool isCreated;
  final bool isUpdated;
  final bool isDeleted;
  final bool isActionsEnabled;
  final String? error;

  const OrderDetailsState({
    required this.order,
    this.isEditMode = false,
    this.distributors = const [],
    this.availableStock = 100,
    this.isLoading = false,
    this.isCreated = false,
    this.isUpdated = false,
    this.isDeleted = false,
    this.isActionsEnabled = true,
    this.error,
  });

  OrderDetailsState copyWith({
    Order? order,
    bool? isEditMode,
    List<DistributorModel>? distributors,
    int? availableStock,
    bool? isLoading,
    bool? isCreated,
    bool? isUpdated,
    bool? isDeleted,
    bool? isActionsEnabled,
    String? error,
  }) {
    return OrderDetailsState(
      order: order ?? this.order,
      isEditMode: isEditMode ?? this.isEditMode,
      distributors: distributors ?? this.distributors,
      availableStock: availableStock ?? this.availableStock,
      isLoading: isLoading ?? this.isLoading,
      isCreated: isCreated ?? this.isCreated,
      isUpdated: isUpdated ?? this.isUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
      isActionsEnabled: isActionsEnabled ?? this.isActionsEnabled,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        order,
        isEditMode,
        isLoading,
        isUpdated,
        isCreated,
        isActionsEnabled,
        error,
      ];
}
