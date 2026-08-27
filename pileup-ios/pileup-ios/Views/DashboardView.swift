import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showChartsSheet = false
    @State private var currentDetent: PresentationDetent = .height(120)
    
    private func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "€ 0,00"
    }
    
    private func formattedCurrencyView(value: Double, mainSize: CGFloat, decimalSize: CGFloat) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let formattedString = formatter.string(from: NSNumber(value: value)) ?? "0,00 €"
        let separator = formatter.decimalSeparator ?? ","
        
        if let separatorRange = formattedString.range(of: separator) {
            let mainPart = String(formattedString[..<separatorRange.lowerBound])
            let decimalPart = String(formattedString[separatorRange.lowerBound...])
            
            return Text("\(Text(mainPart).font(.montserrat(size: mainSize, weight: .bold)))\(Text(decimalPart).font(.montserrat(size: decimalSize, weight: .bold)))")
        } else {
            return Text(formattedString).font(.montserrat(size: mainSize, weight: .bold))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [AppTheme.Colors.primary, AppTheme.Colors.primaryHover]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Top Navigation Area
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ciao, \(UserDefaults.standard.string(forKey: "username") ?? "Utente")")
                                    .font(.montserrat(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: SettingsView(authViewModel: authViewModel)) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        
                        HStack {
                            Spacer()
                            TimeFrameSelectorView(viewModel: viewModel)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    // Main Balance Area
                    if viewModel.isLoading {
                        VStack(spacing: 8) {
                            Text("Netto")
                                .font(.montserrat(size: 16, weight: .semibold))
                                .textCase(.uppercase)
                                .tracking(2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            ZStack(alignment: .center) {
                                PlatformView()
                                    .offset(y: 45)
                                    .opacity(0.5)
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 220, height: 60)
                                    .shimmering()
                            }
                            .padding(.bottom, 24)
                            
                            HStack(spacing: 40) {
                                VStack(spacing: 4) {
                                    Text("Entrate")
                                        .font(.montserrat(size: 14, weight: .semibold))
                                        .textCase(.uppercase)
                                        .tracking(2)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 100, height: 28)
                                        .shimmering()
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Uscite")
                                        .font(.montserrat(size: 14, weight: .semibold))
                                        .textCase(.uppercase)
                                        .tracking(2)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 100, height: 28)
                                        .shimmering()
                                }
                            }
                            .padding(.top, 32)
                        }
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(AppTheme.Colors.negative)
                    } else {
                        VStack(spacing: 8) {
                            Text("Netto")
                                .font(.montserrat(size: 16, weight: .semibold))
                                .textCase(.uppercase)
                                .tracking(2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            ZStack(alignment: .center) {
                                // Effetto banconota 3D (Platform)
                                PlatformView()
                                    .offset(y: 45) // Spostato decisamente giù sotto al testo
                                
                                formattedCurrencyView(value: viewModel.monthlyIncome - viewModel.monthlyExpense, mainSize: 64, decimalSize: 32)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    //  trasparenza simulata
                                    .shadow(color: AppTheme.Colors.primary, radius: 8, x: 0, y: 2)
                                    .shadow(color: AppTheme.Colors.primary, radius: 20, x: 0, y: 0)
                                    .shadow(color: AppTheme.Colors.primaryHover, radius: 40, x: 0, y: 0)
                            }
                            .padding(.bottom, 24)
                            HStack(spacing: 40) {
                                VStack(spacing: 4) {
                                    Text("Entrate")
                                        .font(.montserrat(size: 14, weight: .semibold))
                                        .textCase(.uppercase)
                                        .tracking(2)
                                        .foregroundColor(.white.opacity(0.8))
                                    formattedCurrencyView(value: viewModel.monthlyIncome, mainSize: 28, decimalSize: 18).foregroundColor(.white)
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Uscite")
                                        .font(.montserrat(size: 14, weight: .semibold))
                                        .textCase(.uppercase)
                                        .tracking(2)
                                        .foregroundColor(.white.opacity(0.8))
                                    formattedCurrencyView(value: viewModel.monthlyExpense, mainSize: 28, decimalSize: 18).foregroundColor(.white)
                                }
                            }
                            .padding(.top, 32)
                        }
                    }
                    
                    Spacer()
                    Spacer() // Push up slightly to leave room for the bottom sheet
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showChartsSheet) {
                ChartsSheetView(viewModel: viewModel, currentDetent: $currentDetent)
                    .presentationDetents([.height(120), .medium, .large], selection: $currentDetent)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .presentationCornerRadius(32)
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
            }
            .onAppear {
                viewModel.fetchMonthlyStats()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showChartsSheet = true
                }
            }
        }
    }
}

