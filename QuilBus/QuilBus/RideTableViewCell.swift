//
//  RideTableViewCell.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import UIKit

class RideTableViewCell: UITableViewCell {
    public var CtxManager: ContextManager!;
    var _bookedTicketRepository: BookedTicketRepository!;
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dashedLine: UILabel!
    
    var onButtonClick : ((RideTableViewCell, Ride) -> ())? = nil
    
    var ride: Ride? = nil
    var row : Int = -1
    
    public func constructFromRide(row: Int, ride: Ride, buttonText: String, buttonHandler: @escaping (RideTableViewCell, Ride) -> ()) {
        let ctx = ContextRetriever.RetrieveContext();
        CtxManager = ContextManager(context: ctx);
        _bookedTicketRepository = BookedTicketRepository(contextManager: CtxManager);
        self.row = row
        self.ride = ride
        self.cellButton.setTitle(buttonText, for: .normal)
        self.onButtonClick = buttonHandler
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        departureLabel.text = dateFormatter.string(from: ride.departureTime!)
        arrivalLabel.text  = dateFormatter.string(from: ride.arrivalTime!)
        durationLabel.text = String(ride.duration) + " min"
        priceLabel.text = String(format: "%.2fр", ride.price)
        hideBookButton()
    }
    
    public func showBookButton() {
        UIView.animate(withDuration: 0.5) {
            self.cellButton.alpha = 1
            self.cellButton.isHidden = false
        }
        self.cellButton.isEnabled = ride!.availableTickets > 0
    }
    
    public func hideBookButton() {
        UIView.animate(withDuration: 0.5) {
            self.cellButton.alpha = 0
            self.cellButton.isHidden = true
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if let callback = onButtonClick {
          callback(self, ride!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
