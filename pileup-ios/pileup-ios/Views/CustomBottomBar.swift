import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case cashflow
    case investments
    case menu
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .cashflow: return "CashFlow"
        case .investments: return "Investimenti"
        case .menu: return "Menu"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .cashflow: return "chart.bar"
        case .investments: return "chart.line.uptrend.xyaxis"
        case .menu: return "line.3.horizontal"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home: return "house.fill"
        case .cashflow: return "chart.bar.fill"
        case .investments: return "chart.line.uptrend.xyaxis"
        case .menu: return "line.3.horizontal"
        }
    }
}

/// Floating bottom navigation bar matching the frontend Menu.vue
/// Contains 4 tabs and an elevated center "+" button.
struct CustomBottomBar: View {
    @Binding var selectedTab: AppTab
    let onAddTapped: () -> Void
    let onMenuTapped: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            // Navigation Bar Pill Container
            HStack(spacing: 0) {
                // Left 2 items: Home, CashFlow
                HStack(spacing: 0) {
                    tabButton(for: .home)
                    tabButton(for: .cashflow)
                }
                .frame(maxWidth: .infinity)
                
                // Gap for the elevated center button
                Spacer()
                    .frame(width: 64)
                
                // Right 2 items: Investimenti, Menu
                HStack(spacing: 0) {
                    tabButton(for: .investments)
                    tabButton(for: .menu)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .stroke(AppTheme.Colors.menuBorder.opacity(0.8), lineWidth: 1)
                    )
            )
            
            // Center "+" Button (lowered down)
            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                onAddTapped()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.Colors.primary, AppTheme.Colors.primaryHover],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: AppTheme.Colors.primary.opacity(0.4), radius: 8, x: 0, y: 5)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -10) // Lowered down
        }
    }
    
    @ViewBuilder
    private func tabButton(for tab: AppTab) -> some View {
        let isSelected = selectedTab == tab
        
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            if tab == .menu {
                onMenuTapped()
            } else {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 19))
                    .foregroundColor(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.neutral)
                    .frame(height: 22)
                
                Text(tab.title)
                    .font(.montserrat(size: 9, weight: isSelected ? .semibold : .medium))
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundColor(isSelected ? AppTheme.Colors.text : AppTheme.Colors.neutral)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct CustomBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            CustomBottomBar(
                selectedTab: .constant(.home),
                onAddTapped: {},
                onMenuTapped: {}
            )
            .padding(.horizontal, 16)
        }
    }
}
