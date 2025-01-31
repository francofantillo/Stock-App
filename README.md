# Stock-App
A demo app for retrieving stock data.

## 1. Setup

The project is straightforward. There is a single SPM dependency that should resolve automatically when you open the project.

In the `Stock_App.swift` file, within the initializer, you will find the following code:

```swift
let mockSession = MockURLSession(testCase: .lengthyTask, nextData: MockReturnData.loadTestData())
```
MockURLSession will simulate an API call. You can change the test case to `.fail400` to simulate an API error.

Beyond that, pressing the "Run" button in Xcode should launch the app.

## 2. Architecture

The app follows the MVVM (Model-View-ViewModel) architecture. There are two view models:

One for managing the array of stocks.
One for holding stock data for each individual cell.
Services are broken up into StockCache and DataService. Additionally, it's worth mentioning that URLSession has been mocked to properly test the HttpClient.

Although there is no navigation in this app, I've laid the groundwork for it in the Stock_App.swift file, which contains a NavigationStack set up to pass the view stack as an environment variable. This makes it easy to add views to the navigation stack via button closures.

## 3. Libraries

I've included a toast library for displaying errors. It's a simple UI library that shouldn't complicate things. I've included it mostly to demonstrate my ability to work with SPM (Swift Package Manager).
