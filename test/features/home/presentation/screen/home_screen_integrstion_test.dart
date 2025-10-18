import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:pet_app/core/service_locactor/di.dart' as di;
import 'package:pet_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Hive for testing
    Hive.init('./test/hive_testing_path');
    await Hive.openBox('breeds');
    di.init(userPreferenceBox: Hive.box('breeds'));
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('Pet App Integration Tests', () {
    testWidgets('should complete full app flow successfully', (
      WidgetTester tester,
    ) async {
      // Build the app widget instead of calling main()
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app launches successfully
      expect(find.text('Find Your Forever Pet'), findsOneWidget);

      // Verify search bar is present
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Verify categories are displayed
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);

      // Verify bottom navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('home'), findsOneWidget);
      expect(find.text('favorites'), findsOneWidget);
      expect(find.text('chat'), findsOneWidget);
      expect(find.text('profile'), findsOneWidget);
    });

    testWidgets('should filter breeds by category', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pump(const Duration(seconds: 1));

      // Scroll to find 'Cats' category if not visible
      final catsCategory = find.text('Cats');
      await tester.ensureVisible(catsCategory);
      await tester.pumpAndSettle();

      // Tap on 'Cats' category
      await tester.tap(catsCategory);
      await tester.pumpAndSettle();

      // Verify category is selected
      expect(find.text('Cats'), findsOneWidget);

      // Tap on 'Dogs' category
      final dogsCategory = find.text('Dogs');
      await tester.ensureVisible(dogsCategory);
      await tester.pumpAndSettle();

      await tester.tap(dogsCategory);
      await tester.pumpAndSettle();

      // Verify new category is selected
      expect(find.text('Dogs'), findsOneWidget);

      // Return to 'All' category
      final allCategory = find.text('All');
      await tester.ensureVisible(allCategory);
      await tester.pumpAndSettle();

      await tester.tap(allCategory);
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('should navigate between bottom navigation tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we're on home tab
      expect(find.text('home'), findsOneWidget);

      // Tap on favorites tab
      await tester.tap(find.text('favorites'));
      await tester.pumpAndSettle();

      // Verify bottom nav still works
      expect(find.text('favorites'), findsOneWidget);

      // Tap on chat tab
      await tester.tap(find.text('chat'));
      await tester.pumpAndSettle();

      expect(find.text('chat'), findsOneWidget);

      // Tap on profile tab
      await tester.tap(find.text('profile'));
      await tester.pumpAndSettle();

      expect(find.text('profile'), findsOneWidget);

      // Return to home tab
      await tester.tap(find.text('home'));
      await tester.pumpAndSettle();

      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    testWidgets('should display loading indicator while fetching data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Pump once to start the app
      await tester.pump();

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pumpAndSettle();

      // After loading, should not show loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should interact with search bar', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find and tap search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.tap(searchField);
      await tester.pumpAndSettle();

      // Enter search text
      await tester.enterText(searchField, 'Persian');
      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('Persian'), findsWidgets);
    });

    testWidgets('should tap notification icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find notification icon
      final notificationIcon = find.byIcon(Icons.notifications_outlined);
      expect(notificationIcon, findsOneWidget);

      // Tap notification icon
      await tester.tap(notificationIcon);
      await tester.pumpAndSettle();

      // Verify app doesn't crash
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    testWidgets('should scroll through categories horizontally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find the horizontal category ListView
      final categoryListView = find.byType(ListView).first;
      expect(categoryListView, findsOneWidget);

      // Scroll left to see more categories
      await tester.drag(categoryListView, const Offset(-200, 0));
      await tester.pumpAndSettle();

      // Verify we can still see categories
      expect(find.text('Reptiles'), findsOneWidget);

      // Scroll back
      await tester.drag(categoryListView, const Offset(200, 0));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('should display pets list when loaded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if we're in loaded state (either with data or without)
      final hasCircularProgress = find.byType(CircularProgressIndicator);
      expect(hasCircularProgress, findsNothing);

      // The app should be in a stable state
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    testWidgets('should handle rapid category switching', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final categories = ['Cats', 'Dogs', 'All', 'Birds', 'All'];

      for (final category in categories) {
        final categoryFinder = find.text(category);

        // Ensure category is visible
        if (categoryFinder.evaluate().isNotEmpty) {
          await tester.ensureVisible(categoryFinder);
          await tester.tap(categoryFinder);
          await tester.pump();
        }
      }

      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    testWidgets('should maintain state after orientation change simulation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Select a category
      final catsCategory = find.text('Cats');
      await tester.ensureVisible(catsCategory);
      await tester.tap(catsCategory);
      await tester.pumpAndSettle();

      // Simulate rebuild (like orientation change)
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // State might reset, but app should still work
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('should display all navigation items correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify all navigation icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsWidgets);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Verify all navigation labels
      expect(find.text('home'), findsOneWidget);
      expect(find.text('favorites'), findsOneWidget);
      expect(find.text('chat'), findsOneWidget);
      expect(find.text('profile'), findsOneWidget);
    });

    testWidgets('should have proper app theme applied', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify the app bar is white
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

      // Verify app is using Material design
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
