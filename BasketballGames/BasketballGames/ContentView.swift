//
//  ContentView.swift
//  iTunesSearch
//  added comment to push formatting
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable {
    let id: Int
    let date: String
    let opponent: String
    let team: String
    var score: Score
    let isHomeGame: Bool
}

struct Score: Codable {
    let unc: Int
    let opponent: Int
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Text("UNC Basketball")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom, 0)
                ZStack {
                    List(games, id: \.id) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(item.team) vs \(item.opponent)")
                                    .font(.headline)
                                Spacer()
                                Text("\(item.score.unc) - \(item.score.opponent)")
                                    .font(.headline)
                            }
                            HStack {
                                Text("\(item.date)")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(item.isHomeGame ? "Home" : "Away")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .task {
                await loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedGames = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedGames
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
