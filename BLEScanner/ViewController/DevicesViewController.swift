//
//  ViewController.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreBluetooth

enum ScanStatus {
    case started
    case stoped
}

class DevicesViewController: UIViewController {

    @IBOutlet weak var devicesTableView: UITableView!
    @IBOutlet weak var scanDevicesBtn: UIBarButtonItem!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var noDevicesView: UIView!

    var viewModel: DevicesViewModel!
    var disposeBag: DisposeBag!
    var segueIdentifier = "DeviceInfoSegue"
    var currentScanStatus: ScanStatus!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.customStyle()
        scanDevicesBtn.textStyle()
    }

    private func initialSetup() {
        title = "BLE Scanner"
        currentScanStatus = .stoped
        disposeBag = DisposeBag()
        viewModel = DevicesViewModel(disposeBag: disposeBag)
        configureTableView()
        bindDevices()
        checkForCentralState()
    }

    private func configureTableView() {
        devicesTableView.estimatedRowHeight = 70
        devicesTableView.rowHeight = UITableViewAutomaticDimension
        devicesTableView.tableFooterView = UIView()
        devicesTableView.registerCell(DeviceCell.self)
    }

    private func bindDevices() {
        guard let tableView = devicesTableView else { return }
        viewModel.devices
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "DeviceCell", cellType: DeviceCell.self)) { [weak self]
                    row, device, cell in
                    self?.noDevicesView.isHidden = true
                    cell.delegate = self
                    cell.configureCell(device: device)
        }
            .disposed(by: disposeBag)
    }

    private func checkForCentralState() {
        viewModel.centralState.subscribe(onNext: { [weak self] state in
            guard let strongSelf = self else { return }
            if state {
                strongSelf.messageLbl.text = "Press scan to show devices in range"
                strongSelf.scanDevicesBtn.isEnabled = true
            } else {
                strongSelf.messageLbl.text = "Please turn on your Bluetooth"
                strongSelf.scanDevicesBtn.isEnabled = true
            }
        })
        .disposed(by: disposeBag)
    }

    @IBAction func scanBtnPressed(_ sender: UIBarButtonItem) {
        if currentScanStatus == .stoped {
            viewModel.scanDevices()
            scanDevicesBtn.title = "Stop"
            currentScanStatus = .started
        } else {
            viewModel.scanDevices(stop: true)
            scanDevicesBtn.title = "Scan"
            currentScanStatus = .stoped
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DeviceDetailsViewController, let sender = sender as? Device else { return }
        destination.device = sender
    }
}

// MARK: DeviceConnectionDelegate
extension DevicesViewController: DeviceConnectionDelegate {

    func connectDevice(device: Device) {
        performSegue(withIdentifier: segueIdentifier, sender: device)
    }
}
