# Weather_app
- git clone https://github.com/quyetvox/weather_app.git
- cd weather_app
- flutter pub get
- flutter run (ios or android)

# Environment Setup
Modify `domain.dart` inside `lib/domain/core/http_client/` if you want and put following environment variables to run the project
```dart
    String baseUrl = "https://api.weatherapi.com/v1/";
    String token = "";
```
# Setup API
Get your keys from following sites
* Weather API : [weatherapi](https://www.weatherapi.com/api-explorer.aspx) 

# Features
- search location name or zip code
- show weather detail
- storage location into localstorage
- delete location in localstorage

# Screenshot
<a href="https://ik.imagekit.io/qavoxs3/weather-app/search_1.png">
<img src="https://ik.imagekit.io/qavoxs3/weather-app/search_1.png" alt="Search Adaptive UI"></a>