//
//  ContentCategory.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation

/// This is a set of pre-defined content categories that you can filter on.
///
/// - none: Default content category. This category is ignored when any other category is used in the filter.
/// - landscapes: Media items containing landscapes.
/// - receipts: Media items containing receipts.
/// - cityscapes: Media items containing cityscapes.
/// - landmarks: Media items containing landmarks.
/// - selfies: Media items that are selfies.
/// - people: Media items containing people.
/// - pets: Media items containing pets.
/// - weddings: Media items from weddings.
/// - birthdays: Media items from birthdays.
/// - documents: Media items containing documents.
/// - travel: Media items taken during travel.
/// - animals: Media items containing animals.
/// - food: Media items containing food.
/// - sport: Media items from sporting events.
/// - night: Media items taken at night.
/// - performances: Media items from performances.
/// - whiteboards: Media items containing whiteboards.
/// - screenshots: Media items that are screenshots.
/// - utility: Media items that are considered to be utility. These include, but aren't limited to documents, screenshots, whiteboards etc.
enum ContentCategory: String {
    case none = "NONE"
    case landscapes = "LANDSCAPES"
    case receipts = "RECEIPTS"
    case cityscapes = "CITYSCAPES"
    case landmarks = "LANDMARKS"
    case selfies = "SELFIES"
    case people = "PEOPLE"
    case pets = "PETS"
    case weddings = "WEDDINGS"
    case birthdays = "BIRTHDAYS"
    case documents = "DOCUMENTS"
    case travel = "TRAVEL"
    case animals = "ANIMALS"
    case food = "FOOD"
    case sport = "SPORT"
    case night = "NIGHT"
    case performances = "PERFORMANCES"
    case whiteboards = "WHITEBOARDS"
    case screenshots = "SCREENSHOTS"
    case utility = "UTILITY"
}