struct ChartsSheetView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Binding var currentDetent: PresentationDetent
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if currentDetent == .height(120) {
                        Spacer()
                        Text("Scorri su per i grafici")
                            .font(.caption)
                            .foregroundColor(AppTheme.Colors.textLight)
                            .padding(.top, 24) // Spazio dal bordo superiore
                        Spacer()
                    } else {
                        Spacer()
                        // Segnaposto per il futuro Menu (es. impostazioni, filtri, ecc.)
                        Button(action: {
                            // Azione Menu (da implementare)
                        }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppTheme.Colors.primary)
                        }
                        .padding(.trailing, 24)
                        .padding(.top, 24)
                    }
                }
                // Force height to be 140 when panel closed to avoid seeing components when closed
                .frame(height: currentDetent == .height(120) ? 140 : nil, alignment: .top)
                .padding(.bottom, 8)
                
                if !viewModel.incomeMovements.isEmpty || !viewModel.expenseMovements.isEmpty {
                    Text("Riepilogo Movimenti")
                        .font(.headline)
                        .foregroundColor(AppTheme.Colors.text)
                        .padding(.horizontal, 24)
                    
                    Chart {
                        ForEach(viewModel.incomeMovements) { stat in
                            LineMark(
                                x: .value("Data", stat.month),
                                y: .value("Valore", stat.amount)
                            )
                            .foregroundStyle(by: .value("Tipo", "Entrate"))
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            .interpolationMethod(.catmullRom)
                            
                            PointMark(
                                x: .value("Data", stat.month),
                                y: .value("Valore", stat.amount)
                            )
                            .foregroundStyle(by: .value("Tipo", "Entrate"))
                            .symbol(by: .value("Tipo", "Entrate"))
                        }
                        
                        ForEach(viewModel.expenseMovements) { stat in
                            LineMark(
                                x: .value("Data", stat.month),
                                y: .value("Valore", stat.amount)
                            )
                            .foregroundStyle(by: .value("Tipo", "Uscite"))
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            .interpolationMethod(.catmullRom)
                            
                            PointMark(
                                x: .value("Data", stat.month),
                                y: .value("Valore", stat.amount)
                            )
                            .foregroundStyle(by: .value("Tipo", "Uscite"))
                            .symbol(by: .value("Tipo", "Uscite"))
                        }
                    }
                    .chartForegroundStyleScale([
                        "Entrate": AppTheme.Colors.success,
                        "Uscite": AppTheme.Colors.negative
                    ])
                    .chartLegend(position: .top, alignment: .leading)
                    .frame(height: 250)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                } else {
                    Spacer()
                }
            }
        }
        .background(AppTheme.Colors.background.edgesIgnoringSafeArea(.bottom))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(authViewModel: AuthViewModel())
    }
}

struct PlatformView: View {
    var body: some View {
        ZStack {
            // Ombra sul fondo
            Ellipse()
                .fill(Color.black.opacity(0.3))
                .frame(width: 200, height: 60)
                .offset(y: 25)
                .blur(radius: 12)
            
            // Spessore della moneta (Bordo 3D in basso)
            Ellipse()
                .fill(Color.orange.opacity(0.9))
                .frame(width: 240, height: 75)
                .offset(y: 5)
            
            // Faccia superiore dorata della moneta
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color.yellow, Color.orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 240, height: 75)
                .overlay(
                    // Bordo interno in rilievo
                    Ellipse()
                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                        .padding(6)
                )
                .overlay(
                    // Riflesso di luce
                    LinearGradient(
                        colors: [Color.white.opacity(0.5), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(Ellipse())
                )
        }
    }
}
