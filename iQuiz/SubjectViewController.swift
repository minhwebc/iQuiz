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
    private var answerIndex : Int!;
    var numberOfRighAnswer : Int = 0;
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer4: UILabel!
    @IBOutlet weak var answer3: UILabel!
    @IBOutlet weak var answer2: UILabel!
    @IBOutlet weak var answer1: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var answerField: UILabel!
    @IBOutlet weak var message: UILabel!
    public var passedValues : Category!;
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = passedValues.questions[index].text;
        answer1.text = passedValues.questions[index].answers[3];
        answer2.text = passedValues.questions[index].answers[2];
        answer3.text = passedValues.questions[index].answers[1];
        answer4.text = passedValues.questions[index].answers[0];
        nextButton.isEnabled = false;
        answerField.text = "Your answer is :";
        message.text = "";
        answer.text = "";
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func clickFirstAnswer(_ sender: Any) {
        answerIndex = 0;
        answerField.text = "Your answer is : \(passedValues.questions[index].answers[0])";
    }
    @IBAction func clickSecondAnswer(_ sender: Any) {
        answerIndex = 1;
        answerField.text = "Your answer is : \(passedValues.questions[index].answers[1])";
    }
    @IBAction func clickThirdAnswer(_ sender: Any) {
        answerIndex = 2;
        answerField.text = "Your answer is : \(passedValues.questions[index].answers[2])";
    }
    @IBAction func clickFourthAnswer(_ sender: Any) {
        answerIndex = 3;
        answerField.text = "Your answer is : \(passedValues.questions[index].answers[3])";
    }
    @IBAction func clickSubmit(_ sender: Any) {
        question.text = "";
        answer1.text = "";
        answer2.text = "";
        answer3.text = "";
        answer4.text = "";
        answerField.text = "";
        let answerInt : Int = Int(passedValues.questions[index].answer);
        print(answerInt);
        if(answerIndex != answerInt){
            message.text = "Wrong answer";
        }else{
            numberOfRighAnswer += 1;
            message.text = "Right answer";
        }
        answer1Button.isHidden = true;
        answer2Button.isHidden = true;
        answer3Button.isHidden = true;
        answer4Button.isHidden = true;
        answer.text = "The answer is : " + passedValues.questions[self.index].answers[Int(passedValues.questions[self.index].answer)];
        nextButton.isEnabled = true;
        submitButton.isEnabled = false;
    }
    @IBAction func clickNext(_ sender: Any) {
        message.text = "";
        answer.text = "";
        index += 1;
        if(index > passedValues.questions.count - 1){
            answer.text = "End of the quiz. You got \(numberOfRighAnswer) question(s) right";
            nextButton.isEnabled = false;
            submitButton.isEnabled = false;
        }else{
            answer1Button.isHidden = false;
            answer2Button.isHidden = false;
            answer3Button.isHidden = false;
            answer4Button.isHidden = false;
            question.text = passedValues.questions[index].text;
            answer1.text = passedValues.questions[index].answers[3];
            answer2.text = passedValues.questions[index].answers[2];
            answer3.text = passedValues.questions[index].answers[1];
            answer4.text = passedValues.questions[index].answers[0];
            answer.text = "";
            submitButton.isEnabled = true;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class AnswerDataSource : NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
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
