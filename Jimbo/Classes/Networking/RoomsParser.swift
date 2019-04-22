//
//  RoomsParser.swift
//  RoomBooking
//
//  Created by Alexander Polovinka on 2/13/19.
//  Copyright © 2019 Alexplv. All rights reserved.
//

import Foundation

class RoomsParser : ParserProtocol {

    let queue = DispatchQueue(label: "RoomsParser")

    struct Keys {
        static let name = "name"
        static let location = "location"
        static let equipment = "equipment"
        static let size = "size"
        static let capacity = "capacity"
        static let avail = "avail"
        static let images = "images"
    }

    let date: Double

    required init(date: Double) {
        self.date = date
    }

    func parse(_ data: Any?, completion: @escaping (Result<Any>) -> ()) {

        guard let data = data as? Array<Any> else {
            completion(Result.failure(ParserError.invalidData))
            return
        }

        self.queue.async {

            var result: [Room] = []

            // Loop through each item and map it into Model entity
            for (idx, item) in data.enumerated() {
                if let room = self.parse(item: item, index: idx) {
                    result.append(room)
                }
            }

            DispatchQueue.main.async {
                completion(Result.success(result))
            }

        }
    }

    // Parse feed item
    private func parse(item: Any, index: Int) -> Room? {

        guard let item = item as? [String: Any] else {
            return nil
        }

        return Room.init(avail: self.parse(availability: item[Keys.avail]),
                         capacity: NSNumber.from(value: item[Keys.capacity])?.intValue ?? 0,
                         equipment: item[Keys.equipment] as? [String],
                         images: self.parse(images: item[Keys.images] as? [String]),
                         location: item[Keys.location] as? String,
                         name: item[Keys.name] as? String,
                         size: self.parse(size: item[Keys.size]) ?? 0,
                         order: index)
    }

    private func parse(images: [String]?) -> [String] {
        guard let images = images else {
            return []
        }
        return images.map {
            link -> String in
            Configurations.Networking.baseURLString + Configurations.Networking.baseURLPathString + "/" + link
        }
    }

    // Parse item size value
    private func parse(size: Any?) -> Int? {
        guard let size = size as? String else {
            return nil
        }
        let numbers = size.components(separatedBy: CharacterSet.decimalDigits.inverted)
        if let number = numbers.first {
            return NSNumber.from(value:number)?.intValue
        }
        return nil
    }

    // Parse item aval value
    private func parse(availability: Any?) -> [[Double]]? {
        guard let values = availability as? [String] else {
            return nil
        }

        var result:[[Double]] = []

        for (_, item) in values.enumerated() {

            let components = item.components(separatedBy: " - ")
            guard components.count == 2 else {
                continue
            }

            if let from = Date.timeInterval(from: components.first!),
                let to = Date.timeInterval(from: components.last!) {

                let fromHrs = from/60/60
                let toHrs = to/60/60

                result.append([fromHrs, toHrs])
            }
        }

        return result
    }

}

