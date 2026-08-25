import SwiftUI

struct CashFlowMainDataView: View {
    let income: Double
    let expense: Double
    
    private var net: Double { income - expense }
    
    private func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "€ 0,00"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header / Net
            VStack(spacing: 8) {
                Text("BILANCIO NETTO")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white.opacity(0.8))
                    .tracking(2)
                
                Text(formattedCurrency(net))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(.top, 10)
            
            Divider()
                .background(Color.white.opacity(0.3))
                .padding(.horizontal, 30)
            
            // Income / Expense Row
            HStack(spacing: 20) {
                // Income
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.right.circle.fill")
                        Text("ENTRATE")
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.8))
                    
                    Text(formattedCurrency(income))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.15))
                .cornerRadius(20)
                
                // Expense
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right.circle.fill")
                        Text("USCITE")
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.8))
                    
                    Text(formattedCurrency(expense))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.15))
                .cornerRadius(20)
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppTheme.Colors.primary, AppTheme.Colors.primaryHover]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(32)
        .shadow(color: AppTheme.Colors.primary.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct CashFlowMainDataView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            CashFlowMainDataView(income: 3500.50, expense: 1250.75)
                .padding()
        }
    }
}
