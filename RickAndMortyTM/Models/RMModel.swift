//
//  RMModel.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/24/26.
//

import Foundation

// MARRK: - SHARED PAGING INFO
struct PageInfo: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}

// MARK: - CHARCTERS
struct CharacterRespoonse : Codable {
    var info: PageInfo
  var  results :[RMCharacter]
    
}


struct RMCharacter : Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: RMPlace
    let location: RMPlace
    let image: String
    
    
}

struct RMPlace: Codable {
    var name: String
    var url: String
    
}


//MARK: - EPISODES
struct EpisodeResponse: Codable {
    
    var info: PageInfo
    var results: [RMEpisode]
    
}


struct RMEpisode: Codable, Identifiable {
    
    var id: Int
    var name: String
    var air_date: String
    var episode: String
    
}

//MARK: - LOCATIONS
struct LocationResponse: Codable {
    
    var info: PageInfo
    var results: [RMLocation]
    
}

struct RMLocation: Codable, Identifiable {
    
    var id: Int
    var name: String
    var type: String
    var dimension: String
    
}
