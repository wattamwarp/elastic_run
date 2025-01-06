import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:flutter/material.dart';

class FutureScopes extends StatelessWidget {
  const FutureScopes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              _buildSectionHeader('On this assumption I made this app'),
              _buildSectionContent(
                  '- After reading the problem statement, I came to know that I have to create an app which has sales and return features with some added inventory.'),
              6.height,
              _buildSectionContent(
                  '- My focus is on the app\'s core architecture, not on the UI or features part because these can be easily built upon concrete requirements.',
                  isSemiBold: true),
              20.height,
              _buildSectionHeader('Future scopes of this app'),
              6.height,
              ..._buildFutureScopeItems([
                'Implement custom flavours',
                'Localisation support',
                'Implementation of factory in POJO classes',
                'Dependency injection by getIt',
                'DB indexing, batch processing, and if required, add isolates',
                'Use of Navigator 2.0 based on exact app requirements (not implemented due to lack of clarity)',
                'As of now, using SQLite, but we have more efficient options available in the market',
                'Not created more wrapper classes due to time constraints',
                'In the future, architecture for API calling, JSON serialization/deserialization, interceptors, and global error handling should be implemented',
                'Implement freezed architecture to easily handle API success/failure without custom checks while processing data',
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return title.boldText(color: ErColor.red,fontSize: 16);

  }

  Widget _buildSectionContent(String content, {bool isSemiBold = false}) {
    return isSemiBold ? content.semiBoldText() : content.normalText();
  }

  List<Widget> _buildFutureScopeItems(List<String> items) {
    return items
        .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: item.normalText(),
            ))
        .toList();
  }
}
