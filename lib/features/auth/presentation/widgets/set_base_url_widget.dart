import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:order_track/core/utils/base_url_manager.dart';
import 'package:order_track/core/utils/size_config.dart';

class SetBaseUrlWidget extends StatelessWidget {
  const SetBaseUrlWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle().copyWith(
            foregroundColor: WidgetStatePropertyAll(Colors.blue[900])),
        onPressed: () async {
          final urlController = TextEditingController();
          final savedUrl = await BaseUrlManager.getBaseUrl();
          if (savedUrl != null) {
            urlController.text = savedUrl;
          }
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  insetPadding: EdgeInsets.symmetric(horizontal: 16.r),
                  title: Text(''), //empty title as placeholder
                  content: SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      controller: urlController,
                      maxLines: null,
                      decoration: InputDecoration(label: Text("Base URL")),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (urlController.text.isNotEmpty) {
                          await BaseUrlManager.saveBaseUrl(urlController.text);
                          Endpoints.initialize();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Base URL saved successfully'),
                            ),
                          );
                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('URL cannot be empty'),
                            ),
                          );
                        }
                      },
                      child: Text('Save'),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Text("setbaseurl"));
  }
}
