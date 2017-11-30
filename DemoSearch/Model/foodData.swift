//
//  foodNutrientsStruct.swift
//  StructureData
//
//  Created by Gemma Jing on 20/10/2017.
//  Copyright © 2017 Gemma Jing. All rights reserved.
//

import Foundation
//MARK: building database

class foodData{
    // MARK: formatting the json text
    // To modify the original string to readable JSON:
    // 1. Change "null" to 0
    // 2. Remove "\n  ", "\n", " }", space after ": " and change other " " to "_"
    // 3. Add on "}" for all
    // 4. Delete the comma if there is one at the start
    func formatForJson(contents: String) -> [String]?{
        let content_null = contents.replacingOccurrences(of: "null", with: "0")
        let lines = content_null.split(separator: "}", maxSplits: 2897, omittingEmptySubsequences: true)
        
        var jsonString : [String] = []
        
        for element in lines{
            let mod_line_trim = element.trimmingCharacters(in: .whitespacesAndNewlines)
            var mod_line_n = mod_line_trim.replacingOccurrences(of: "\n   ", with: "")
            mod_line_n = mod_line_n.replacingOccurrences(of: "\n", with: "")
            mod_line_n = mod_line_n.replacingOccurrences(of: "\r", with: "")
            let mod_line_back_bracket = mod_line_n.replacingOccurrences(of: " }", with: "}")
            let mod_line_col = mod_line_back_bracket.replacingOccurrences(of: ": ", with: ":")
            let mod_line_space = mod_line_col.replacingOccurrences(of: " ", with: "_")
            
            var mod_line_bracket = mod_line_space
            if mod_line_space.last != "}"{
                mod_line_bracket += "}"
            }
            
            //check if the first character is a comma and remove it
            if element.first == ","{
                mod_line_bracket.removeFirst()
                mod_line_bracket.removeFirst()
            }
            jsonString.append(mod_line_bracket)
        }
        return jsonString
    }

    // MARK: load json text file in a string
    func loadFoodDatabase() -> [FoodInfo]?{
        let path = Bundle.main.path(forResource: "datasetJSON", ofType: "json")
        var contents: String?
        try! contents = String(contentsOfFile: path!)
        let jsonString = formatForJson(contents: contents!)
        var database: [FoodInfo] = []
        
        let decoder = JSONDecoder()
        for singleString in jsonString!{
            let jsonData = singleString.data(using: .utf8)!
            let food = try! decoder.decode(FoodInfo.self, from: jsonData)
            database.append(food)
        }
        return database
    }
    
    // MARK: load food names all in a string
    func loadFoodNames() -> [String] {
        let database = loadFoodDatabase()
        var foodNameData:[String] = []
        var i = 0
        
        while i < (database?.count)! {
            let name = database![i].Food_Name.replacingOccurrences(of: "_", with: " ")
            foodNameData.append(name)
            i = i + 1
        }
        return foodNameData
    }
    
    // MARK: categorize the food items
    func categorizeItems() ->[String:[String]]{
        let foodNameData = loadFoodNames()
        var sortedFoodItem: [String: [String]] = [:]
        var category: String = ""
        
        for item in foodNameData {
            let array = item.split(separator: ",")
            if category != String(array[0]){
                category = String(array[0])
                sortedFoodItem[category] = []
            }
            sortedFoodItem[category]?.append(item)
        }
        return sortedFoodItem
    }
  
    
    // MARK: 1st search from the database time input form the user:  foodToSearch
    func searchItem(foodToSearch: String) -> [FoodInfo?]{
        var database: [FoodInfo] = []
        database = loadFoodDatabase()!
        var itemTargeted: [FoodInfo] = []
        
        let dataSize = database.count
        var i = 0
        
        while i < dataSize{
            let item = database[i]
            if (item.Food_Name.range(of: foodToSearch) != nil){
                itemTargeted.append(item)
            }
            i = i + 1
        }
        return itemTargeted
    }
}
