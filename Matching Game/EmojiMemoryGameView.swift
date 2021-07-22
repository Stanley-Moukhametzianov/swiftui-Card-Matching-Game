
// imports swift ui package

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack{
            Grid(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture{
                            withAnimation(.linear(duration: 0.5)){
                                viewModel.choose(card: card)
                            }
                        }
                        .padding(5)
                }
                .foregroundColor(Color.orange)
                .padding()
        
            Button(action: {
                withAnimation(.easeInOut){
                    self.viewModel.resetGame()
                }
            }) {
                HStack {
                    Image(systemName: "bookmark.fill")
                    Text("Restart")
                }
            }.buttonStyle(GradientButtonStyle())
        }
}
    
}
struct CardView: View{
    let screenSize: CGRect = UIScreen.main.bounds
    var card: MemoryGame<String>.Card
    
    
    @State private var animatedBonusRemaining: Double = 0
    
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View{
    
        GeometryReader{ geometry in
            if card.isFaceUp || !card.isMatched{
                ZStack {
                    Group {
                        if card.isComsumingBonusTime{
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90),clockwise: true)
                                .onAppear {
                                    self.startBonusTimeAnimation()
                                }
                        }else{
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90),clockwise: true)
                        }
                    }
                    .padding(9)
                    .opacity(0.4)
                    
                        Text(card.Content)
                            .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                            .animation(card.isMatched ? Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false) : .default)
                            
                }
                .font(Font.system(size: min(geometry.size.width,geometry.size.height) * fontScaelFactor))
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
                
            }
            
        }
    }
    private let cornerRadius : CGFloat  = 10
    private let edgeLineWidth: CGFloat = 3
    private let fontScaelFactor: CGFloat = 0.7
}





struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    
            
        
    }
}

































