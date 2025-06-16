import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yalla_rehla/features/user/chat/services/image_picker_service.dart';

import '../../user/chat/data/models/chat_models.dart';
import '../../user/chat/services/chat_bot_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  bool _showImageOptions = false;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Add welcome message
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatBotService.getWelcomeMessage();
    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  void _scrollToBottom() {
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

  Future<void> _sendMessage([String? suggestionText]) async {
    final messageText = suggestionText ?? _controller.text.trim();
    if (messageText.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      type: 'user',
      message: messageText,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
      _showImageOptions = false;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      // Get bot response
      final botResponse = await ChatBotService.getBotResponse(messageText);

      setState(() {
        _messages.add(botResponse);
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            type: 'bot',
            message: 'عذراً، حدث خطأ تقني. يرجى المحاولة مرة أخرى.',
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    }

    _scrollToBottom();
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _showImageOptions = false;
    });

    try {
      File? image;
      if (source == ImageSource.camera) {
        image = await ImagePickerService.pickImageFromCamera();
      } else {
        image = await ImagePickerService.pickImageFromGallery();
      }

      // Add user message with image
      final userMessage = ChatMessage(
        type: 'user',
        message: 'تم إرسال صورة 📸',
        timestamp: DateTime.now(),
        image: image,
      );

      setState(() {
        _messages.add(userMessage);
        _isTyping = true;
      });

      _scrollToBottom();

      // Get AI response for the image
      final botResponse = await ChatBotService.getImageResponse(image!);

      setState(() {
        _messages.add(botResponse);
        _isTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildMessage(ChatMessage message, int index) {
    final isUser = message.isUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color.fromARGB(255, 101, 130, 105),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color.fromARGB(255, 101, 130, 105)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomLeft: isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image if exists
                      if (message.hasImage) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            message.image!,
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      // Message text
                      SelectableText(
                        message.message,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey, size: 16),
                ),
              ],
            ],
          ),

          // Suggestions (only for bot messages)
          if (!isUser && message.hasSuggestions) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: message.suggestions!.map((suggestion) {
                  return InkWell(
                    onTap: () => _sendMessage(suggestion),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          101,
                          130,
                          105,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            101,
                            130,
                            105,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 101, 130, 105),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Timestamp
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isUser ? 0 : 40,
              right: isUser ? 40 : 0,
            ),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color.fromARGB(255, 101, 130, 105),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(
                18,
              ).copyWith(bottomLeft: const Radius.circular(4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.2;
                        final value = (_typingAnimationController.value - delay)
                            .clamp(0.0, 1.0);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[600]?.withOpacity(
                              0.5 + 0.5 * value,
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'يكتب...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageOptions() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildImageOptionButton(
            icon: Icons.camera_alt,
            label: 'كاميرا',
            onTap: () => _pickImage(ImageSource.camera),
          ),
          _buildImageOptionButton(
            icon: Icons.photo_library,
            label: 'المعرض',
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          _buildImageOptionButton(
            icon: Icons.close,
            label: 'إلغاء',
            onTap: () => setState(() => _showImageOptions = false),
          ),
        ],
      ),
    );
  }

  Widget _buildImageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 101, 130, 105),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 101, 130, 105),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} د';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} س';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "مساعد السفر الذكي",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 130, 105),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              final status = ChatBotService.getSystemStatus();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('معلومات النظام'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حالة الذكاء الاصطناعي: ${status['gemini']['status']}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'خدمة النصوص: ${status['services']['textGeneration']}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تحليل الصور: ${status['services']['imageAnalysis']}',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('موافق'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index], index);
              },
            ),
          ),

          // Image options (when visible)
          if (_showImageOptions) _buildImageOptions(),

          // Input area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image button
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 101, 130, 105),
                  ),
                  onPressed: () {
                    setState(() {
                      _showImageOptions = !_showImageOptions;
                    });
                  },
                ),

                // Text field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك هنا...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),

                // Send button
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 101, 130, 105),
                  ),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Make sure to add this import for ImageSource if not already imported
enum ImageSource { camera, gallery }
