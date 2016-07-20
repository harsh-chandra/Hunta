//
//  ServerHelper.swift
//  hunta
//
//  Created by Harsh  on 7/19/16.
//  Copyright © 2016 asleepinthetrees. All rights reserved.
//

import Foundation

public class ServerHelper  {
    
    static let urlPath: String = "http://52.37.67.44:8080"
    
    public class func GetRequest() {
        
        let url: NSURL = NSURL(string: urlPath)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    public class func UpdateLocation(latitude : String, longitude : String, identifier : String) -> [String:String] {
        let dict = ["update_location":"anything", "latitude":latitude, "longitude":longitude, "name":identifier]
        let JSONString = BaseCall(dict)
        let resultDictionary = self.convertStringToDictionary(JSONString)!
        return resultDictionary
        
    }
    
    public class func AttemptKill(latitude : String, longitude : String, angleRelativeToTrueNorth : Double, identifier : String) -> [String:String] {
        let dict = ["attempt":"tryKill", "x":latitude, "y":longitude, "heading": angleRelativeToTrueNorth, "name" : identifier]
        let JSONString = BaseCall(dict)
        let resultDictionary = self.convertStringToDictionary(JSONString)!
        return resultDictionary
        
    }
    
    public class func BaseCall(dict : NSDictionary) -> String {
        let json = dict
        var resultString = "null"
        var jsonData : NSData?
        
        do  {
            jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: [])
        }
        catch
        {
            // Exception lands us here
            print("Caught error:", error)
        }
        // create post request
        let url = NSURL(string: "http://52.37.67.44:8080")!
        //let url = NSURL(string: "http://10.38.3.190:8080")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        
        // insert json data to the request
        request.HTTPBody = jsonData
        //request.HTTPBody = NS([UInt8]("test".utf8))
        //var buf = [UInt8]("test".utf8)
        //request.HTTPBodyStream = NSInputStream(data: NSData(bytes: buf, length: buf.count))
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data,response,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            do {
                if let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]{
                    if let str = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                        print(str)
                        resultString = str
                    }
                }
            } catch {
                // handle exception
            }
        }
        
        
        task.resume()
        return resultString
    }
    
    // Can be used to parse a string to a dictionary
    public class func convertStringToDictionary(text: String) -> [String:String]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:String]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
