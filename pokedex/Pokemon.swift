//
//  Pokemon.swift
//  pokedex
//
//  Created by Roy Dimayuga on 10/31/16.
//  Copyright © 2016 www.WeAreSuperAwesome.net. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvolutionTxt: String!
    fileprivate var _nextEvolutionName: String!
    fileprivate var _nextEvolutionId: String!
    fileprivate var _nextEvolutionLevel: String!
    fileprivate var _pokemonURL: String!
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            guard let dict = response.result.value as? [String: Any] else {
                print("Error fetching JSON dictionary")
                return
            }
            
            guard let weight = dict["weight"] as? String,
                  let height = dict["height"] as? String,
                  let attack = dict["attack"] as? Int,
                  let defense = dict["defense"] as? Int
            else {
                print("Error JSON Dictionary")
                return
            }
            
//            guard let height = dict["height"] as? String else {
//                print("Error JSON Dictionary - height")
//                return
//            }
//            
//            guard let attack = dict["attack"] as? Int else {
//                print("Error JSON Dictionary - attack")
//                return
//            }
//            guard let defense = dict["defense"] as? Int else {
//                print("Error JSON Dictionary - defense")
//                return
//            }
            
            self._weight = weight
            self._height = height
            self._attack = "\(attack)"
            self._defense = "\(defense)"
            
            print(self._weight)
            print(self._height)
            print(self._attack)
            print(self._defense)
            
            self._type = ""
            
            if let types = dict["types"] as? [[String:String]] , types.count > 0 {
                for type in types {
                    if let name = type["name"] {
                        if self._type == "" {
                            self._type! += "\(name.capitalized)"
                        } else {
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                }
            }
            
            if let descArr = dict["descriptions"] as? [[String:String]] , descArr.count > 0 {
                
                if let url = descArr[0]["resource_uri"] {
                    let descURL = "\(URL_BASE)\(url)"
                    Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                        
                        if let descDict = response.result.value as? [String:Any] {
                            if let description = descDict["description"] as? String {
                                let newDesciption = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                print(description)
                                print(newDesciption)
                                self._description = newDesciption
                            }
                        }
                        
                        completed()
                    })
                }
            } else {
                self._description = ""
            }
            
            if let evolutions = dict["evolutions"] as? [[String:Any]], evolutions.count > 0 {
                
                if let nextEvo = evolutions[0]["to"] as? String {
                    
                    if nextEvo.range(of: "mega") == nil {
                        self._nextEvolutionName = nextEvo
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvolutionId = nextEvoId
                        }
                        
                        if let lvlExist = evolutions[0]["level"] {
                            if let lvl = lvlExist as? Int {
                                self._nextEvolutionLevel = "\(lvl)"
                            }
                        } else {
                            self._nextEvolutionLevel = ""
                        }
                    }
                }
                
                print(self.nextEvolutionLevel)
                print(self.nextEvolutionName)
                print(self.nextEvolutionId)
            }
            
            
            
            completed()
        }
        
    }
    
}
