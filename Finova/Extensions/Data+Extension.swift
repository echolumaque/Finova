//
//  Data+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 5/2/25.
//

import Foundation

extension Data {
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        try? JSONDecoder().decode(type, from: self)
    }
}
