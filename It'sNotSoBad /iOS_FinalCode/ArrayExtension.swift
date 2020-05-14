//
//  ArrayExtension.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/10/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}
