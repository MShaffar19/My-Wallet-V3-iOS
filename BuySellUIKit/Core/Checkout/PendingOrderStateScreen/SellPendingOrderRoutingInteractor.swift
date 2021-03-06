//
//  SellPendingOrderRoutingInteractor.swift
//  BuySellUIKit
//
//  Created by Alex McGregor on 8/27/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import BuySellKit
import PlatformKit
import RxRelay
import RxSwift
import ToolKit

public final class SellPendingOrderRoutingInteractor: PendingOrderRoutingInteracting {
    
    private lazy var setup: Void = {
        previousRelay
            .observeOn(MainScheduler.instance)
            .bindAndCatch(to: interactor.previousRelay)
            .disposed(by: disposeBag)
        
        stateRelay
            .observeOn(MainScheduler.instance)
            .bindAndCatch(weak: self) { (self, state) in
                self.handle(state: state)
            }
            .disposed(by: disposeBag)
    }()
    
    public let tapRelay = PublishRelay<URL>()
    public let stateRelay = PublishRelay<PendingOrderState>()
    public let previousRelay = PublishRelay<Void>()
    
    private unowned let interactor: SellRouterInteractor
    private let disposeBag = DisposeBag()
    
    init(interactor: SellRouterInteractor) {
        self.interactor = interactor
        _ = setup
    }
    
    private func handle(state: PendingOrderState) {
        switch state {
        case .pending(let orderDetails):
            interactor.orderPending(with: orderDetails)
        case .completed:
            interactor.orderCompleted()
        }
    }
}
