//
//  MessageViewModelProtocol.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol MessageViewModelProtocol {
    var messages: BehaviorRelay<[Message]> { get }
    var title: BehaviorRelay<String>  { get }
    var lastIndexPath: PublishSubject<IndexPath>  { get }
    var hiddenTextView: PublishSubject<Bool>  { get }
    var disposeBag: DisposeBag  { get }

    
    init(buddy: User)
    func loadStoreMessage()
    func message(at index: Int) -> Message?
    func sendMessage(_ msg: String)
    func updatedLastIndex()
    func hideTextView(_ hidden: Bool)
}

extension MessageViewModelProtocol {
    func hideTextView(_ hidden: Bool = false) {}
}
