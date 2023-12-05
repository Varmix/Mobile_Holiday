import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holiday_mobile/data/models/message/message.dart';
import 'package:holiday_mobile/data/providers/signalr/connection_hub.dart';
import 'package:holiday_mobile/logic/blocs/holiday_bloc/holiday_bloc.dart';
import 'package:holiday_mobile/presentation/widgets/chat/message_chat.dart';
import 'package:auto_route/annotations.dart';
import 'package:holiday_mobile/presentation/widgets/common/custom_message.dart';
import '../../../logic/blocs/chat_bloc/chat_bloc.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  final String holidayId;
  final String holidayName;

  const ChatScreen({
    super.key,
    @PathParam() required this.holidayName,
    @PathParam() required this.holidayId,
  });

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatScreen> {
  List<Message> messages = [];
  ConnectionHub? connectionHub;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HolidayBloc>().add(GetHoliday(holidayId: widget.holidayId));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.holidayName),
            backgroundColor: const Color(0xFF1E3A8A),
          ),
          body: _buildListMessage()),
    );
  }

  Widget _buildListMessage() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStateStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentMaterialBanner()
              ..showMaterialBanner(
                  CustomMessage(message: state.errorMessage!).build(context));
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (previous, current) =>
              previous.numberMessage != current.numberMessage,
          builder: (context, state) {
            messages = state.messageList!;

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });
            return _buildChat(context);
          },
        ),
      ),
    );
  }

  Widget _buildChat(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ChatMessage(
                message: messages[index],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    hintText: "Entrez votre message...",
                  ),
                  onChanged: (value) {
                    context
                        .read<ChatBloc>()
                        .add(MessageChanged(message: value));
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  context.read<ChatBloc>().add(MessageSent(holidayId: widget.holidayId));
                  _textEditingController.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
