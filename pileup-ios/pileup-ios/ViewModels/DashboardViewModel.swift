import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var monthlyIncome: Double = 0.0
    @Published var monthlyExpense: Double = 0.0
    @Published var incomeMovements: [MonthlyStat] = []
    @Published var expenseMovements: [MonthlyStat] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func fetchMonthlyStats() {
        isLoading = true
        errorMessage = nil
        
        let currentYear = String(Calendar.current.component(.year, from: Date()))
        let currentMonth = String(format: "%02d", Calendar.current.component(.month, from: Date()))
        
        let endpoint = "stats/monthly/?year=\(currentYear)&month=\(currentMonth)"
        
        Task { @MainActor in
            do {
                let response: MonthlyStatsResponse = try await NetworkManager.shared.request(endpoint: endpoint, method: "GET")
                self.isLoading = false
                self.monthlyIncome = response.monthlyIncome
                self.monthlyExpense = response.monthlyExpense
                self.incomeMovements = response.income
                self.expenseMovements = response.spending
            } catch {
                self.isLoading = false
                self.errorMessage = "Error fetching stats: \(error.localizedDescription)"
            }
        }
    }
}
