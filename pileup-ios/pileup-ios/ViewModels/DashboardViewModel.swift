import Foundation
import Combine

enum DataPeriod: Equatable {
    case monthYear(month: Int, year: Int)
    case year(Int)
    case total
    
    var description: String {
        switch self {
        case .monthYear(let month, let year):
            return String(format: "%02d/%d", month, year)
        case .year(let year):
            return "\(year)"
        case .total:
            return "Totale"
        }
    }
    
    var isTotal: Bool {
        if case .total = self { return true }
        return false
    }
    
    func canMoveForward() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        
        switch self {
        case .monthYear(let month, let year):
            if year > currentYear { return false }
            if year == currentYear && month >= currentMonth { return false }
            return true
        case .year(let year):
            return year < currentYear
        case .total:
            return false
        }
    }
    
    mutating func adjust(by offset: Int) {
        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        
        switch self {
        case .monthYear(let month, let year):
            var newMonth = month + offset
            var newYear = year
            
            while newMonth > 12 {
                newMonth -= 12
                newYear += 1
            }
            while newMonth < 1 {
                newMonth += 12
                newYear -= 1
            }
            
            // Prevent future dates
            if newYear > currentYear || (newYear == currentYear && newMonth > currentMonth) {
                return
            }
            
            self = .monthYear(month: newMonth, year: newYear)
            
        case .year(let year):
            let newYear = year + offset
            if newYear > currentYear {
                return
            }
            self = .year(newYear)
            
        case .total:
            break
        }
    }
}

class DashboardViewModel: ObservableObject {
    @Published var monthlyIncome: Double = 0.0
    @Published var monthlyExpense: Double = 0.0
    @Published var incomeMovements: [MonthlyStat] = []
    @Published var expenseMovements: [MonthlyStat] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var selectedPeriod: DataPeriod = {
        let calendar = Calendar.current
        let today = Date()
        return .monthYear(
            month: calendar.component(.month, from: today),
            year: calendar.component(.year, from: today)
        )
    }() {
        didSet {
            // Automatically fetch stats when period changes
            if oldValue != selectedPeriod {
                fetchMonthlyStats()
            }
        }
    }
    
    func fetchMonthlyStats() {
        isLoading = true
        errorMessage = nil
        
        let endpoint = "stats/monthly/"
        var queryItems: [URLQueryItem] = []
        
        switch selectedPeriod {
        case .monthYear(let month, let year):
            queryItems.append(URLQueryItem(name: "year", value: "\(year)"))
            queryItems.append(URLQueryItem(name: "month", value: String(format: "%02d", month)))
        case .year(let year):
            queryItems.append(URLQueryItem(name: "year", value: "\(year)"))
        case .total:
            queryItems.append(URLQueryItem(name: "year", value: "Totale"))
        }
        
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = queryItems
        let finalEndpoint = urlComponents?.url?.absoluteString ?? endpoint
        
        Task { @MainActor in
            do {
                let response: MonthlyStatsResponse = try await NetworkManager.shared.request(endpoint: finalEndpoint, method: "GET")
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
    
    func nextPeriod() {
        if selectedPeriod.canMoveForward() {
            selectedPeriod.adjust(by: 1)
        }
    }
    
    func previousPeriod() {
        if !selectedPeriod.isTotal {
            selectedPeriod.adjust(by: -1)
        }
    }
}
