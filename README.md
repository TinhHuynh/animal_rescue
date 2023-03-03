# Animal Rescue

Animal Rescue is a Flutter application designed for animal rescue, exclusively available on the Android operating system. 
The application follows the Domain Driven Design pattern for application architecture and utilizes the Bloc state management framework. 
The application also leverages various Firebase services, such as authentication, storage, and Firestore; also other services such as Google Map, Firestore.

# Screenshots

<img src="https://raw.githubusercontent.com/TinhHuynh/animal_rescue/main/screenshots/Screenshot_1.png" width="250" height="527">&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/TinhHuynh/animal_rescue/main/screenshots/Screenshot_2.png" width="250" height="527">&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/TinhHuynh/animal_rescue/main/screenshots/Screenshot_3.png" width="250" height="527">
<img src="https://raw.githubusercontent.com/TinhHuynh/animal_rescue/main/screenshots/Screenshot_4.png" width="250" height="527">&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/TinhHuynh/animal_rescue/main/screenshots/Screenshot_5.png" width="250" height="527">

# Installation

1. If you're new to Flutter the first thing you'll need is to follow the [setup instructions](https://flutter.dev/docs/get-started/install).
2. Set up services: please check Firebase Initialization and Google Map Initialization section below.
3. run code generators:
* `sh scripts/flutter_gen.sh`
* `sh scripts/launcher_icons.sh`
* `sh scripts/splash_screens.sh`
4. Once done, you're ready to run the app on your local device or simulator:
* `flutter run -d android`

### Firebase Initialization

To initialize Firebase for the application, follow the [Firebase setup guide](https://firebase.google.com/docs/flutter/setup?platform=android#available-plugins) for Android.

### Google Map Initialization

To initialize Google Map for the application, follow the [Google Map setup guide](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter) for Android.

### Additional information

* [Domain Driven Design](https://www.youtube.com/watch?v=RMiN59x3uH0&list=PLB6lc7nQ1n4iS5p-IezFFgqP6YvAJy84U&ab_channel=ResoCoder)
* [Bloc/Cubit - State Management Framework](https://pub.dev/packages/flutter_bloc)

You may install these plugins for your IDE: 
* [Flutter Intl](https://plugins.jetbrains.com/plugin/13666-flutter-intl)
* [Flutter Toolkit](https://plugins.jetbrains.com/plugin/14442-flutter-toolkit)

# Contributing

Contributions to Animal Rescue are always welcome! If you would like to contribute to the project, please follow these guidelines:
1. Fork the project.
2. Create your feature branch: git checkout -b feature/your-feature-name.
3. Commit your changes: git commit -am 'Add some feature'.
4. Push the branch to your fork: git push origin feature/your-feature-name.
5. Submit a pull request.

# License

This application is released under the [MIT license](LICENSE). You can use the code for any purpose, including commercial projects.

[![license](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)