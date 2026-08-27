import SwiftUI

struct SettingsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        Form {
            Section(header: Text("Account")) {
                Button(action: {
                    showLogoutConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Esci dal profilo")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(AppTheme.Colors.negative)
                }
            }
            
            // Qui potrai aggiungere in futuro altre impostazioni
            // come cambio tema, notifiche, lingua, ecc.
        }
        .navigationTitle("Impostazioni")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false) // Assicura che la barra di navigazione torni visibile
        .alert("Conferma Uscita", isPresented: $showLogoutConfirmation) {
            Button("Annulla", role: .cancel) { }
            Button("Esci", role: .destructive) {
                authViewModel.logout()
            }
        } message: {
            Text("Sei sicuro di voler uscire dal tuo account?")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(authViewModel: AuthViewModel())
        }
    }
}
