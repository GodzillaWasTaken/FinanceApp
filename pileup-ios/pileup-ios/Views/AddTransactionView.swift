import SwiftUI

/// View for adding a transaction matching Budget and Investments placeholder design.
struct AddTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(AppTheme.Colors.primary)
                }
                
                VStack(spacing: 8) {
                    Text("Nuova Transazione")
                        .font(.montserrat(size: 22, weight: .bold))
                        .foregroundColor(AppTheme.Colors.text)
                    
                    Text("Aggiungi e registra le tue entrate e uscite quotidiane.")
                        .font(.montserrat(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.textLight)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Text("FUNZIONALITÀ IN ARRIVO")
                    .font(.montserrat(size: 11, weight: .bold))
                    .tracking(2)
                    .foregroundColor(AppTheme.Colors.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppTheme.Colors.primary.opacity(0.08))
                    .clipShape(Capsule())
                
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarTitle("Nuova Transazione", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.montserrat(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.Colors.primary)
                }
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
