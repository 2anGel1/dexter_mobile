class Property {
  String name = "",
      type = "",
      address = "",
      description = "",
      registeredBy = "fournisseur",
      cost = "",
      room = "",
      lot = "",
      ilot = "",
      area = "",
      personMaxi = "",
      limitpersoday = "",
      caution = "";
  bool available = false;
  int municipalityId = 0, categoryId = 0, id = 0, userId = 0;

  Property(
      {required this.name,
      required this.type,
      required this.address,
      required this.description,
      required this.registeredBy,
      required this.cost,
      required this.room,
      required this.lot,
      required this.ilot,
      required this.area,
      required this.personMaxi,
      required this.limitpersoday,
      required this.municipalityId,
      required this.categoryId,
      required this.id,
      required this.userId,
      required this.available});
}
