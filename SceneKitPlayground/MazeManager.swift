//
//  MazeManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

enum Direction: Int {
    case north = 0
    case west = 1
    case south = 2
    case east = 3
}

class MazeManager: NSObject {
    static let sharedInstance = MazeManager()
    private override init() {}
    var delegate: NetworkViewControllerProtocol!
    let dataManager = DataManager.sharedInstance
    var maze = Maze(dictionary: [:])
    var mazeArray = [Maze]()
    var tileArray = [[TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject](),
                     [TileObject]()]
    
    func setUp() {
        createMazeArray()
        let number = arc4random_uniform(UInt32(mazeArray.count))
        maze = mazeArray[Int(number)]
        getImages()
    }
    
    func createMazeArray() {
        let maze0 = Maze(dictionary: [
            0: [4, 5, 6, 7, 8],
            1: [1, 2, 6],
            2: [1, 2, 3, 4, 6, 8],
            3: [4, 8],
            4: [0, 2, 4, 6],
            5: [2, 6, 7],
            6: [1, 2, 4, 6, 7, 8],
            7: [1, 4, 7],
            8: [1, 3, 4, 6, 8],
            9: [1, 6]
            ])
        maze0.start = (0, 9)
        maze0.end = (9, 0)
        maze0.startFacing = .north
        mazeArray.append(maze0)
        
        let maze1 = Maze(dictionary: [
            1: [0, 1, 2, 4, 5, 6, 7, 8],
            2: [2, 4, 8],
            3: [1, 2, 4, 5, 6, 8],
            4: [8],
            5: [0, 1, 2, 3, 4, 5, 6, 7, 8],
            6: [0, 5],
            7: [0, 2, 3, 4, 5, 7, 8],
            8: [0, 7],
            9: [0, 1, 2, 3, 5, 6, 7, 8, 9]
            ])
        maze1.start = (4, 9)
        maze1.end = (0, 0)
        maze1.startFacing = .north
        mazeArray.append(maze1)
        
        let maze2 = Maze(dictionary: [
            0: [3, 7],
            1: [1, 3, 5, 7, 9],
            3: [0, 1, 3, 5, 6, 7, 8, 9],
            4: [3],
            5: [1, 3, 5, 7, 9],
            7: [0, 1, 3, 4, 5, 7, 9],
            8: [7],
            9: [1, 2, 3, 4, 5, 6, 7, 8, 9]
            ])
        maze2.start = (0, 9)
        maze2.end = (9, 0)
        maze2.startFacing = .north
        mazeArray.append(maze2)
        
        let maze3 = Maze(dictionary: [
            0: [3, 4, 5, 6, 7],
            1: [1, 3, 9],
            2: [1, 3, 6, 8, 9],
            3: [1, 3, 4, 6],
            4: [6],
            5: [1],
            6: [1, 2, 3, 4, 5, 6, 7, 8, 9],
            7: [3, 7],
            9: [3, 7]
            ])
        maze3.start = (5, 8)
        maze3.end = (9, 0)
        maze3.startFacing = .north
        mazeArray.append(maze3)
        
        let maze4 = Maze(dictionary: [
            1: [1, 2, 4, 6, 7, 9],
            2: [1, 7, 9],
            3: [3, 5, 9],
            4: [1, 5, 7, 9],
            5: [3, 4, 5, 7, 9],
            6: [1, 9],
            7: [1, 2, 4, 5, 7, 9],
            9: [0, 1, 2, 3, 4, 5, 6, 7]
            ])
        maze4.start = (9, 9)
        maze4.end = (4, 4)
        maze4.startFacing = .north
        mazeArray.append(maze4)
    }
}

extension MazeManager {
    func getImageRequestURL() -> URL{
        var url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo")//&tags=")
        //            if ([self togglePracticeMode]) {
        //                urlString = [[NSMutableString alloc] initWithString:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&per_page=200&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo&tags="];
        //            }
        //            NSString *tagWithoutWhiteSpace = [tagEntry stringByReplacingOccurrencesOfString:@" " withString:@""];
        //            [urlString appendString:tagWithoutWhiteSpace];
        //            return [NSURL URLWithString:urlString];
        //        }
        return url!
    }
    
    func getImages() {
        let request = URLRequest(url: getImageRequestURL())
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 15
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                if data == nil {
                    return
                }
                if (error != nil) {
                    print(error!.localizedDescription)
                    return
                }
                let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
                let photoDict = dict["photos"] as! [String: Any]
                var photoArray = photoDict["photo"] as! [[String: Any]]
                while photoArray.count < 100 {
                    photoArray += photoArray
                }
                
                var zIndex = 0
                for index in 0...99 {
                    if self.tileArray[zIndex].count > 9 {
                        zIndex += 1
                    }

                    let tile = self.generateTileWithDictionary(photoArray[index])
                    self.tileArray[zIndex].append(tile)

                }
                DispatchQueue.main.async {
                    self.delegate.callSucceeded()
                }
                
            } catch {
                print("Details of JSON parsing error:\n \(error)")
            }
        }
        dataTask.resume()
    }
    
    func generateTileWithDictionary(_ dict: [String: Any]) -> TileObject {
        let tile = dataManager.generateTileObject()
        let farm = String(dict["farm"] as! Int)
        let server = dict["server"] as! String
        let id = dict["id"] as! String
        let secret = dict["secret"] as! String
        let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
        let data = NSData(contentsOf: url!)
        tile.image = data
        tile.title = dict["title"] as? String
        return tile
    }
}
