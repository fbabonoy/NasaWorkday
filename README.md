## Description

This application displays a list of NASA posts with images and descriptions.

## Features

- Displays a list of NASA posts with images and descriptions
- Supports pagination to fetch additional posts
- Limits the number of posts displayed to 100
- Displays the date of each post in a formatted string
- Uses a custom navigation view

## Requirements

- iOS 14.0+
- Xcode 14.3

## Installation

1. Clone the repository.
2. Navigate to the project directory in the terminal.
3. Run the command `pod install` to install the CocoaPods dependencies.
4. Open the `.xcworkspace` file to work on the project.

## Usage

1. Open the application.
2. Scroll through the list of NASA posts.
3. Tap a post to view its details.

## Architecture

The application is built using the MVVM (Model-View-ViewModel) architecture pattern. The `Model` layer contains the data models and networking code for retrieving data from the NASA API. The `View` layer contains the user interface components, including the custom `NasaPostView` and `CustomNavigationView`. The `ViewModel` layer contains the logic for handling API requests, pagination, search, and data formatting.

## Libraries

The application uses the following libraries:

- `Kingfisher`: A library for Swift that simplifies image downloading and caching.
- `SwiftLint`: A tool to enforce Swift style and conventions.
- `Combine`: A framework for reactive programming in Swift.
