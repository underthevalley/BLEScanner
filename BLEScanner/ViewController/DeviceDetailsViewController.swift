//
//  DeviceDetailsViewController.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit
import RxSwift

class DeviceDetailsViewController: UIViewController {

    @IBOutlet weak var localNameLbl: UILabel!
    @IBOutlet weak var manufacturerLbl: UILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var characteristicsTableView: UITableView!
    @IBOutlet weak var characteristIndicator: UIActivityIndicatorView!

    var viewModel: DeviceDetailsViewModel!
    var disposeBag: DisposeBag!
    var device: Device!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    private func initialSetup() {
        title = device.name
        disposeBag = DisposeBag()
        viewModel = DeviceDetailsViewModel(device: device, disposeBag: disposeBag)
        configureTableView()
        configureDeviceInformation()
        viewModel.connect(device: device)
        bindCharacteristic()
        subscribeCharacteristic()
        characteristIndicator.startAnimating()
    }

    private func configureTableView() {
        characteristicsTableView.estimatedRowHeight = 60
        characteristicsTableView.rowHeight = UITableViewAutomaticDimension
        characteristicsTableView.tableFooterView = UIView()
        characteristicsTableView.registerCell(CharacteristicCell.self)
    }

    private func configureDeviceInformation() {
        localNameLbl.text = device.name
        manufacturerLbl.text = device.manufacturerData != nil ? device.manufacturerData : "Not available"
        uuidLbl.text = device.uuid
    }

    private func bindCharacteristic() {
        guard let tableView = characteristicsTableView else { return }
        viewModel.characteristics
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "CharacteristicCell", cellType: CharacteristicCell.self)) {
                    row, characteristic, cell in
                    cell.configureCell(deviceCharacteristic: characteristic)
            }
            .disposed(by: disposeBag)
    }

    private func subscribeCharacteristic() {
        viewModel.characteristics.subscribe(onNext: { [weak self] deviceCharacteristics in
            if let strongSelf = self {
                if deviceCharacteristics.isEmpty == false {
                    strongSelf.characteristIndicator.stopAnimating()
                }
            }
        })
        .disposed(by: disposeBag)
    }
}
