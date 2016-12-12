//
//  AutomaticAPI.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/2/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import Foundation
import OAuthSwift



var access_token: String!
var token_type: String!
var expires_in: Int!
//var refresh_token: String!

/**
 * This file is modeled after FlickerAPI.swift in p. 310 of the Big Nerde Range guide.
 */
struct AutomaticAPI {
   
    
    // base URL for REST APIs
    static let apiBaseURLString = "https://api.automatic.com"
    
    // URL for API access authorization
    static let authBaseURLString = "https://accounts.automatic.com/oauth/authorize/"
    
    // Callback URL from the oauth2 flow
    static let authCallbackURLString = "oauth-swift://oauth-callback/driving-companion"
    
    // URL for obtaining access token
    static let accessTokenURLString = "https://accounts.automatic.com/oauth/access_token"
    
    
    static let clientId = "ada24548ad3106935189"
    static let secret = "c034127c71433c37c4995c3caa3b7315f6923638"
   
    
    /**
     * URLs for vehicle list REST API.
     */
    static func vehicleListURL() -> URL
    {
        let url = automaticURL(method: Method.vehicles, parameters: nil)
        return url
    }
    
    static func tripListURL(paramters: [String:String]?) -> URL
    {
        let url = automaticURL(method: Method.trip, parameters: paramters)
        return url
    }
    

    static func authHeader() -> String
    {
        return token_type + " " + access_token
    }
    
}

/**
 * number of items to fetch according to user's Settings selection.
 */
func limit() -> String
{
    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = mainStoryboardIpad.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
    
    return controller.settings.numItems
}


struct Session {
    // access token
    static var access_token:String!
    static var expires_in:Int!
    static var refresh_token:String!
    static var token_type:String!
    
    init(access_token: String, expires_in: Int, refresh_token: String, token_type: String) {
        Session.access_token = access_token
        Session.expires_in = expires_in
    //    Session.refresh_token = refresh_token
        Session.token_type = token_type
    }
    
}


// Automatic API methods
enum Method: String {
    case test = "dummy"
    case vehicles = "/vehicle/"
    case trip = "/trip/"
    
}

// Automatic API authorization scopes.
enum Scope: String {
    //case public = "scope:public"
    case user_profile = "scope:user:profile"
    
    case vehicle_profile = "scope:vehicle:profile"
    case location = "scope:location"
    case vehicle_events = "scope:vehicle:events"
    case trip = "scope:trip"
    case behavior = "scope:behavior"
    
}



// authorization
func authorize(scopes: [Scope])
{
        
    let oauthswift = OAuth2Swift (consumerKey: AutomaticAPI.clientId,
                                  consumerSecret: AutomaticAPI.secret,
                                  authorizeUrl: AutomaticAPI.authBaseURLString,
                                  responseType: "code")
    
    var paramScopes = ""
    for scope in scopes {
        paramScopes += scope.rawValue
        paramScopes += "+"
    }
  
    oauthswift.authorize(withCallbackURL: AutomaticAPI.authCallbackURLString, scope: paramScopes, state: "", success: { (credential, response, paramters) in
        // do nothing
    }) { (error) in
        //do nothing
    }
}




/**
 *  Obtain access token based on the code.
 *  @param code code received from the server in previous auth step.
 *  @param completion a function invokved when URL request is completed.
 */
func getAccessToken (code: String, completion: @escaping (AutomaticSession) -> ())
{
    
    var request =  URLRequest(url: URL(string: AutomaticAPI.accessTokenURLString)!)
    request.httpMethod = "POST"
    var postString = "client_id=" + AutomaticAPI.clientId
    postString = postString + "&client_secret" + AutomaticAPI.secret
    postString = postString + "&code=" + code
    postString = postString + "&grant_type=authorization_code"
    
    request.httpBody = postString.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
            return
        }
        
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            print("getAccessToken:\(parsedData)")
            let _access_token = parsedData["access_token"] as! String
        //    let _refresh_token = parsedData["refresh_token"] as! String
            let _expires_in = parsedData["expires_in"] as! Int
            let _token_type = parsedData["token_type"] as! String
        
            access_token = _access_token
            expires_in = _expires_in
            token_type = _token_type
            
            
           // let session = AutomaticSession(access_token: _access_token, expires_in: _expires_in, //refresh_token: _refresh_token, token_type: _token_type)
            let session = AutomaticSession(access_token: _access_token, expires_in: _expires_in,  token_type: _token_type)
            
            completion(session)
            
        } catch let error {
            print(error)
        }
        
    }
    task.resume()

}





/**
 * Construct URL for Automatic REST APIs. 
 */
private func automaticURL(method: Method, parameters: [String:String]?) -> URL
{
    var components = URLComponents(string: AutomaticAPI.apiBaseURLString + method.rawValue)!
    
    var queryItems = [URLQueryItem]()
    
    if parameters != nil {
        for (key, value) in parameters! {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
    }
    
    
    components.queryItems = queryItems
    return components.url!
}
