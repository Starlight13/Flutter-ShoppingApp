import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/models/circle_transition_arguments.dart';
import 'package:shopping_app/screens/product_details_screen/product_details_screen.dart';
import 'package:shopping_app/screens/shared_components/favourite_button.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/favourites_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';

class FavouritesScreen extends StatelessWidget {
  static String id = 'favourites_screen';
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesViewModel = context.watch<IFavouritesViewModel>();
    final localizations = AppLocalizations.of(context)!;
    if (favouritesViewModel.state.value == ViewModelState.success) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              favouritesViewModel.successMessage ??
                  localizations.operationSucces,
            ),
            backgroundColor: Colors.teal,
          ),
        );
        favouritesViewModel.resetState();
      });
    } else if (favouritesViewModel.state.value == ViewModelState.error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              favouritesViewModel.errorMessage ?? localizations.somethingWrong,
            ),
            backgroundColor: Colors.red,
          ),
        );
        favouritesViewModel.resetState();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favourites),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: favouritesViewModel.favourites?.length ?? 0,
                  itemBuilder: ((context, index) {
                    final product =
                        favouritesViewModel.favourites?[index].product;
                    return (product == null)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Slidable(
                              key: ValueKey(product.id),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.2,
                                dismissible: DismissiblePane(
                                  dismissThreshold: 0.9,
                                  onDismissed: () {
                                    favouritesViewModel
                                        .removeFavourite(product);
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
                                    foregroundColor:
                                        Colors.red.withOpacity(0.8),
                                    icon: Icons.delete,
                                  ),
                                ],
                              ),
                              child: Builder(
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        ProductDetailsScreen.id,
                                        // arguments: product.id,
                                        arguments: CircleTransitionArguments(
                                          product: product,
                                          circleStartCenter: Offset(
                                            constraints.maxWidth / 2,
                                            constraints.maxHeight / 2,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          width: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            child: CachedNetworkImage(
                                              imageUrl: product.thumbnail,
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
                                                product.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                product.description,
                                                style: descriptionTextStyle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '\$${product.price}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  FavouriteButton(
                                                    onPressed: () {
                                                      Slidable.of(context)
                                                          ?.dismiss(
                                                        ResizeRequest(
                                                          const Duration(
                                                            milliseconds: 300,
                                                          ),
                                                          () => favouritesViewModel
                                                              .removeFavourite(
                                                            product,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    conditionRed: true,
                                                    conditionLoading: false,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                  }),
                ),
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: favouritesViewModel.isLoading
                        ? Container(
                            color: Colors.white.withOpacity(0.5),
                            child: const CenteredProgressIndicator(),
                          )
                        : null,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
