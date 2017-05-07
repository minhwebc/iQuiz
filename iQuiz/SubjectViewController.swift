//
//  SubjectViewController.swift
//  iQuiz
//
//  Created by iGuest on 5/6/17.
//  Copyright © 2017 Quan Nguyen. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController {
    
    private var index : Int = 0;
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer4: UILabel!
    @IBOutlet weak var answer3: UILabel!
    @IBOutlet weak var answer2: UILabel!
    @IBOutlet weak var answer1: UILabel!
    @IBOutlet weak var answer: UILabel!
    public var passedValues : Category!;
    @IBOutlet weak var submitButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        question.text = passedValues.questions[index].text;
        answer1.text = passedValues.questions[index].answers[0];
        answer2.text = passedValues.questions[index].answers[1];
        answer3.text = passedValues.questions[index].answers[2];
        answer4.text = passedValues.questions[index].answers[3];
        nextButton.isEnabled = false;
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        question.text = "";
        answer1.text = "";
        answer2.text = "";
        answer3.text = "";
        answer4.text = "";
        answer.text = passedValues.questions[self.index].answers[Int(passedValues.questions[self.index].answer)];
        nextButton.isEnabled = true;
        submitButton.isEnabled = false
        ;
    }
    @IBAction func clickNext(_ sender: Any) {
        
        index = index + 1;
        if(index > passedValues.questions.count - 1){
            answer.text = "end of questions";
            nextButton.isEnabled = false;
            submitButton.isEnabled = false;
        }else{
            question.text = passedValues.questions[index].text;
            answer1.text = passedValues.questions[index].answers[0];
            answer2.text = passedValues.questions[index].answers[1];
            answer3.text = passedValues.questions[index].answers[2];
            answer4.text = passedValues.questions[index].answers[3];
            answer.text = "";
            submitButton.isEnabled = true;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class AnswerDataSource : NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubjectViewController.passedValues.count;
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
