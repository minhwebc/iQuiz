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

    @IBAction func settingClicked(_ sender: Any) {
        let alert = UIAlertController(title: title,
                                      message: "Settings go here",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction);
        self.present(alert, animated: true);
    }
    @IBOutlet weak var table: UITableView!
    var dds : TableSource = TableSource();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = dds;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var image : UIImage = UIImage(named: data[indexPath.row].image)!;
        cell?.imageView?.image = image;
        return cell!;
    }
}
