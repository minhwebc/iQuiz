//
//  ViewController.swift
//  iQuiz
//
//  Created by Quan Nguyen on 4/27/17.
//  Copyright © 2017 Quan Nguyen. All rights reserved.
//

import UIKit
import SystemConfiguration

var dataDownloaded : [Category] = [Category]();

class Category : NSObject{
    
    public var name : String
    public var desc: String
    public var image : String
    public var questions : [Question];
    
    public init(_ n : String, _ d : String, _ image : String, _ questions : [Question]){
        self.name = n;
        self.desc = d;
        self.image = image;
        self.questions = questions;
    }
}

class Question{
    public var answer : Int64
    public var answers : [String]
    public var text : String
    
    public init(_ answer : Int64, _ answers : [String], _ text : String){
        self.answer = answer;
        self.answers = answers;
        self.text = text;
    }
}

func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

class ViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet var newWordField: UITextField?
    @IBOutlet weak var table: UITableView!
    var valueToPass:Category!
    var dds : TableSource = TableSource();
    var listData = [[String : AnyObject]]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        table.delegate = self;
        table.dataSource = dds;
        if isInternetAvailable() {
            if(newWordField?.text == nil){
                downloadJson(url : "https://tednewardsandbox.site44.com/questions.json");
            }else{
                downloadJson(url: (newWordField?.text)!);
            }
        }else{
            if(dataDownloaded.count == 0){
                for element in UserDefaults.standard.dictionaryRepresentation() {
                    if(element.key == "Science!" || element.key == "Mathematics" || element.key == "Marvel Super Heroes"){
                        var subject = element.value as! [String : AnyObject]
                        var title : String = "";
                        if let name = subject["title"] as? String {
                            title = name;
                        }
                        
                        var description : String = "";
                        if let desc = subject["desc"] as? String {
                            description = desc;
                        }
                        var questions = [Question]();
                        if let listQuestion = subject["questions"] as? [[String : AnyObject]] {
                            for question in listQuestion{
                                
                                var text : String = "";
                                if let name = question["text"] as? String {
                                    text = name;
                                }
                                var answer : Int64 = 0;
                                if let desc = question["answer"] as? Int64 {
                                    answer = desc;
                                }
                                var answersRecorded : [String] = [String]();
                                if let listAnswer = question["answers"] as? [String] {
                                    for answer in listAnswer{
                                        answersRecorded.append(answer);
                                    }
                                }
                                questions.append(Question(answer, answersRecorded,text));
                                var hasSubject = false;
                                for data in dataDownloaded{
                                    if(data.name == title){
                                        hasSubject = true;
                                    }
                                }
                                if(!hasSubject){
                                    dataDownloaded.append(Category(title, description, "image", questions));
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func wordEntered(alert: UIAlertAction!){
        // store the new word
        downloadJson(url : (self.newWordField?.text!)!);
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Link goes here"
        self.newWordField = textField
    }
    
    
    @IBAction func settingClicked(_ sender: Any) {
        // display an alert
        let newWordPrompt = UIAlertController(title: "Enter", message: "Enter a link to download the quiz from", preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: addTextField)
        newWordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        newWordPrompt.addAction(UIAlertAction(title: "Check out", style: UIAlertActionStyle.default, handler: wordEntered))
        present(newWordPrompt, animated: true, completion: nil)
    }
    
    func downloadJson(url : String){
        let defaults = UserDefaults.standard;
        DispatchQueue.global().async {
            let urlRequest = URL(string : url)
            URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    NSLog("something went wrong");
                }else{
                    do{
                        dataDownloaded.removeAll();
                        self.listData  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            as! [[String : AnyObject]]
                        for subject in self.listData{
                            var title : String = "";
                            if let name = subject["title"] as? String {
                                title = name;
                            }
                            
                            var description : String = "";
                            if let desc = subject["desc"] as? String {
                                description = desc;
                            }
                            var questions = [Question]();
                            if let listQuestion = subject["questions"] as? [[String : AnyObject]] {
                                for question in listQuestion{
                                    
                                    var text : String = "";
                                    if let name = question["text"] as? String {
                                        text = name;
                                    }
                                    var answer : Int64 = 0;
                                    if let desc = question["answer"] as? Int64 {
                                        answer = desc;
                                    }
                                    var answersRecorded : [String] = [String]();
                                    if let listAnswer = question["answers"] as? [String] {
                                        for answer in listAnswer{
                                            answersRecorded.append(answer);
                                        }
                                    }
                                    questions.append(Question(answer, answersRecorded,text));
                                }
                            }
                            defaults.set(subject, forKey: title);
                            dataDownloaded.append(Category(title, description, "image", questions));
                        }
                        OperationQueue.main.addOperation {
                            self.table.reloadData();
                        }
                        
                        
                    }catch let error as NSError{
                        print(error);
                    }
                }
            }).resume()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        
        self.valueToPass = dataDownloaded[indexPath.row];
        performSegue(withIdentifier: "segue", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var viewController = segue.destination as! SubjectViewController
            let destination = storyboard.instantiateViewController(withIdentifier: "YourViewController") as! SubjectViewController
            viewController.passedValues = self.valueToPass;
            navigationController?.pushViewController(destination, animated: true)
        }
    }
}


class TableSource : NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDownloaded.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                                    reuseIdentifier: "tableViewCell")
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                   reuseIdentifier: "tableViewCell")
        }
        cell?.textLabel?.text = dataDownloaded[indexPath.row].name;
        cell?.detailTextLabel?.text = dataDownloaded[indexPath.row].desc;
        let image : UIImage = UIImage(named: dataDownloaded[indexPath.row].image)!;
        cell?.imageView?.image = image;
        return cell!;
    }
    
    
}

