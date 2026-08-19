import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView("Loading stats...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Current Month Summary
                        VStack(spacing: 16) {
                            HStack {
                                Text("This Month's Cashflow")
                                    .font(.montserrat(size: 17, weight: .semibold))
                                Spacer()
                            }
                            
                            HStack(spacing: 20) {
                                // Income
                                StatCard(title: "Income", amount: viewModel.monthlyIncome, color: .green)
                                
                                // Expenses
                                StatCard(title: "Expenses", amount: viewModel.monthlyExpense, color: .red)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        
                        Spacer()
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Dashboard", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                authViewModel.logout()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.red)
            })
            .onAppear {
                viewModel.fetchMonthlyStats()
            }
        }
    }
}

// Sub-component to display a single stat card with the amount
struct StatCard: View {
    var title: String
    var amount: Double
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.montserrat(size: 15))
                .foregroundColor(.gray)
            
            Text(String(format: "€ %.2f", amount))
                .font(.montserrat(size: 20, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(authViewModel: AuthViewModel())
    }
}
