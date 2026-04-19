//
//  RMServices.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/24/26.
//

import Foundation


class RMServices {
    
    private let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    func fetchCharactters() async throws -> [RMCharacter] {
        
        let url = baseURL.appendingPathComponent("character")
        
        //baseURL + extra path -----> https://rickandmortyapi.com/api"" + "character"
        
        // http request
        let (data,response) = try await URLSession.shared.data(from: url)
        // tuple
        // data == JSON == ALL THE CHARACTER
        // RESPONSE == STATUS
        
        
        //GUAED AND TROW WORK TOGETER
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decode = try JSONDecoder().decode(CharacterRespoonse.self, from: data)
        
        return decode.results
    }
}
