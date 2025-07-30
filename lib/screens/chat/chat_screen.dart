import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String orderId;
  final String userId;
  final String otherUserId;

  const ChatScreen({
    Key? key,
    required this.orderId,
    required this.userId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setChatScreenState(this);
    chatProvider.joinChat(widget.orderId);
    chatProvider.setupChatListeners();
    // Fetch messages after build to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.fetchMessages(widget.orderId).then((_) {
        _navigateToLatestMessage();
      });
    });

    // Listen for message changes
    chatProvider.addListener(_onMessagesChanged);
  }

  void _onMessagesChanged() {
    if (mounted) {
      _navigateToLatestMessage();
    }
  }

  void _navigateToLatestMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Provider.of<ChatProvider>(context, listen: false).removeListener(_onMessagesChanged);
    super.dispose();
  }

  void reload() {
    // Defer fetch to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.fetchMessages(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #${widget.orderId.split('-').last}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.messages.isEmpty) {
                  return const Center(child: Text('Chưa có tin nhắn nào'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[provider.messages.length - 1 - index];
                    return MessageBubble(
                      message: message,
                      isMe: message.senderId == widget.userId,
                      // onTap: () {
                      //   if (!message.read && message.senderId != widget.userId) {
                      //     provider.markAsRead(message.id);
                      //   }
                      // },
                    );
                  },
                );
              },
            ),
          ),
          ChatInput(
            onSend: (content) {
              chatProvider.sendMessage(
                widget.orderId,
                widget.userId,
                widget.otherUserId,
                content,
              );
            },
          ),
        ],
      ),
    );
  }
}
