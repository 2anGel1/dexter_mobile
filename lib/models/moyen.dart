class MoyenDePaiement {
  late int id;
  late String name;
  late String image;
  late String channel;
  late String channelcinet;

  MoyenDePaiement({required this.id, required this.name, required this.image, required this.channel, required this.channelcinet});

  int get modelid => id;
  String get modelname => name;
  String get modelimage => image;
  String get modelchannel => channel;
  String get modelchannelcinet => channelcinet;
}
