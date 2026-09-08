import SwiftUI

/// Main CashFlow view hosting the CashFlowMainDataView and quick actions.
struct CashFlowView: View {
    @ObservedObject var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Top TimeFrame Selector
                    HStack {
                        Spacer()
                        TimeFrameSelectorView(viewModel: dashboardViewModel)
                        Spacer()
                    }
                    .padding(.top, 12)
                    
                    // CashFlow Main Data Card
                    CashFlowMainDataView(
                        income: dashboardViewModel.monthlyIncome,
                        expense: dashboardViewModel.monthlyExpense
                    )
                    .padding(.horizontal, 20)
                    
                    // Quick Action Cards (Confronto, Conti, Categorie, Budget)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("GESTIONE RAPIDA")
                            .font(.montserrat(size: 11, weight: .bold))
                            .tracking(1.5)
                            .foregroundColor(AppTheme.Colors.textLight)
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 8) {
                            quickActionButton(title: "Confronto", icon: "chart.xyaxis.line") {
                                // Action placeholder
                            }
                            quickActionButton(title: "Conti", icon: "building.columns") {
                                // Action placeholder
                            }
                            quickActionButton(title: "Categorie", icon: "tag.fill") {
                                // Action placeholder
                            }
                            NavigationLink(destination: BudgetView()) {
                                quickActionCard(title: "Budget", icon: "wallet.pass.fill")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Spacer(minLength: 100) // Padding for floating bottom menu bar
                }
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarTitle("CashFlow", displayMode: .inline)
        }
    }
    
    @ViewBuilder
    private func quickActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            action()
        }) {
            quickActionCard(title: title, icon: icon)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func quickActionCard(title: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppTheme.Colors.primary)
                .frame(width: 44, height: 44)
                .background(AppTheme.Colors.primary.opacity(0.08))
                .clipShape(Circle())
            
            Text(title)
                .font(.montserrat(size: 11, weight: .semibold))
                .foregroundColor(AppTheme.Colors.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
}

struct CashFlowView_Previews: PreviewProvider {
    static var previews: some View {
        CashFlowView(dashboardViewModel: DashboardViewModel())
    }
}
