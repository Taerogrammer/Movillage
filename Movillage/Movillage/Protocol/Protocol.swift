//
//  Protocol.swift
//  Movillage
//
//  Created by 김태형 on 1/24/25.
//

import Foundation

protocol ViewConfiguration: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}

protocol DelegateConfiguration: AnyObject {
    func configureDelegate()
}
