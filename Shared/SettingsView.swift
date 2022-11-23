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
    @State var email: String = ""
    @State var regex: String = ""
    @AppStorage("emails") var emails: Set<String> = []
    @AppStorage("filterRegxes") var filterRegxes: Set<String> = []
    @AppStorage("unrepeated") var unrepeated: Bool = true
    @State var uuid: UUID = UUID()
    var body: some View {
        Group {
            List {
                SettingsCell(label: "作者邮箱") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(emails)) { email in
                            HStack(alignment: .center, spacing: 4) {
                                Text(email).foregroundColor(.white)
                                Button {
                                    // TODO: 增加确认
                                    guard let first = emails.firstIndex(of: email) else {
                                        return
                                    }
                                    emails.remove(at: first)
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
                            TextField("输入邮箱", text: $email)
                                .frame(width: 200, height: 20)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                guard !email.isEmpty, !emails.contains(email) else {
                                    return
                                }
                                emails.insert(email)
                                email = ""
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
                .animation(Animation.default, value: uuid)
                SettingsCell(label: "匹配过滤") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(filterRegxes)) { email in
                            HStack(alignment: .center, spacing: 4) {
                                Text(email).foregroundColor(.white)
                                Button {
                                    guard let first = filterRegxes.firstIndex(of: email) else {
                                        return
                                    }
                                    filterRegxes.remove(at: first)
//                                    uuid = UUID()
                                    
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
                            TextField("输入正则", text: $regex)
                                .frame(width: 200, height: 20)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                guard !regex.isEmpty, !filterRegxes.contains(regex) else {
                                    return
                                }
                                filterRegxes.insert(regex)
                                regex = ""
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                            }
                            Spacer()
                        }
                    }
                }

                SettingsCell(label: "是否去重") {
                    Toggle("", isOn: $unrepeated)
                }

            }
            .buttonStyle(PlainButtonStyle())
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
