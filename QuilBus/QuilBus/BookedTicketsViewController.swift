//
//  BookedTicketsViewController.swift
//  QuilBus
//
// Created by Michael Romanov on 5/29/24.
//

import UIKit

class BookedTicketsViewController: UIViewController {
    fileprivate let CELL_ID = "CELL_ID"
    fileprivate var items = [Ride]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var yourTicketsLabel: UILabel!
    
    private var timetableController : TimetableViewController?  = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timetableController = TimetableViewController(timetable: tableView, errorLabel: errorLabel, usage: .Booked)
        tableView.delegate = timetableController
        tableView.dataSource = timetableController
        timetableController!.FillTableBookedTickets(UserContext.CurrentUser)
        
        yourTicketsLabel.text = NSLocalizedString("YOUR_TICKETS", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timetableController!.FillTableBookedTickets(UserContext.CurrentUser)
    }
}
