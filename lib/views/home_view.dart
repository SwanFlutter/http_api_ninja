import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../controller/http_controller.dart';
import '../widgets/request_builder_widget.dart';
import '../widgets/response_area_widget.dart';
import '../widgets/sidebar_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static Widget _columnResizer(
    BuildContext context,
    ValueChanged<double> onDragDelta,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => onDragDelta(details.delta.dx),
        child: Container(
          width: 4,
          color: Theme.of(context).dividerColor,
          child: Center(
            child: Container(
              width: 2,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // Left: Collections Sidebar (resizable)
              Obx(
                () => SizedBox(
                  width: controller.sidebarWidth.value,
                  child: const SidebarWidget(),
                ),
              ),

              _columnResizer(context, (delta) {
                controller.sidebarWidth.value =
                    (controller.sidebarWidth.value + delta).clamp(200.0, 500.0);
              }),

              // Middle: Request Builder (flexible)
              const Expanded(child: RequestBuilderWidget()),

              _columnResizer(context, (delta) {
                controller.responseAreaWidth.value =
                    (controller.responseAreaWidth.value - delta)
                        .clamp(300.0, 800.0);
              }),

              // Right: Response Area (resizable)
              Obx(
                () => SizedBox(
                  width: controller.responseAreaWidth.value,
                  child: const ResponseAreaWidget(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
