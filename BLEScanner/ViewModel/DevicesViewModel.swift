//
//  DevicesViewModel.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

class DevicesViewModel: NSObject {

    private var devicesVariable = Variable<[Device]>([])
    private var centralManagerStateVariable = Variable<Bool>(false)
    private let connectionManager: ConnectionManager!
    var disposeBag: DisposeBag!

    var devices: Observable<[Device]> {
        return devicesVariable.asObservable()
    }

    var centralState: Observable<Bool> {
        return centralManagerStateVariable.asObservable()
    }

     init(disposeBag: DisposeBag) {
        self.connectionManager = ConnectionManager.share
        self.disposeBag = disposeBag
        super.init()
        fetchDevices()
        centralStateObservable()
    }

    func scanDevices(stop: Bool = false) {
        if stop {
            connectionManager.stopScanDevices()
        }

        connectionManager.scanDevices()
        UIApplication.shared.isNetworkActivityIndicatorVisible = !stop
    }

    private func fetchDevices() {
        connectionManager.publishDevice.subscribe(onNext: { [weak self] device in
            guard let strongSelf = self else { return }
            if strongSelf.devicesVariable.value.contains(where: { $0.name == device.name }) == false {
                strongSelf.devicesVariable.value.append(device)
            }

        })
        .disposed(by: disposeBag)
    }

    private func centralStateObservable() {
        connectionManager.connectionState.subscribe(onNext: { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.centralManagerStateVariable.value = state == CBManagerState.poweredOn
        })
        .disposed(by: disposeBag)
    }
}
