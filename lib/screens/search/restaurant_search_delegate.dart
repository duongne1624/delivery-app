import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';

class RestaurantSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Tìm kiếm nhà hàng...';

  @override
  TextInputType get keyboardType => TextInputType.text;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    if (query.isEmpty) return const Center(child: Text('Nhập từ khóa...'));

    return FutureBuilder(
      future: DioService.instance.get('/restaurants/search', queryParameters: {'keyword': query}),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final List data = snapshot.data!.data['data'];
        final results = data.map((e) => RestaurantModel.fromJson(e)).toList();

        if (results.isEmpty) return const Center(child: Text('Không tìm thấy nhà hàng'));

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (_, i) {
            final r = results[i];
            return ListTile(
              leading: Image.network(r.image, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(r.name),
              subtitle: Text(r.address),
              onTap: () {
                // TODO: Navigate to restaurant detail
              },
            );
          },
        );
      },
    );
  }
}
