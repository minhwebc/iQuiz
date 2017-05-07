//
//  ViewController.swift
//  iQuiz
//
//  Created by Quan Nguyen on 4/27/17.
//  Copyright © 2017 Quan Nguyen. All rights reserved.
//

import UIKit
class Category {
    
    public var name : String
    public var description : String
    public var image : String

    public init(_ n : String, _ d : String, _ image : String ){
                self.name = n;
                self.description = d;
                self.image = image;
        
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var table: UITableView!
    
    var dds : TableSource = TableSource();
    var ddd : TableDelegate = TableDelegate();
    var listData = [[String : AnyObject]]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.delegate = ddd;
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
                        self.listData  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            as! [[String : AnyObject]]
                        OperationQueue.main.addOperation {
                            self.table.reloadData();
                            print(self.listData);
                        }
                    }catch let error as NSError{
                        print(error);
                    }
                }
            }).resume()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        performSegue(withIdentifier: "segues", sender: self);
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "YourViewController") as! SubjectViewController
            navigationController?.pushViewController(destination, animated: true)
        }
    }

}

class TableDelegate : NSObject, UITableViewDelegate{
    func tableView(_: UITableView, didSelectRowAt: IndexPath){
        print("selected");
        self.performSegue(withIdentifier: "segues", sender: ViewController.self);
    }
}

var data : [Category] = [Category("Mathematic", "It's fun", "image"), Category("Marvel Super Heroes", "It's exciting", "image"), Category("Science", "It's magical", "image")];

class TableSource : NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                                   reuseIdentifier: "tableViewCell")
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                   reuseIdentifier: "tableViewCell")
        }
        cell?.textLabel?.text = data[indexPath.row].name;
        cell?.detailTextLabel?.text = data[indexPath.row].description;
        let image : UIImage = UIImage(named: data[indexPath.row].image)!;
        cell?.imageView?.image = image;
        return cell!;
    }
    
    
}

