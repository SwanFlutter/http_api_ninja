import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../controller/http_controller.dart';
import '../widgets/request_builder_widget.dart';
import '../widgets/response_area_widget.dart';
import '../widgets/sidebar_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // Left: Collections Sidebar (280px fixed)
              const SidebarWidget(),

              // Middle: Request Builder (flexible)
              const Expanded(child: RequestBuilderWidget()),

              // Resizer
              MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    controller.responseAreaWidth.value =
                        (controller.responseAreaWidth.value - details.delta.dx)
                            .clamp(300.0, 800.0);
                  },
                  child: Container(
                    width: 4,
                    color: Theme.of(context).dividerColor,
                    child: Center(
                      child: Container(
                        width: 2,
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // Right: Response Area (resizable)
              Obx(
                () => SizedBox(
                  width: controller.responseAreaWidth.value,
                  child: const ResponseAreaWidget(),
                ),
              ),
            ],
          ),

          // Notification Banner
          Obx(() {
            if (controller.notificationMessage.value.isEmpty) {
              return const SizedBox.shrink();
            }

            Color bgColor;
            IconData icon;

            switch (controller.notificationType.value) {
              case 'success':
                bgColor = Colors.green;
                icon = Icons.check_circle;
                break;
              case 'error':
                bgColor = Colors.red;
                icon = Icons.error;
                break;
              case 'info':
                bgColor = Colors.orange;
                icon = Icons.info;
                break;
              default:
                bgColor = Colors.blue;
                icon = Icons.notifications;
            }

            return Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            controller.notificationMessage.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            controller.notificationMessage.value = '';
                            controller.notificationType.value = '';
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
