//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Manish Gupta on 10/20/24.
//

import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Get the reference to the location manager
    let clLocationManager = CLLocationManager()

    // Declare the properties that will get populated
    @Published var weatherModel: WeatherModel?
    @Published var zipCodeModel: ZipCodeModel?
    @Published var hourlyModel: HourlyModel?
    @Published var errorModel: ErrorModel?

    var search: String = "11801"
    var searchedStrings = Array<String>()

	/// Adds the search string to the list of searched strings.
    func save(searched text: String) {
        searchedStrings = Fetch.Defaults.fetcExistingWeatherDetails() ?? []
		if (searchedStrings.contains { $0.lowercased() == text.lowercased() } == false) {
			self.searchedStrings.append(text)
			print("current strings: \(searchedStrings)")
			let data = try? JSONEncoder().encode(searchedStrings)
			UserDefaults.standard.setValue(data, forKey: Fetch.Defaults.keyForListOfWeatherCities)
		} else {
			print("This string: \(text) was not saved to user defaults")
		}
    }

    override init() {
        super.init()
        clLocationManager.delegate = self
		Task {
			let request = URLRequest(url: searchedStrings.count != 0 ? URL(string: searchedStrings.last ?? Fetch.defaultCity)! : Fetch.defaultWeather)
			(self.weatherModel, self.errorModel) = await Send<WeatherModel>().networkReq(request)
		}
    }

    func fetchWeatherDetails(lat: Double, lon: Double) {
        let url = Fetch.using(lat: lat, lon: lon)
        let request = URLRequest(url: url)
        Send<WeatherModel>().networkReq(request) { model, err in
            DispatchQueue.main.async {
                self.weatherModel = model
                if let name = model?.name {
                    self.save(searched: name)
                }
				self.errorModel = err
            }
        }
    }

    private func fetchLocation(via manager: CLLocationManager) {
        let lat = manager.location?.coordinate.latitude ?? 0.0
        let lon = manager.location?.coordinate.longitude ?? 0.0

        fetchWeatherDetails(lat: lat, lon: lon)
    }

    func fetchWeather(using zipOrCity: String) async  {
        let url = Fetch.using(zipOrCity: zipOrCity)
        let request = URLRequest(url: url)

        switch zipOrCity.containsNumChars {
        case true:
            (self.zipCodeModel, self.errorModel) = await Send<ZipCodeModel>().networkReq(request)
            let lat = zipCodeModel?.lat ?? 0.0
            let lon = zipCodeModel?.lon ?? 0.0
            let urlGeneral = Fetch.using(lat: lat, lon: lon, reqType: .general)
            let requestG = URLRequest(url: urlGeneral)
            (self.weatherModel, self.errorModel) = await Send<WeatherModel>().networkReq(requestG)
        case false:
            (self.weatherModel, self.errorModel) = await Send<WeatherModel>().networkReq(request)
        }
        if let name = weatherModel?.name {
            save(searched: name)
        }
    }
}

extension WeatherViewModel {
    func locationManager(_ manager: CLLocationManager, 
                         didUpdateLocations locations: [CLLocation]) throws {
        print("didUpdateLocations")
    }

    func locationManager(_ manager: CLLocationManager, 
                         didFailWithError error: any Error) throws {
        print("Failed to obtain location")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("authorizedAlways")
            fetchLocation(via: manager)
        case .notDetermined, .authorizedWhenInUse:
            print("notDetermined")
            clLocationManager.requestAlwaysAuthorization()
            fetchLocation(via: manager)
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        default:
            print("default")
        }
    }
}
