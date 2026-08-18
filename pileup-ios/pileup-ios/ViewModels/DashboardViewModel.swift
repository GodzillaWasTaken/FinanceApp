import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var monthlyIncome: Double = 0.0
    @Published var monthlyExpense: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func fetchMonthlyStats() {
        isLoading = true
        errorMessage = nil
        
        let currentYear = String(Calendar.current.component(.year, from: Date()))
        let currentMonth = String(format: "%02d", Calendar.current.component(.month, from: Date()))
        
        let endpoint = "stats/monthly/?year=\(currentYear)&month=\(currentMonth)"
        
        NetworkManager.shared.request(endpoint: endpoint, method: "GET") { (result: Result<MonthlyStatsResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.monthlyIncome = response.monthlyIncome
                    self.monthlyExpense = response.monthlyExpense
                case .failure(let error):
                    self.errorMessage = "Error fetching stats: \(error.localizedDescription)"
                }
            }
        }
    }
}
