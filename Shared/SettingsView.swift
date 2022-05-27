//
//  SettingsView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/25.
//

import SwiftUI


extension String: Identifiable {
    public var id: String {
        self
    }
}

struct SettingsView: View {
    @State var name: String = ""
    @AppStorage("authors") var authors: [String] = []
    @State var uuid: UUID = UUID()
    var body: some View {
        Group {
            List {
                SettingsCell(label: "作者") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(authors) { name in
                            HStack(alignment: .center, spacing: 4) {
                                Text(name).foregroundColor(.white)
                                Button {
                                    // TODO: 增加确认
                                    guard let first = authors.firstIndex(of: name) else {
                                        return
                                    }
                                    authors.remove(at: first)
                                    uuid = UUID()
                                    
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(height: 28, alignment: .center)
                            .padding(.horizontal, 10)
                            .background(Color.blue)
                            .cornerRadius(14)
                            
                                                    }
                        HStack(alignment: .center, spacing: 4) {
                            TextField("输入名字", text: $name)
                                .frame(width: 100, height: 20)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                guard !name.isEmpty, !authors.contains(name) else {
                                    return
                                }
                                authors = authors + [name]
                                name = ""
                                uuid = UUID()
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                            }
                            Spacer()
                        }
                    }
                }.id(uuid)
            }.buttonStyle(PlainButtonStyle())
        }
        
    }
}

struct SettingsCell<Content>: View where Content: View {
    let label: String
    let content: (() -> Content)
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(label).font(.headline)
            content()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
