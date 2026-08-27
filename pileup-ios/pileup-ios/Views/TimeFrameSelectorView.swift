import SwiftUI

struct TimeFrameSelectorView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var showPicker = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Previous Button
            Button(action: {
                viewModel.previousPeriod()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .disabled(viewModel.selectedPeriod.isTotal)
            .opacity(viewModel.selectedPeriod.isTotal ? 0.3 : 1)
            
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 1, height: 16)
            
            // Current Period Button
            Button(action: {
                showPicker = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                    Text(viewModel.selectedPeriod.description)
                        .font(.montserrat(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 1, height: 16)
            
            // Next Button
            Button(action: {
                viewModel.nextPeriod()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .disabled(!viewModel.selectedPeriod.canMoveForward())
            .opacity(!viewModel.selectedPeriod.canMoveForward() ? 0.3 : 1)
        }
        .foregroundColor(.white)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showPicker) {
            WheelYearMonthPickerModal(selectedPeriod: $viewModel.selectedPeriod)
                .presentationDetents([.height(380)])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
        }
    }
}
