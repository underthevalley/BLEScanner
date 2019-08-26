//
//  DeviceDetailsViewModel.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import Foundation
import RxSwift

class DeviceDetailsViewModel: NSObject {

    private var deviceCharacteristic = Variable<[DeviceCharateristic]>([])
    private let connectionManager: ConnectionManager!
    var disposeBag: DisposeBag!
    var device: Device!

    var characteristics: Observable<[DeviceCharateristic]> {
        return deviceCharacteristic.asObservable()
    }

    init(device: Device, disposeBag: DisposeBag) {
        self.connectionManager = ConnectionManager.share
        self.device = device
        self.disposeBag = disposeBag
        super.init()
        fetchCharacteristics()
    }

    func connect(device: Device) {
        connectionManager.connect(peripheral: device.peripheral)
    }

    private func fetchCharacteristics() {
        connectionManager.publishDeviceCharacteristic.subscribe(onNext: { [weak self] deviceCharateristic in
            guard let strongSelf = self else { return }
            strongSelf.deviceCharacteristic.value.append(deviceCharateristic)
        })
        .disposed(by: disposeBag)
    }
}
