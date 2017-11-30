//
//  FoodInformationTableViewController.swift
//  DemoSearch
//
//  Created by Gemma Jing on 22/11/2017.
//  Copyright © 2017 Gemma Jing. All rights reserved.
//

import UIKit

class FoodInformationTableViewController: UITableViewController {
    
    var foodItemName: String = ""
    let database = foodData().loadFoodDatabase()
    var foodInfoText = FoodInfo()
    var choice = [1,1,1,1,1]

    override func viewDidLoad() {
        super.viewDidLoad()
        let strutArray = database!.filter{$0.Food_Name == foodItemName}
        foodInfoText = strutArray[0]
        loadFoodNutrition(choice: choice)
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // MARK: get nutrient information
    var food_nutrient = [foodInformation]()
    
    func loadFoodNutrition(choice:[Int]){
        let nutrientType = ["Water", "Fat", "Protein", "Carbohydrate", "NSP", "Energy", "AOAC fibre",               "Sodium", "Potassium", "Calcium", "Magnesium", "Phosphorus", "Iron", "Copper", "Zinc", "Chloride", "Manganese", "Selenium", "Iodine", "Retinol", "Carotene",
            "Retinol Equivalent", "Vitamin_D", "Vitamin_E", "Vitamin_K1", "Thiamin", "Riboflavin", "Niacin", "TryptophanP60", "Niacin Equivalent", "Vitamin_B6", "Vitamin_B12", "Folate", "Pantothenate", "Biotin", "Vitamin_C", "Mineral", "Vitamin"]
        let nutrientData = [foodInfoText.Water_g, foodInfoText.Fat_g, foodInfoText.Protein_g, foodInfoText.Carbohydrate_g, foodInfoText.NSP_g, foodInfoText.Energy_kcal, foodInfoText.AOAC_fibre_g, foodInfoText.Sodium_mg, foodInfoText.Potassium_mg, foodInfoText.Calcium_mg, foodInfoText.Magnesium_mg, foodInfoText.Phosphorus_mg, foodInfoText.Iron_mg, foodInfoText.Copper_mg, foodInfoText.Zinc_mg, foodInfoText.Chloride_mg, foodInfoText.Manganese_mg, foodInfoText.Selenium_microg, foodInfoText.Iodine_microg, foodInfoText.Retinol_microg, foodInfoText.Carotene_microg, foodInfoText.Retinol_Equivalent_microg, foodInfoText.Vitamin_D_microg, foodInfoText.Vitamin_E_mg, foodInfoText.Vitamin_K1_microg, foodInfoText.Thiamin_mg, foodInfoText.Riboflavin_mg, foodInfoText.Niacin_mg, foodInfoText.TryptophanP60_mg, foodInfoText.NiacinEquivalent_mg, foodInfoText.Vitamin_B6_mg, foodInfoText.Vitamin_B12_microg, foodInfoText.Folate_microg, foodInfoText.Pantothenate_mg, foodInfoText.Biotin_microg, foodInfoText.Vitamin_C_mg, foodInfoText.Minerals_mg, foodInfoText.Vitamin_mg]
        let units = ["(g)", "(g)", "(g)", "(g)", "(g)", "(kcal)","(g)", "(mg)", "(mg)","(mg)","(mg)", "(mg)", "(mg)", "(mg)", "(mg)", "(mg)", "(mg)", "(μg)", "(μg)", "(μg)", "(μg)", "(μg)", "(μg)", "(mg)", "(μg)", "(mg)", "(mg)", "(mg)", "(mg)", "(mg)", "(mg)", "(μg)", "(μg)", "(mg)", "(μg)", "(mg)", "(mg)", "(mg)"]
        
        var i = 0
        for id in choice{
            if id == 1 {
                let nutrient = foodInformation(nutrientType: nutrientType[i], amount: nutrientData[i], unit: units[i])
                food_nutrient.append(nutrient!)
            }
            i = i + 1
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (food_nutrient.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfo", for: indexPath) as! FoodInformationTableViewCell
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutrientInfo", for: indexPath) as! FoodInformationSecondTableViewCell
        let nutrient = food_nutrient[indexPath.row]
        cell.nutrientTypeLabel.text = nutrient.nutrientType
        var amountString = String(format: "%.3f", nutrient.amount)
        amountString.append(nutrient.unit)
        cell.amountLabel.text = amountString
        cell.contentView.setNeedsLayout()
        return cell
    }

}
