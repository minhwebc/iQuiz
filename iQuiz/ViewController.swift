//
//  ViewController.swift
//  iQuiz
//
//  Created by Quan Nguyen on 4/27/17.
//  Copyright © 2017 Quan Nguyen. All rights reserved.
//

import UIKit
var dataDownloaded : [Category] = [Category]();

class Category {
    
    public var name : String
    public var description : String
    public var image : String
    public var questions : [Question];

    public init(_ n : String, _ d : String, _ image : String, _ questions : [Question]){
                self.name = n;
                self.description = d;
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

class ViewController: UIViewController, UITableViewDelegate{
    
    
    @IBOutlet weak var table: UITableView!
    var valueToPass:Category!
    var dds : TableSource = TableSource();
    var listData = [[String : AnyObject]]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        table.delegate = self;
        table.dataSource = dds;
        downloadJson(url : "https://tednewardsandbox.site44.com/questions.json");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func settingClicked(_ sender: Any) {
        let alert = UIAlertController(title: title,
                                      message: "Settings go here",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction);
        self.present(alert, animated: true);
    }
    
    
    func downloadJson(url : String){
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
        cell?.detailTextLabel?.text = dataDownloaded[indexPath.row].description;
        let image : UIImage = UIImage(named: dataDownloaded[indexPath.row].image)!;
        cell?.imageView?.image = image;
        return cell!;
    }
    
    
}

