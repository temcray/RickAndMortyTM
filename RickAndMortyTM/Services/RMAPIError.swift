//
//  RMAPIError.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/27/26.
//

import Foundation

//Erors for the API layer
enum RMAPIError: Error, Equatable {
    
    case invalidUrl
    case requestfaild
    case invalidResponse
    case badStatusCode(Int)
    case noResults
    case decodingFaild
    
}

class RMAPIService {
    
    private let baseUrlString: String = "https://rickandmortyapi.com/api"
    
    // Builds: https://rickandmortyapi.com/api/<path>?page=1&name=rick
    
    private func buildUrl(path: String, page: Int, name: String?) -> URL? {
        
        let fullString: String = baseUrlString + "/" + path
        
        let componentOptional: URLComponents? = URLComponents(string: fullString)
        
        if componentOptional == nil {
            return nil
        }
        
        var components: URLComponents = componentOptional!
        
        var items: [URLQueryItem] = []
        items.append(URLQueryItem(name: "page", value: String(page)))
        
        if let nameValue: String == name {
            if nameValue.isEmpty == false {
                items.append(URLQueryItem(name: "name", value: nameValue))
            }
        }
        
        components.queryItems = items
        return components.url
    }
    
    //Mark: - CHARACTERS
    func fetchCharacters(page: Int, name: String?) async throws -> CharacterRespoonse {
        
        let urlOptional: URL? = buildUrl(path: "character", page: page, name: name)
        if urlOptional == nil { throw RMAPLError.invaildUrl }
        
        let url: URL = urlOptional!
        
        let dataAndResponse: (Data, URLResponse)
        
        do {
            
        }catch {
            throw RMAPIError.requestfaild
        }
        
        let data: Data = dataAndResponse.0
        let response: URLResponse = dataAndResponse.1
        
        let httpOptional: HTTPURLResponse? = response as? HTTPURLResponse
        if httpOptional == nil { throw RMAPIError.invalidResponse }
        
        
        let http: HTTPURLResponse = httpOptional!
        let code: Int = http.statusCode
        
        if code == 200 {
            // OK
        } else if code == 404 {
            throw RMAPIError.noResults
        } else {
            throw RMAPIError.badStatusCode(code)
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        
        do{
            let decoded: CharacterRespoonse = try decoder(CharacterRespoonse.self, from: data)
            return decoded
        } catch {
            throw RMAPIError.decodingFaild
            
            do{
                dataAndResponse = try await URLSession.shared.data(from: url)
            } catch {
                throw RMAPIError.requestfaild
            }
            
            let data: Data = dataAndResponse.0
            let response: URLResponse = dataAndResponse.1
            
            let httpOptional: HTTPURLResponse? = response as? HTTPURLResponse
            if httpOptional == nil { throw RMAPIError.invalidResponse }
            
            let code: Int = http.statusCode
            
            if code  == 200 {
                //OK
                
            } else if code == 404 {
                throw RMAPIError.noResults
            } else {
                throw RMAPIError.badStatusCode(code)
            }
            
            let decoded: CharacterRespoonse = try decoder.decode(CharacterRespoonse.self, from: data)
            return decoded
        } catch {
            throw RMAPIError.decodingFaild
        }
    }
    
    
    //MARK: - EPISODES
    func fetchEpisodes(page: Int, name: String?) async throws -> EpisodeResponse {
        
        let urlOptional: URL? = buildUrl(path: "episode", page: page, name: name)
        if urlOptional == nil { throw RMAPIError.invalidUrl }
        
        let url: URL = urlOptional!
        
        let dataAndResponse: (Data, URLResponse)
        
        do {
            dataAndResponse = try await URLSession.shared.data(from: url)
        } catch {
            throw RMAPIError.requestfaild
        }
        
        let data: Data = dataAndResponse.0
        let response: URLResponse = dataAndResponse.1
        
        let httpOptional: HTTPURLResponse? = response as? HTTPURLResponse
        if httpOptional == nil { throw RMAPIError.invalidResponse }
        
        let http: HTTPURLResponse = httpOptional!
        let code: Int = http.statusCode
        
        if code == 200 {
            //OK
        } else if code == 404 {
            throw RMAPIError.noResults
        } else {
            throw RMAPIError.badStatusCode(code)
        }
        
        let decoder JSONDecoder = JSONDecoder()
        
        do {
            let decoded: EpisodeResponse = try decoder.decode(EpisodeResponse.self, from: data)
            return decode
        } catch {
            throw RMAPIError.decodingFaild
        }
        
        func fetchEpisodes(page: Int, name: String?) async throws -> LocationResponse {
            
            let urlOptional: URL? = buildUrl(path: "episode", page: page, name: name)
            if urlOptional == nil { throw RMAPIError.invalidUrl }
            
            let url: URL = urlOptional!
            
            let dataAndResponse: (Data, URLResponse)
            
            do {
                dataAndResponse = try await URLSession.shared.data(from: url)
            } catch {
                throw RMAPIError.requestfaild
            }
            
            let data: Data = dataAndResponse.0
            let response: URLResponse = dataAndResponse.1
            
            let httpOptional: HTTPURLResponse? = response as? HTTPURLResponse
            if httpOptional == nil { throw RMAPIError.invalidResponse }
            
            let http: HTTPURLResponse = httpOptional!
            let code: Int = http.statusCode
            
            if code == 200 {
                //OK
            } else if code == 404 {
                throw RMAPIError.noResults
            } else {
                throw RMAPIError.badStatusCode(code)
            }
            
            let decoder JSONDecoder = JSONDecoder()
            
            do {
                let decoded: EpisodeResponse = try decoder.decode(LocationResponse.self, from: data)
                return decoded
            } catch {
                throw RMAPIError.decodingFaild
            }
    }
}

