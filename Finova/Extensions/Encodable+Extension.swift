//
//  Encodable+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation

extension Encodable {
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
