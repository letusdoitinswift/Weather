//
//  ErrorModel.swift
//  WeatherApp
//
//  Created by Manish Gupta on 10/19/24.
//

import Foundation

struct ErrorModel: Decodable, Hashable {
	let cod: String?
	let message: String?
}
