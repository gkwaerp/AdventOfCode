//
//  Node.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 08/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

protocol Node {
    var id: String { get }
    var children: [Node] { set get }
    var parent: Node? { set get }
}

extension Node {
    var allParents: [Node] {
        var parents = [Node]()
        var checkingNode = self.parent
        while checkingNode != nil {
            parents.append(checkingNode!)
            checkingNode = checkingNode?.parent
        }
        return parents
    }

    var allChildren: [Node] {
        var allChildren = [Node]()
        for child in self.children {
            allChildren.append(contentsOf: child.allChildren)
        }
        return allChildren
    }
}
