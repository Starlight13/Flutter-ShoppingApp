import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/shared_components/item_counter.dart';
import 'package:shopping_app/screens/shared_components/status_snack_bar.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  static const id = 'cart_screen';

  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ICartViewModel>();
    final localizations = AppLocalizations.of(context)!;

    return StatusSnackBar(
      viewModel: viewModel,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            localizations.cartTitle,
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        localizations.clearCartTitle,
                      ),
                      content: Text(
                        localizations.clearCartContent,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            viewModel.clearCart();
                            Navigator.pop(context);
                          },
                          child: Text(
                            localizations.confirm,
                            style: const TextStyle(color: Colors.teal),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            localizations.cancel,
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.productsCount,
                  itemBuilder: (context, index) {
                    final item = viewModel.productsInCart[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Slidable(
                        key: ValueKey(item.product.id),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.2,
                          dismissible: DismissiblePane(
                            dismissThreshold: 0.9,
                            onDismissed: () {
                              viewModel.removeItemFromCart(cartItem: item);
                            },
                          ),
                          openThreshold: 0.1,
                          closeThreshold: 0.1,
                          children: [
                            SlidableAction(
                              padding: EdgeInsets.zero,
                              spacing: 0,
                              onPressed: (_) {},
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.red.withOpacity(0.8),
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: Builder(
                          builder: (context) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: CachedNetworkImage(
                                      imageUrl: item.product.thumbnail,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        item.product.description,
                                        style: descriptionTextStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${item.product.price}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          ItemCounter(
                                            size: 20.0,
                                            onChange: (newQty) =>
                                                viewModel.changeItemQty(
                                              newQty: newQty,
                                              cartItem: item,
                                            ),
                                            onDelete: () {
                                              Slidable.of(context)?.dismiss(
                                                ResizeRequest(
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  () => viewModel
                                                      .removeItemFromCart(
                                                    cartItem: item,
                                                  ),
                                                ),
                                              );
                                            },
                                            initialCount: item.quantity,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Divider(
                      indent: 0.0,
                      thickness: 2.0,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    Row(
                      children: [
                        Text(
                          '${localizations.total}:',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '\$${viewModel.cartSummary}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
