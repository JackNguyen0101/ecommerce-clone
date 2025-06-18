import 'package:ecommerce/common/screens/speech_screen.dart';
import 'package:ecommerce/common/widgets/loader.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/account/services/account_services.dart';
import 'package:ecommerce/features/search/screens/search_screen.dart';
import 'package:ecommerce/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notification';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AccountServices accountServices = AccountServices();
  List<AppNotification>? notifications;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() async {
    notifications = await accountServices.fetchNotifications(context);
    setState(() {});
  }

  void deleteNotifications(AppNotification notification, int index) {
    accountServices.deleteNotification(
      context: context,
      notifId: notification.id!,
      onSuccess: () {
        notifications!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  String getOrderStatusText(dynamic status) {
    int statusInt;
    if (status is int) {
      statusInt = status;
    } else if (status is String) {
      statusInt = int.tryParse(status) ?? 0;
    } else {
      statusInt = 0;
    }
    switch (statusInt) {
      case 0:
        return "Pending";
      case 1:
        return "Received";
      case 2:
        return "On Its Way";
      case 3:
        return "Completed";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: "Search or ask a question",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: navigateToSpeechScreen,
                  child: const Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: notifications == null
          ? const Loader()
          : ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notifications!.length,
              itemBuilder: (context, index) {
                final notif = notifications![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: notif.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              notif.images[0],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                          )
                        : Icon(
                            notif.read
                                ? Icons.notifications
                                : Icons.notifications_active,
                            color: notif.read ? Colors.grey : Colors.blue,
                          ),
                    title: Text(notif.message),
                    subtitle: Text(
                      'Order: ${notif.orderId}\nStatus: ${getOrderStatusText(notif.status)}\n${notif.date}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {},
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.black12),
                      onPressed: () => deleteNotifications(notif, index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
