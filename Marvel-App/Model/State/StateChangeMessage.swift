//
//  StateChangeMessage.swift
//  Marvel-App
//
//  Created by YILDIRIM on 24.02.2023.
//

import Foundation

struct StateChangeMessage {
    let state: State
    let title: String
    let message: String
    let character: Characters
}

extension StateChangeMessage {
    enum State { case memory, persisted }

    static func deleteCharacter(_ state: State = .memory, with character: Characters) -> StateChangeMessage {
        StateChangeMessage(state: state, title: "Delete \"\(character.name)\"?", message: "Deleting this hero will also delete it's data.", character: character)
    }
}
