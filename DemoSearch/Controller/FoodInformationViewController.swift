//
//  FoodInformationViewController.swift
//  DemoSearch
//
//  Created by Gemma Jing on 08/11/2017.
//  Copyright © 2017 Gemma Jing. All rights reserved.
//

import UIKit


class FoodInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:
    @IBOutlet weak var tableView: UITableView!
    
    // food infomation from InputViewController
    var foodItemName: String = ""
    let database = foodData().loadFoodDatabase()
    var foodInfoText = FoodInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strutArray = database!.filter{$0.Food_Name == foodItemName}
        foodInfoText = strutArray[0]
        loadFoodNutrition()
        tableView.estimatedRowHeight = 138
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getFoodNameAndImage() -> [String] {
        let refindedName = foodInfoText.Food_Name.replacingOccurrences(of: "_", with: " ")
        let substringArray = refindedName.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: true)
        var nameArray = [String]()
        nameArray.append(String(substringArray[0]))
        if(substringArray.count == 2){
            nameArray.append(String(substringArray[1]))
        }
        return nameArray
    }
    
    
    var food_nutrient = [foodInformation]()
    
    func loadFoodNutrition(){
        let water = foodInformation(nutrientType: "Water", amount: foodInfoText.Water_g, unit: "(g)")
        let protein = foodInformation(nutrientType: "Protein", amount: foodInfoText.Protein_g, unit: "(g)")
        let carbohydrate = foodInformation(nutrientType: "Carbohydrate", amount: foodInfoText.Carbohydrate_g, unit: "(g)")
        let energy = foodInformation(nutrientType: "Energy", amount: foodInfoText.Energy_kcal, unit: "(kcal)")
        let mineral = foodInformation(nutrientType: "Mineral", amount: foodInfoText.Minerals_mg, unit: "(mg)")
        let vitamin = foodInformation(nutrientType: "Vitamin", amount: foodInfoText.Vitamin_mg, unit: "(mg)")
        let fat = foodInformation(nutrientType: "Fat", amount: foodInfoText.Fat_g, unit: "(g)")
        
        food_nutrient = [water!, protein!, carbohydrate!, energy!, mineral!, vitamin!, fat!]
    }
    
    //MARK: load table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (food_nutrient.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! FoodInformationTableViewCell
            let stringArray = getFoodNameAndImage()
            cell.foodNameLabel.text = stringArray[0]
            cell.foodImage.image = UIImage(named: stringArray[0])
            if stringArray.count == 2 {
                cell.foodDescriptionLabel.text?.append(stringArray[1])
                cell.foodDescriptionLabel.lineBreakMode = .byWordWrapping
                cell.foodDescriptionLabel.numberOfLines = 0
            }
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FoodInformationSecondTableViewCell
        let nutrient = food_nutrient[indexPath.row]
        /*let display = nutrient.nutrientType; + ":          " + String(format: "%.3f", nutrient.amount) + nutrient.unit
        cell.nutrientTypeLabel.text = display
        return cell*/
        
        
        cell.nutrientTypeLabel.text = nutrient.nutrientType
        var amountString = "    " + String(format: "%.3f", nutrient.amount)
        amountString.append(nutrient.unit)
        cell.amountLabel.text = amountString
        cell.contentView.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
