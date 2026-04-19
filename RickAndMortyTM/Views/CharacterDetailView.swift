//
//  CharacterDetailView.swift
//  RickAndMortyTM
//
//  Created by Tatiana6mo on 3/28/26.
//



import SwiftUI

struct CharacterDetailView: View {

    let character: RMCharacter

    private let notesStore: CharacterNotesStore = CharacterNotesStore()

    @State private var noteText: String = ""
    @State private var showSavedMessage: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Image
                if let url: URL = URL(string: character.image) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                // Name
                Text(character.name)
                    .font(.title)
                    .bold()

                // Info
                Text("Status: " + character.status)
                Text("Species: " + character.species)
                Text("Gender: " + character.gender)
                Text("Origin: " + character.origin.name)
                Text("Location: " + character.location.name)

                if character.type.isEmpty == false {
                    Text("Type: " + character.type)
                }

                Divider()

                // Notes
                Text("My Note")
                    .font(.headline)

                TextEditor(text: $noteText)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3))
                    )

                HStack {
                    Button("Save Note") {
                        notesStore.saveNote(characterId: character.id, note: noteText)
                        showSavedMessage = true
                    }

                    Button("Clear") {
                        noteText = ""
                        notesStore.clearNote(characterId: character.id)
                        showSavedMessage = true
                    }
                }

                if showSavedMessage == true {
                    Text("Saved on this device ✅")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)

        // Load the note when opening this screen
        .onAppear {
            noteText = notesStore.loadNote(characterId: character.id)
            showSavedMessage = false
        }
    }
}
