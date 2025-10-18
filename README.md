# Pet App

A modern Flutter application for pet lovers, built with clean architecture principles and Test-Driven Development (TDD).

## Project Overview

This Pet App is designed to showcase best practices in Flutter development, including:

- **Clean Architecture**: Separation of concerns with distinct layers
- **Test-Driven Development**: Writing tests before implementation
- **Dependency Injection**: Using GetIt for service locator pattern
- **State Management**: Implementing BLoC pattern with flutter_bloc
- **Error Handling**: Functional programming with Either type from dartz

## Why TDD Approach?

Test-Driven Development offers several advantages for this project:

1. **Higher Code Quality**: Writing tests first ensures that code meets requirements
2. **Better Design**: TDD encourages modular, loosely coupled architecture
3. **Regression Prevention**: Tests catch issues when making changes
4. **Documentation**: Tests serve as living documentation of expected behavior
5. **Confidence**: Developers can refactor with confidence knowing tests will catch regressions

## Project Structure

The project follows a feature-first organization with clean architecture principles:

```
lib/
├── core/                 # Core functionality used across features
│   ├── error/            # Error handling (exceptions, failures)
│   ├── network/          # Network connectivity
│   └── usecases/         # Base usecase definitions
│
├── features/             # Application features
│   ├── details/          # Pet details feature
│   │   ├── data/         # Data layer (repositories, models, sources)
│   │   ├── domain/       # Domain layer (entities, usecases)
│   │   └── presentation/ # UI layer (pages, widgets, blocs)
│   ├── favorite/         # Favorites feature
│   ├── home/             # Home screen feature
│   └── onboarding/       # Onboarding feature
│
└── main.dart            # Application entry point
```

### Clean Architecture Layers

1. **Presentation Layer**: UI components, BLoCs for state management
2. **Domain Layer**: Business logic, use cases, entities
3. **Data Layer**: Repositories, data sources, models

## Testing Strategy

The project implements comprehensive testing across all layers:

- **Unit Tests**: Testing individual components in isolation
- **Widget Tests**: Testing UI components
- **Integration Tests**: Testing interactions between components

Test fixtures are used to provide consistent test data across test cases.

## Key Dependencies

- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **dartz**: Functional programming
- **equatable**: Value equality
- **mockito**: Mocking for tests
- **internet_connection_checker**: Network connectivity
- **retrofit**: Type-safe HTTP client
- **go_router**: Navigation

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter test` to execute tests
4. Run `flutter run` to start the application

## Development Workflow

1. Write failing tests for new features
2. Implement the feature until tests pass
3. Refactor while keeping tests green
4. Repeat for next feature

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Test-Driven Development](https://www.agilealliance.org/glossary/tdd/)
