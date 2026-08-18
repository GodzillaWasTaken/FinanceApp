import SwiftUI

struct ServerSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var customURL: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Configuration"), footer: Text("Leave blank to use the cloud server (Production). Make sure to include http:// or https:// and end with /api/ if you use a custom server.")) {
                    TextField("E.g. http://192.168.1.100:8080/api/", text: $customURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section {
                    Button(action: {
                        customURL = ""
                        saveURL()
                    }) {
                        Text("Restore Default")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveURL()
                }
                .fontWeight(.bold)
            )
            .onAppear {
                customURL = UserDefaults.standard.string(forKey: "customServerURL") ?? ""
            }
        }
    }
    
    private func saveURL() {
        let trimmed = customURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            UserDefaults.standard.removeObject(forKey: "customServerURL")
        } else {
            // Ensure it ends with a slash
            let finalURL = trimmed.hasSuffix("/") ? trimmed : trimmed + "/"
            UserDefaults.standard.set(finalURL, forKey: "customServerURL")
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ServerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ServerSettingsView()
    }
}
