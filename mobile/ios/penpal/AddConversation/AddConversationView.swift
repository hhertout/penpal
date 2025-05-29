//
//  AddConversationView.swift
//  penpal
//
//  Created by Hugues Hertout on 15/05/2025.
//

import SwiftUI

struct AddConversationView: View {
    @State private var name: String = ""
    @StateObject var viewModel: AddConversationViewModel

    let countryList: [String: [String]] = [
        "Australia": ["Sydney", "Melbourne", "Brisbane"],
        "Canada": ["Toronto", "Vancouver", "Ottawa"],
        "United Kingdom": ["London", "Manchester", "Birmingham"],
        "United States": ["New York", "Los Angeles", "Chicago"],
    ]

    let genderList = ["Homme", "Femme"]

    var onCancel: () -> Void
    var onCreate: () -> Void

    init(onCancel: @escaping () -> Void, onCreate: @escaping () -> Void) {
        let vm = AddConversationViewModel()
        self.onCancel = onCancel
        self.onCreate = onCreate
        let firstCountry = countryList.keys.sorted().first ?? ""
        let firstCity = countryList[firstCountry]?.first ?? ""
        let firstGender = genderList.first ?? ""

        vm.model.character.country = firstCountry
        vm.model.character.city = firstCity
        vm.model.character.gender = firstGender

        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Informations")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Label("Nom", systemImage: "person")
                            TextField(
                                "Entrez le nom",
                                text: $viewModel.model.character.name
                            )
                            .multilineTextAlignment(.trailing)
                        }

                        Picker(
                            "Sexe",
                            selection: $viewModel.model.character.gender
                        ) {
                            ForEach(genderList, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                    }
                }

                Section(header: Text("Résidence")) {
                    Picker(
                        "Pays",
                        selection: $viewModel.model.character.country
                    ) {
                        ForEach(countryList.keys.sorted(), id: \.self) {
                            country in
                            Text(country)
                        }
                    }
                    .onChange(of: viewModel.model.character.country) {
                        viewModel.model.character.city =
                            countryList[viewModel.model.character.country]?
                            .first ?? ""
                    }

                    Picker("Ville", selection: $viewModel.model.character.city)
                    {
                        ForEach(
                            countryList[viewModel.model.character.country]
                                ?? [],
                            id: \.self
                        ) { city in
                            Text(city)
                        }
                    }
                }

            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Nouveau contact")
                    .fontWeight(.bold)
                    .font(.title3)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button("Créer") {
                        Task {
                            await viewModel.addConversation()
                        }
                        onCreate()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    AddConversationView(
        onCancel: {},
        onCreate: {}
    )
}
