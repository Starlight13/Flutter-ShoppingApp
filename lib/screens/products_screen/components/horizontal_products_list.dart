import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/circle_transition_arguments.dart';
import 'package:shopping_app/screens/product_details_screen/product_details_screen.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';

class HorizontalProductsList extends StatefulWidget {
  const HorizontalProductsList({
    required this.category,
    Key? key,
  }) : super(key: key);

  final Category category;

  @override
  State<HorizontalProductsList> createState() => _HorizontalProductsListState();
}

class _HorizontalProductsListState extends State<HorizontalProductsList> {
  double horizontalOffset = 0.0;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          horizontalOffset = _scrollController.position.pixels /
              _scrollController.position.viewportDimension;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ICategoryViewModel>();
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.category.products.length,
      itemBuilder: (context, index) {
        final product = widget.category.products[index];
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTapUp: (details) {
              viewModel.setSelectedCategory(widget.category);
              Navigator.pushNamed(
                context,
                ProductDetailsScreen.id,
                arguments: CircleTransitionArguments(
                  circleStartCenter: details.globalPosition,
                  product: product,
                ),
              );
            },
            child: SizedBox(
              width: 200,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CachedNetworkImage(
                        imageUrl: product.thumbnail,
                        placeholder: ((context, url) {
                          return const CenteredProgressIndicator();
                        }),
                        alignment: Alignment(
                          (horizontalOffset - index * 0.5),
                          0,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    product.description,
                    style: descriptionTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
