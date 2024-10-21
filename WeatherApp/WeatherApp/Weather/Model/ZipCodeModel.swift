//
//  ZipCodeModel.swift
//  WeatherApp
//
//  Created by Manish Gupta on 10/19/24.
//

import Foundation

struct ZipCodeModel: Decodable, Hashable {
	let zip: String?
	let name: String?
	let lat: Double?
	let lon: Double?
	let country: String?
}
