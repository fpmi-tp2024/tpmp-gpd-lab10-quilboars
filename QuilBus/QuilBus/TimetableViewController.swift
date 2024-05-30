//
//  TimetableView.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import UIKit

class TimetableViewController : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    public var CtxManager: ContextManager!;
    var _userRepository: UserRepository!;
    var _localityRepository: LocalityRepository!;
    var _roureRepository: RouteRepository!;
    var _ridesRepository: RideRepository!;
    var _bookedTicketRepository: BookedTicketRepository!;
    
    var cal = Calendar.current
    
    var timetable: UITableView
    var errorLabel: UILabel
    
    let CELL_ID = "RideTableViewCell"
    var items = [Ride]()
    var sections = [String]()
    var numSections = [Int]()
    
    enum TimetableUsage {
        case Search
        case Booked
    }
    let usage: TimetableUsage
    
    init(timetable: UITableView, errorLabel: UILabel, usage : TimetableUsage) {
        let ctx = ContextRetriever.RetrieveContext();
        CtxManager = ContextManager(context: ctx);
        _localityRepository = LocalityRepository(contextManager: CtxManager);
        _ridesRepository = RideRepository(contextManager: CtxManager);
        _bookedTicketRepository = BookedTicketRepository(contextManager: CtxManager);
        self.usage = usage
        self.timetable = timetable
        self.errorLabel = errorLabel

        cal.timeZone = TimeZone(identifier: "UTC")!
        
        let nib = UINib(nibName: CELL_ID, bundle: nil)
        timetable.register(nib, forCellReuseIdentifier: CELL_ID)
    }
    
    // sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= sections.count {
            return nil
        }
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= numSections.count {
            return 0
        }
        return numSections[section];
    }
    
    // cell clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellForRow = tableView.cellForRow(at: indexPath) else{
            return
        }
        let cell = cellForRow as! RideTableViewCell
        
        tableView.beginUpdates()
        cell.showBookButton()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cellForRow = tableView.cellForRow(at: indexPath) else{
            return
        }
        let cell = cellForRow as! RideTableViewCell

        tableView.beginUpdates()
        cell.hideBookButton()
        tableView.endUpdates()
    }
    
    // appearance
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.indexPathForSelectedRow?.row == indexPath.row {
            return 100;
        } else {
            return 80;
        }
    }
    
    // cell info
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timetable.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! RideTableViewCell
        let item = items[indexPath.row]
        
        if usage == .Search {
            cell.constructFromRide(row: indexPath.row, ride: item, buttonText: "Book", buttonHandler: OnBooking(cell:ride:))
        } else if usage == .Booked {
            cell.constructFromRide(row: indexPath.row, ride: item, buttonText: "Return", buttonHandler: OnCancellingBooking(cell:ride:))
        }
        return cell
    }
    
    func OnBooking(cell : RideTableViewCell, ride: Ride) {
        let user = UserContext.CurrentUser
        _bookedTicketRepository.BookTicket(user: user!, ride: ride)
        if (ride.availableTickets <= 0) {
            cell.cellButton.isEnabled = false
        }
    }
    
    func OnCancellingBooking(cell : RideTableViewCell, ride: Ride) {
        let user = UserContext.CurrentUser
        _bookedTicketRepository.UnBookTicket(user: user!, ride: ride)
        FillTableBookedTickets(user!)
    }
    
    public func FillTableBookedTickets(_ user: User) {
        let data = _bookedTicketRepository.GetBookedTicketsByUserLogin(login: user.login!)
        
        errorLabel.text = ""
        sections.removeAll()
        numSections.removeAll()
        items.removeAll()
        if data == nil {
            errorLabel.text = "Internal error"
            return
        }
        if data!.isEmpty {
            errorLabel.text = "You haven't booked tickets yet"
            return
        }
        
        var rides = [Ride]()
        for ticket in data! {
            rides.append(ticket.ride!)
        }
        
        UpdateData(rides)
    }
    
    public func FillTableWithData(_ beforeDate: Date, _ afterDate: Date, _ cityFromName: String, _ cityToName : String){
        let cityFrom = _localityRepository.GetLocalityByName(name: cityFromName)
        let cityTo = _localityRepository.GetLocalityByName(name: cityToName)

        errorLabel.text = ""
        sections.removeAll()
        numSections.removeAll()
        items.removeAll()
        timetable.reloadData()
        if cityFrom == nil || cityTo == nil {
            errorLabel.text = NSLocalizedString("INTERNAL_ERROR", comment: "")
            return
        }
        if cityFrom!.isEmpty {
            errorLabel.text = NSLocalizedString("FROM_NOT_FOUND", comment: "")
            return
        }
        if cityTo!.isEmpty {
            errorLabel.text = NSLocalizedString("TO_NOT_FOUND", comment: "")
            return
        }
        
        let data = _ridesRepository.GetRides(from: beforeDate, to: afterDate, fromLocality: cityFrom!.first!, toLocality: cityTo!.first!)
        if data == nil{
            errorLabel.text = NSLocalizedString("INTERNAL_ERROR", comment: "")
            return
        }
        if data!.isEmpty {
            errorLabel.text = NSLocalizedString("NO_RESULTS_FOUND", comment: "")
            return
        }
        
        UpdateData(data)
    }
    
    private func UpdateData(_ data: [Ride]?) {
        var curCount = 0
        var curDate : Date = data![0].departureTime!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.timeZone = cal.timeZone
        
        
        for ride in data! {
            if .orderedSame != cal.compare(curDate, to: ride.departureTime!, toGranularity: .day) {
                sections.append(dateFormatter.string(from: curDate)) // add name for a prev section
                numSections.append(curCount) // add rows count for a prev section
                curCount = 1
                curDate = ride.departureTime!
            } else {
                curCount += 1
            }
        }
        sections.append(dateFormatter.string(from: curDate)) // add last section
        numSections.append(curCount) // add last section
        
        items = data!
        DispatchQueue.main.async {
           self.timetable.reloadData()
        }
    }
}
