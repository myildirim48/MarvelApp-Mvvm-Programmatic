//
//  ErrorMessages.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation
enum marvelError:String,Error {
    case invalidUsername    = "This username created an invalid request. Please try again"
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case unableToFavorites  = "There was an error favoriting this user. Please try again."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The recieved from the server was invalid. Please try again."
    case alreadyInFavorites = "You have already favorited this user. You must Really like them!"
}


