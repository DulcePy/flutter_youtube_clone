import 'package:flutter/material.dart';

class ChannelPage extends StatefulWidget {
  final String channelId;

  const ChannelPage({
    super.key,
    required this.channelId,
  });

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.channelId),
    );
  }
}
