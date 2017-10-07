//
//  MazeManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

struct Options {
    var tagArray = [TagObject]()
    var easyMode = false
}

class MazeManager: NSObject {
    static let sharedInstance = MazeManager()
    private override init() {}
    
    var options = Options()
    var delegate: NetworkViewControllerProtocol!
    let dataManager = DataManager.sharedInstance
    var maze = Maze(dictionary: [:])
    var mazeArray = [[MazeTile]]()
    
    func setUp() {
        mazeArray = [[MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile](),
                     [MazeTile]()]
        createMaze()
        getImages()
    }
    
    func getPersistentData() {
        options.tagArray = dataManager.fetchTags()
        options.tagArray = options.tagArray.sorted {
            $0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending
        }
    }
    
    func createMaze() {
        let random = arc4random_uniform(UInt32(5))
        switch random {
        case 0:
            maze = Maze(dictionary: [
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
            maze.start = (0, 9)
            maze.end = (9, 0)
            maze.startFacing = .north
        case 1:
            maze = Maze(dictionary: [
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
            maze.start = (4, 9)
            maze.end = (0, 0)
            maze.startFacing = .north
        case 2:
            maze = Maze(dictionary: [
                0: [3, 7],
                1: [1, 3, 5, 7, 9],
                3: [0, 1, 3, 5, 6, 7, 8, 9],
                4: [3],
                5: [1, 3, 5, 7, 9],
                7: [0, 1, 3, 4, 5, 7, 9],
                8: [7],
                9: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                ])
            maze.start = (0, 9)
            maze.end = (9, 0)
            maze.startFacing = .north
        case 3:
            maze = Maze(dictionary: [
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
            maze.start = (5, 8)
            maze.end = (9, 0)
            maze.startFacing = .north
        case 4:
            maze = Maze(dictionary: [
                1: [1, 2, 4, 6, 7, 9],
                2: [1, 7, 9],
                3: [3, 5, 9],
                4: [1, 5, 7, 9],
                5: [3, 4, 5, 7, 9],
                6: [1, 9],
                7: [1, 2, 4, 5, 7, 9],
                9: [0, 1, 2, 3, 4, 5, 6, 7]
                ])
            maze.start = (9, 9)
            maze.end = (4, 4)
            maze.startFacing = .north
        default:
            maze = Maze(dictionary: [
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
            maze.start = (0, 9)
            maze.end = (9, 0)
            maze.startFacing = .north
        }
    }
}

extension MazeManager {
    func getImageRequestURL() -> URL{
        if options.easyMode == true {
            return URL(string: "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&per_page=200&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo")!
        }
        
        var urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo&tags="
        
        for tag in options.tagArray {
            if tag.isOn {
                var newTag = tag.name ?? ""
                newTag = newTag.replacingOccurrences(of: " ", with: "+")
                urlString += "%2C+\(newTag)"
            }
        }
        print(urlString)
        return URL(string: urlString)!
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
                if photoArray.count < 25 {
                    DispatchQueue.main.async {
                        self.delegate.callFailed(message: "Not enough images.")
                        return
                    }
                }
                while photoArray.count < 100 {
                    photoArray += photoArray
                }
                
                var zIndex = 0
                for index in 0...99 {
                    if self.mazeArray[zIndex].count > 9 {
                        zIndex += 1
                    }
                    let tile = self.generateTileWithDictionary(photoArray[index])
                    self.mazeArray[zIndex].append(tile)
                    
                    DispatchQueue.main.async {
                        self.delegate.updateProgress()
                    }
                }
                DispatchQueue.main.async {
                    self.delegate.callSucceeded()
                }
                
            } catch {
                print("Details of JSON parsing error:\n \(error)")
                DispatchQueue.main.async {
                    self.delegate.callFailed(message: "Could not connect to server")
                }
            }
        }
        dataTask.resume()
    }
    
    func generateTileWithDictionary(_ dict: [String: Any]) -> MazeTile {
        let farm = String(dict["farm"] as! Int)
        let server = dict["server"] as! String
        let id = dict["id"] as! String
        let secret = dict["secret"] as! String
        let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
        let image = NSData(contentsOf: url!)
        let title = dict["title"] as? String
        let tile = MazeTile()
        tile.image = image
        tile.title = title
        return tile
    }
    
    func checkWall(x: Int, z: Int) -> Bool {
        var invalidDict = maze.invalid
        if invalidDict.keys.contains(z) {
            let xSet = invalidDict[z]!
            if xSet.contains(x) {
                return true
            }
        }
        return false
    }
    
    func checkBorder(x: Int, z: Int) -> Bool{
        if x < 0 ||
            x > 9 ||
            z < 0 ||
            z > 9 {
            return true
        }
        return false
    }
}
