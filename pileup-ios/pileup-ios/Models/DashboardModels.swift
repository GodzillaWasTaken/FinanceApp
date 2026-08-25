import Foundation

struct MonthlyStat: Codable, Identifiable {
    var id: String { month }
    let month: String
    let amount: Double
}

struct MonthlyStatsResponse: Codable {
    let year: String
    let month: String?
    let income: [MonthlyStat]
    let spending: [MonthlyStat]
    let monthlyIncome: Double
    let monthlyExpense: Double
}
