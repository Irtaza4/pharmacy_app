# xefag — your daily feel-good

A Flutter shopping prototype extending [Pharmacy Mobile App by Bogdan Nikitin for Nixtio](https://dribbble.com/shots/24632930-Pharmacy-Mobile-App).

## Experience

- Six color-coordinated products: Relax, Sleep, Focus, Energy, Balance, and Glow.
- Bundled Manrope interface font and DM Serif Display wordmark. Font licenses are included in `assets/fonts`.
- Catalog search, category filters, and saved favorites.
- Real Hero bottle transitions between home/catalog/cart and product detail, including reverse navigation.
- Drag a bottle onto the header bag. In the scrolling catalog, hold the bottle briefly before dragging. The bag highlights as a drop target; buttons provide an accessible alternative.
- Animated pack selection, quantity changes, cart badges, screen entrances, and an add-to-bag flight. Major motion respects the system's reduced-motion setting.
- Cart editing, delivery threshold, integer-cent pricing, delivery form validation, standard/express delivery, editable review, and demo order confirmation.

## MVVM structure

- `lib/models`: immutable product, cart-line, and order data.
- `lib/repositories`: the replaceable in-memory shop data source.
- `lib/viewmodels`: catalog filtering, product selection, cart state, checkout validation and order orchestration using `ChangeNotifier`.
- `lib/views`: home, catalog, product, cart, checkout, and confirmation screens.
- `lib/widgets`: reusable controls, artwork, drag targets, and motion.
- `lib/theme`: shared colors, typography, and field styling.

`ShopScope` provides the shared view model; views own and dispose their screen-specific view models. UI state such as animation progress and form focus remains in the views. Monetary values use integer cents. Checkout captures an immutable order before clearing the bag and guards against duplicate submission.

## Run and verify

Run `flutter run` for a device or `flutter run -d chrome` for web. Run `flutter analyze`, `flutter test`, and `flutter build web` to verify. Tests cover catalog search/favorites, Hero navigation, actual drag-and-drop, pack pricing, cart quantities, delivery costs, checkout validation/editing/submission, and a 320px-wide phone layout.

## Demo boundaries

Products, reviews, prices, and delivery estimates are illustrative. Bottles are local vector artwork, not the original renders. No real payment, fulfillment, account sign-in, or backend is connected. Cart, favorites, and delivery details last only for the current app session; refreshing clears them. The demo confirmation does not send email or place a real order.
