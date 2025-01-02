# APOD - Astronomy Picture of the Day

A Flutter mobile application that displays NASA's Astronomy Picture of the Day. Get daily doses of stunning space imagery along with expert explanations.

## Features

- Daily updated space imagery from NASA
- Detailed scientific explanations for each image
- Browse through historical APOD entries
- Save favorite images locally

## Getting Started

1. Clone this repository
2. Get your NASA API key from [NASA API Portal](https://api.nasa.gov/)
3. Create a `env/env.json` file in the project root and add your API key:
   ```
   NASA_API_KEY=your_api_key_here
   ```
4. Run `flutter pub get` to install dependencies
5. Launch the app with `flutter run`

## Dependencies

- flutter_modular: For modular app architecture
- http: For API requests
- cached_network_image: For image caching

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- NASA for providing the APOD API
- [Flutter](https://flutter.dev/) for the amazing framework

## Project Structure

```
lib/
├── app/                          # Application-level configuration
│   ├── app_module.dart          # Main dependency injection module
│   └── app_widget.dart          # Root widget of the application
├── core/                        # Core functionality used across features
├── features/                    # Feature-based modules
└── main.dart                  # Entry point of the application
```

### Directory Structure Explanation

#### App Directory
The `app/` directory contains application-level setup and configuration:
- `app_module.dart`: Handles dependency injection and routing
- `app_widget.dart`: The root widget that sets up theme, navigation, etc.

#### Core Directory
The `core/` directory houses functionality shared across multiple features:

##### API Provider
The API Provider module handles all external API communications:
- `api_provider.dart`: Defines the base contract for API interactions
- Ensures consistent handling of network requests across the application
- Implements error handling and response standardization

##### App Configuration
The `app_configuration/` module manages environment-specific configurations:
- `app_environment.dart`: Handles environment variable access
  - Provides type-safe access to NASA API credentials
  - Manages API endpoint configurations
  - Implements environment variable validation

##### Result Type
The Result module provides a type-safe way to handle operation outcomes:
- `Result<S, E>`: A sealed class representing either success or failure
  - `Success<S, E>`: Holds successful operation data
  - `Failure<S, E>`: Contains error information
  - Built-in utility methods like `fold()`, `getOrElse()`, and `getValueOr()`
- `AsyncResult<S, E>`: Type alias for asynchronous operations returning a Result

##### Storage Provider
The Storage Provider module manages local data persistence:
- `storage_provider.dart`: Defines the interface for storage operations
- `shared_preferences_storage.dart`: Implementation using SharedPreferences
  - Handles JSON serialization/deserialization
  - Provides CRUD operations for key-value storage
  - Type-safe data access with error handling

The `features/` directory contains the main functional modules of the application:

**APOD Feature:**
- `ui/`: UI components and screens
  - Daily astronomy picture display
- `domain/`: Business logic and models
  - APOD data models

**Favorites Feature:**
- `ui/`: UI components and screens
  - Show favorites
- `domain/`: Business logic and models
  - Favorites collection management


Each feature is organized to be self-contained, making it easier to:
- Maintain related code together
- Add new features independently
- Test functionality in isolation
- Scale the application smoothly

## State Management

This project uses a lightweight state management approach based on Flutter's `ValueNotifier`:

### Page States
States are defined using sealed classes to ensure type-safe state handling:
```dart
sealed class ApodPageState {
  const ApodPageState();
}

class ApodPageLoading extends ApodPageState {}
class ApodPageError extends ApodPageState {}
class ApodPageLoadSuccess extends ApodPageState {
  final PictureOfDayEntity pictureOfDay;
  // ...
}
```

### Controllers
Each page has a dedicated controller that extends `ValueNotifier`:
- Manages the page's state transitions
- Handles business logic and data fetching
- Communicates with repositories
- Provides a clean API for UI interactions

Example:
```dart
class ApodPageController extends ValueNotifier<ApodPageState> {
  ApodPageController(this._repository, this._favoritesRepository)
      : super(const ApodPageLoading());

  Future<void> fetchPictureOfDay(PictureOfDayEntity? pictureOfDay) async {
    value = const ApodPageLoading();
    // ... fetch logic ...
  }
}
```

Benefits of this approach:
- Lightweight and built into Flutter
- Easy to test and debug
- Clear separation of concerns
- Type-safe state transitions
- Minimal boilerplate code
