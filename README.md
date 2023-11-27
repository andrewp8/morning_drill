# Morning-Drill app

- An interactive Ruby Sinatra application that fetches a joke, answers your question using ChatGPT, and provides weather advice based on your location.

## Prerequisites

- Ruby installed (version 3.2.1)
- Sinatra gem installed
- API keys for Google Map, weather, and ChatGPT API

## Installation

  1. Clone the repository:

    ```
      git clone https://github.com/andrewp8/morning_drill.git
    ```
  2. Install required gems:

    ```
      bundle install
    ```
  3. Set up API keys:
  - [Joke API](https://geek-jokes.sameerkumar.website/api?format=json) :  key **NOT** required.
  - Checkout [Google Maps API](https://developers.google.com/maps/documentation/geocoding/get-api-key) for more information. Key **required**.
  - Check out [Pirate Weather](https://pirateweather.net/en/latest/) for more information. Key **required**.
    -Checkout [ChatGPT API documentation](https://platform.openai.com/docs/api-reference/making-requests) for more information. Key **required**.
  4. Run the app:
    ```
      bin/dev
    ```
## Usage:
  - Open your browser and navigate to http://localhost:YOUR-PORT

## Contributing

  - Contributions are welcome! Please fork the repository and submit a pull request.
