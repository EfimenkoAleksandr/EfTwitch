//
//  GameDataServises.swift
//  EfTwitch
//
//  Created by mac on 24.07.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import Alamofire

class GameDataService {
    static let instance = GameDataService()
    
    var games = [Game]()
    
    func downloadTopGames(completed: @escaping DownloadComplete) {
        
        var nameString, imageUrlString: String!
        
        let url = TWITCH_URL_TOP_GAMES
        request(url).responseJSON { (response) in
            print(response)
            if let JSON = response.result.value as? [String: Any] {
                
                if let topGamesArray = JSON["top"] as? [[String: Any]], topGamesArray.count > 0 {
                    for i in 0..<topGamesArray.count {
                        if let gameDict = topGamesArray[i]["game"] as? [String : Any] {
                            if let gameName = gameDict["name"] as? String {
                                nameString = gameName
                            }
                            if let boxArt = gameDict["box"] as? [String : Any] {
                                if let imageUrl = boxArt["medium"] as? String {
                                    imageUrlString = imageUrl
                                }
                            }
                        }
                        let game = Game(name: nameString, imageUrl: imageUrlString)
                        self.games.append(game)
                    }
                }
            }
            completed()
        }
    }
}
