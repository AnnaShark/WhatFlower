//
//  WikiManager.swift
//  WhatFlower
//
//  Created by Anna Shark on 15/9/21.
//

import Foundation
import SDWebImage

struct WikiManager {
    
    let baseURL = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts|pageimages&exintro&explaintext&redirects=1&indexpageids&redirects=1&pithumbsize=500&titles="
    
    var delegate: WikiManagerDelegate?
    
    func getWikiInfo(flower name: String){

        let url = "\(baseURL)\(name)"
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            makeWikiRequest(url: urlString)
            print(urlString)
        }
        
       
    }
   


    func parseJSON(_ data: Data) -> (String,String)?{
        let decoder = JSONDecoder()

        do{
            let decodedData =  try decoder.decode(WikiData.self, from: data)
            
            let pageID = decodedData.query.pageids[0]
            print("Exctract: \(decodedData.query.pages[pageID]?.extract)")
            print("Pic url: \(decodedData.query.pages[pageID]?.thumbnail.source)")

            if let extract = (decodedData.query.pages[pageID]?.extract), let pic = (decodedData.query.pages[pageID]?.thumbnail.source) {
                print(extract, pic)
                return (extract, pic)
            }
        } catch{
            delegate?.didFailWithError(error: error)
            print("Error in parseJSON")
        }
        return nil
    }

    
    func makeWikiRequest(url: String) {
        print(" getWikiInfo is called")
        if let url = URL(string: url){
            print("  I am inside let url = URL(string: url)")
            // 2. Create a URLSession > thing that can perform networing
            let session = URLSession(configuration: .default)
            // 3. Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print("  I am inside error != nil")
                   self.delegate?.didFailWithError(error: error!)
                    return
                } else {
                    print("  I am inside else in getWikiExtract")
                    if let safeData = data{
                        print(" i am inside safe data")
                      if let wikiResult =  self.parseJSON(safeData){
                        print(" i am inside wikiResult =  self.parseJSON(safeData)")
                        self.delegate?.didUpdateFlower(self, extract: wikiResult.0, pic: wikiResult.1)
                      }
                    }
                }
            }
            // 4. Start the task
        task.resume()
        } else {
            print("I am here")
        }
    }

}
protocol WikiManagerDelegate {
    func didUpdateFlower(_ wikiManager: WikiManager, extract: String, pic: String)
    func didFailWithError(error: Error)
    
}


