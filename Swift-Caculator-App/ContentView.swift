import SwiftUI

struct ContentView: View {
        @State private var displayText = "0"
        @State private var currentInput = ""
        @State private var previousValue = 0.0
        @State private var currentOperation: String? = nil
    
    var body: some View {
        ZStack {
            DisplayBackground()
            
            VStack {
                ResultPanel(displayText: $displayText)
                
                VStack {
                    CalRow(items: ["AC", "+/-", "%", "/"], bgColors: [.gray,.gray,.gray,.orange], displayText: $displayText, buttonAction: performAction)
                    CalRow(items: ["7", "8", "9", "x"], bgColors: [Color("LightGray"),Color("LightGray"),Color("LightGray"),.orange], displayText: $displayText, buttonAction: performAction)
                    CalRow(items: ["4", "5", "6", "-"], bgColors: [Color("LightGray"),Color("LightGray"),Color("LightGray"),.orange], displayText: $displayText,
                        buttonAction: performAction)
                    CalRow(items: ["1", "2", "3", "+"], bgColors: [Color("LightGray"),Color("LightGray"),Color("LightGray"),.orange], displayText: $displayText,
                        buttonAction: performAction)
                    BottomRow(displayText: $displayText,
                              buttonAction: performAction)
                }
                Spacer()
            }
        }
    }
    
    func performAction(button: String) {
            switch button {
            case "AC":
                displayText = "0"
                currentInput = ""
                previousValue = 0.0
                currentOperation = nil

            case "+/-":
                if let value = Double(displayText) {
                    displayText = String(-value)
                }
            
            case "%":
                if let value = Double(displayText) {
                    displayText = String(value / 100)
                }

            case "/", "x", "-", "+":
                if let value = Double(currentInput) {
                    previousValue = value
                    currentOperation = button
                    currentInput = ""
                }
            
            case "=":
                if let currValue = Double(currentInput) {
                    if let operation = currentOperation {
                        switch operation {
                        case "+":
                            displayText = String(previousValue + currValue)
                        case "-":
                            displayText = String(previousValue - currValue)
                        case "x":
                            displayText = String(previousValue * currValue)
                        case "/":
                            displayText = currValue == 0 ? "Error" : String(previousValue / currValue)
                        default:
                            break
                        }
                    }
                    currentInput = displayText
                    currentOperation = nil
                }
            
            default:
                currentInput += button
                displayText = currentInput
            }
        }
}

struct DisplayBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

struct ResultPanel: View {
    @Binding var displayText: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(displayText)
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
        .frame(width: 350, height: 300)
        .border(.black, width: 2)
        .padding()
    }
}

struct CalButton: View {
    var buttonText: String
    var buttonWidth: CGFloat
    var buttonColor: Color
    var isCircle: Bool
    @Binding var displayText: String
    var buttonAction: (String) -> Void

    var body: some View {
        Button {
            buttonAction(buttonText)
        } label: {
            if isCircle {
                Text(buttonText)
                    .frame(width: buttonWidth, height: isCircle ? buttonWidth : 70)
                    .background(buttonColor)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            } else {
                Text(buttonText)
                    .frame(width: buttonWidth, height: isCircle ? buttonWidth : 75)
                    .background(buttonColor)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            
        }
    }
}

struct CalRow: View {
    var items: [String]
    var bgColors: [Color]
    @Binding var displayText: String
    var buttonAction: (String) -> Void

    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { index in
                CalButton(buttonText: items[index], buttonWidth: 80, buttonColor: bgColors[index], isCircle: true, displayText: $displayText, buttonAction: buttonAction)
                if index < items.count - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct BottomRow: View {
    @Binding var displayText: String
    var buttonAction: (String) -> Void

    var body: some View {
        HStack {
            CalButton(buttonText: "0", buttonWidth: 165, buttonColor: Color("LightGray"), isCircle: false, displayText: $displayText, buttonAction: buttonAction)
            Spacer()
            CalButton(buttonText: ".", buttonWidth: 80, buttonColor: Color("LightGray"), isCircle: true, displayText: $displayText, buttonAction: buttonAction)
            Spacer()
            CalButton(buttonText: "=", buttonWidth: 80, buttonColor: .orange, isCircle: true, displayText: $displayText, buttonAction: buttonAction)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ContentView()
}
