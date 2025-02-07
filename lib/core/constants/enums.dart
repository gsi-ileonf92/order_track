enum EnumOrderStatus {
  pending(displayName: "Pendiente"),
  processing(displayName: "En proceso"),
  completed(displayName: "Completada");

  final String displayName;
  const EnumOrderStatus({required this.displayName});
}

enum EnumRoles {
  allocator(displayName: "Asignador"),
  distributor(displayName: "Repartidor"),
  client(displayName: "Cliente");

  final String displayName;
  const EnumRoles({required this.displayName});
}
