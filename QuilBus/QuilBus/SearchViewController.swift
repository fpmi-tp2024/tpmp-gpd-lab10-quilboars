//
//  ViewController.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    public var CtxManager: ContextManager!;
    var _localityRepository: LocalityRepository!;

    @IBOutlet weak var beforeDatePicker: UIDatePicker!
    @IBOutlet weak var afterDatePicker: UIDatePicker!
    @IBOutlet weak var timetable: UITableView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var filtersBackground: UIImageView!
    
    var suggestions: [String]! = []
    
    private var cityFrom: String = ""
    private var cityTo: String = ""
    private var beforeDate: Date = Date()
    private var afterDate: Date = Date()
    
    var cal = Calendar.current

    @IBOutlet weak var cityFromLabel: UILabel!
    @IBOutlet weak var cityToLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    
    private var timetableController : TimetableViewController?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ctx = ContextRetriever.RetrieveContext();
        CtxManager = ContextManager(context: ctx);
        _localityRepository = LocalityRepository(contextManager: CtxManager);
       
        filtersBackground.layer.cornerRadius = 20
        filtersBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        searchButton.layer.cornerRadius = 10
        
        timetableController = TimetableViewController(timetable: timetable, errorLabel: errorLabel, usage: .Search)
        timetable.delegate = timetableController!
        timetable.dataSource = timetableController!

        let localities = _localityRepository.GetLocalities()!;
        for locality in localities{
            suggestions.append(locality.name!);
        }
        fromTextField.delegate = self
        toTextField.delegate = self
        
        cal.timeZone = TimeZone(identifier: "UTC")!
        beforeDatePicker.timeZone = TimeZone.init(abbreviation: "UTC")
        afterDatePicker.timeZone = TimeZone.init(abbreviation: "UTC")
        beforeDatePicker.minimumDate = Date()
        afterDatePicker.minimumDate = beforeDatePicker.minimumDate
        beforeDate = Date()
        afterDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        
        cityFromLabel.text = NSLocalizedString("CITY_FROM", comment: "")
        cityToLabel.text = NSLocalizedString("CITY_TO", comment: "")
        fromDateLabel.text = NSLocalizedString("FROM_DATE", comment: "")
        toDateLabel.text = NSLocalizedString("TO_DATE", comment: "")
        searchButton.setTitle(NSLocalizedString("SEARCH", comment: ""), for: .normal)
        fromTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("FROM", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        toTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("TO", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return !autoCompleteText(in: textField, using: string, suggestionsArray: suggestions);
    }
    
    func autoCompleteText(in textField: UITextField, using string: String, suggestionsArray: [String]) -> Bool{
        if !string.isEmpty,
           let selectedTextRange = textField.selectedTextRange,
           selectedTextRange.end == textField.endOfDocument,
           
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestionsArray.filter {
                $0.hasPrefix(prefix)
            }
            
            if (matches.count > 0) {
                textField.text = matches[0]
                
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    
    @IBAction func buttonSearchClicked(_ sender: Any) {
        cityFrom = fromTextField.text!
        cityTo = toTextField.text!

        beforeDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: beforeDatePicker.date)!
        afterDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: afterDatePicker.date)!
        if .orderedSame == cal.compare(beforeDate, to: Date(), toGranularity: .day) {
            beforeDate = Date()
        }
        
        timetableController!.FillTableWithData(beforeDate, afterDate, cityFrom, cityTo)
    }
    
    
}

extension SearchViewController {

    func showToast(message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
 }
