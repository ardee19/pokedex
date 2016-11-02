//
//  ViewController.swift
//  pokedex
//
//  Created by Roy Dimayuga on 10/28/16.
//  Copyright © 2016 www.WeAreSuperAwesome.net. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collection.dataSource = self
        collection.delegate = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        guard let path = Bundle.main.path(forResource: "music", ofType: "mp3"), let pathURL = URL(string: path) else {
            print("Error in Music path")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: pathURL)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
//            musicPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func parsePokemonCSV() {
        
        guard let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") else {
            print("Error in pokemon csv path")
            return
        }
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                guard let name = row["identifier"], let idString = row["id"], let pokeId = Int(idString) else {
                    print("Error fetching name and id")
                    return
                }
                
                let newPokemon = Pokemon(name: name, pokedexId: pokeId)
                pokemons.append(newPokemon)
            }
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            guard let detailsVC = segue.destination as? PokemonDetailVC, let pokemon = sender as? Pokemon else {
                print("Error passing pokemon to DetailsVC")
                return
            }
            
            detailsVC.pokemon = pokemon
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell else {
            print("Error in cell dequeue")
            return UICollectionViewCell()
        }
        
        var pokemon: Pokemon
        
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row]
        } else {
            pokemon = pokemons[indexPath.row]
        }
        
        cell.configureCell(pokemon)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var pokemon:Pokemon
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row]
        } else {
            pokemon = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemons.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            if  let lower = searchBar.text?.lowercased() {
                filteredPokemon = pokemons.filter{ $0.name.range(of: lower) != nil }
                
                // The same as the above line
//                filteredPokemon = pokemons.filter({ (pokemon) -> Bool in
//                    pokemon.name.range(of: lower) != nil
//                })
                collection.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

