//
//  DownloadViewController.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import UIKit
import Network
import SwiftSocket

class DownloadViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var imagesTableView: UITableView!

    // MARK: - Variables
    var imagesName = [Int]()
    var shuffledImagesName = [Int]() {
        didSet(newValue) {
            imagesTableView.reloadData()
        }
    }
    var documentController: UIDocumentInteractionController!
    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host = "192.168.4.1"
    var portUDP: NWEndpoint.Port = 4210

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }

    // MARK: - Helper Methods
    private func configure() {
        shuffledImages()
        configureTableView()
    }
    private func shuffledImages() {
        shuffledImagesName.removeAll()
        let counter = UserStorage().getCounter()
        if counter > 3 {
            var number = 1
            number = Int.random(in: 1..<counter)
            shuffledImagesName.append(number)
            number = Int.random(in: 1..<counter)
            shuffledImagesName.append(number)
            number = Int.random(in: 1..<counter)
            shuffledImagesName.append(number)
        } else {
            imagesName = [1, 2, 3]
            shuffledImagesName = imagesName.shuffled()
        }
    }
    private func configureTableView() {
        imagesTableView.delegate = self
        imagesTableView.dataSource = self
        imagesTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        imagesTableView.estimatedRowHeight = 500
        imagesTableView.rowHeight = UITableView.automaticDimension
        imagesTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        imagesTableView.tableHeaderView = UIView()
        imagesTableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
}
// MARK: - TableView Data Source and Deletgate
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shuffledImagesName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
        cell.startDownload(image: shuffledImagesName[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - ImageTableViewCellDelegate
extension DownloadViewController: ImageTableViewCellDelegate {
    func transferThis(image: UIImage) {
        let okAction = UIAlertAction(title: "WhatsApp or Facebook", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            guard let self = self else {return}
            self.shareUsingWhatsApp(image: image)
        })
        let sockets = UIAlertAction(title: "With Sockets", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            guard let self = self else {return}
            self.noServer()
        })
        let tcp = UIAlertAction(title: "With TCP", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            guard let self = self else {return}
            self.connectToTCP()
        })
        let udp = UIAlertAction(title: "With UDP Server", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            guard let self = self else {return}
            self.connectToUDP(self.hostUDP, self.portUDP)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        UIAlertController.showAlert(title: "Share Image", message: "Select the options", actions: [okAction, sockets,tcp, udp, cancel], in: self)

    }
    private func shareUsingWhatsApp(image: UIImage) {
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
    }
    private func noServer() {
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        UIAlertController.showAlert(title: "Alert", message: "We dont have any server server to share images.", actions: [okAction], in: self)
    }
    func connectToTCP() {
        /*
        let client: TCPClient = TCPClient(address: "127.0.0.1", port: 8080)
        var (success,errmsg)=client.connect(timeout: 1)
        if success{
            var (success,errmsg)=client.send(str:"|~\0" )
            if success{
                let data=client.read(1024*10)
                if let d=data{
                    if let str=String(bytes: d, encoding: NSUTF8StringEncoding){
                        print(str)
                    }
                }
            }else{
                print(errmsg)
            }
        }else{
            print(errmsg)
        }
        */
        let client = TCPClient(address: "127.0.0.1", port: 80)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "GET / HTTP/1.0\n\n" ) {
            case .success:
                guard let data = client.read(1024*10) else { return }
                if let response = String(bytes: data, encoding: .utf8) {
                    print("Response",response)
                }
            case .failure(let error):
                print("Failure in Send",error)
            }
        case .failure(let error):
            print("Failre",error)
        }
    }
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:

        let messageToUDP = "7773010509060602040701000001010d0a"
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
            case .ready:
                print("State: Ready\n")
                self.sendUDP(messageToUDP)
                self.receiveUDP()
            case .setup:
                print("State: Setup\n")
            case .cancelled:
                print("State: Cancelled\n")
            case .preparing:
                print("State: Preparing\n")
            default:
                print("ERROR! State not defined!\n")
            }
        }

        self.connection?.start(queue: .global())
    }

    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }

    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    func receiveUDP() {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                } else {
                    print("Data == nil")
                }
            }
        }
    }
}
