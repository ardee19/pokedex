//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Roy Dimayuga on 11/1/16.
//  Copyright © 2016 www.WeAreSuperAwesome.net. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel! {
        didSet{
            descriptionLbl.text = ""
        }
    }
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var evoLbl: UILabel! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(pokemon.name)
        print(pokemon.pokedexId)
        print("Attack: \(pokemon.attack)")
        
        let currentPokemonImage = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = currentPokemonImage
        currentEvoImg.image = currentPokemonImage
        nameTitle.text = pokemon.name.capitalized
        
        
        pokemon.downloadPokemonDetail {
            self.updateUI()
        }
    }
    
    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvolutionId)")
            nextEvoImg.isHidden = false
            
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
        
        
        

        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
