//
//  ContentView.swift
//  Slot Game
//
//  Created by Manny Alvarez on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    //    MARK: - Properties
    @State private var showInfoView: Bool = false
    @State private var reels: Array = [0, 1, 2]
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var betAmount: Int = 10
    @State private var coins: Int = 100
    @State private var showModal: Bool = false
    @State private var animatingSymbols: Bool = false
    @State private var animatingModal: Bool = false
    
    let symbols = ["gfx-bell", "gfx-seven", "gfx-coin", "gfx-cherry", "gfx-grape", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    
    // MARK: - Functions
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            self.playerWins()
            if coins > highScore {
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        playSound(sound: "high-score", type: "mp3")
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activate20bet() {
        betAmount = 20
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activate10bet() {
        betAmount = 10
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func isGameOver() {
        if coins <= 0 {
            showModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        highScore = 0
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        coins = 100
        playSound(sound: "chimeup", type: "mp3")
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            //    MARK: - Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            //    MARK: - Interface
            VStack(alignment: .center, spacing: 5) {
                //Header
                LogoView()
                Spacer()
                //Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumbersStyle()
                            .modifier(ScoreNumberModifier())
                    }//HStack Coins
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highScore)")
                            .scoreNumbersStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }//HStack Record
                    .modifier(ScoreContainerModifier())
                }//HStack Score
                
                //    MARK: - Slot Machine
                VStack(alignment: .center, spacing: 0){
                    //Reel #1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbols ? 1 : 0)
                            .offset(y: animatingSymbols ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear {
                                self.animatingSymbols.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }//ZStack
                    HStack(alignment: .center, spacing: 0) {
                        //Reel #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbols ? 1 : 0)
                                .offset(y: animatingSymbols ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear {
                                    self.animatingSymbols.toggle()
                                }

                        }//ZStack
                        Spacer()
                        //Reel #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbols ? 1 : 0)
                                .offset(y: animatingSymbols ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear {
                                    self.animatingSymbols.toggle()
                                }

                        }//ZStack
                    }//HStack
                    .frame(maxWidth: 500)
                    // MARK: - Spin Button
                    Button(action: {
                        
                        withAnimation {
                            self.animatingSymbols = false
                        }
                        
                        self.spinReels()
                        
                        withAnimation {
                            self.animatingSymbols = true
                        }
                        self.checkWinning()
                        self.isGameOver()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })//:Button
                }//VStack
                .layoutPriority(2)
                //Footer
                Spacer()
                HStack {
                    //    MARK: - Bet 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            activate20bet()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(betAmount == 20 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        })//:Button
                        .modifier(BetCapsuleModifier())
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: betAmount == 20 ? 0 : 20)
                            .opacity(betAmount == 20 ? 1 : 0)
                            .modifier(CasinoChipModifier())
                    }//HStack
                    
                    Spacer()
                    
                    //    MARK: - Bet 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: betAmount == 10 ? 0 : -20)
                            .opacity(betAmount == 10 ? 1 : 0)
                            .modifier(CasinoChipModifier())
                        
                        Button(action: {
                            activate10bet()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(betAmount == 10 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        })//:Button
                        .modifier(BetCapsuleModifier())

                    }//HStack
                }//HStack
            }//VStack
            //Reset Game
            .overlay(
                Button(action: {
                    self.resetGame()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            //InfoButton
            .overlay(
                Button(action: {
                    self.showInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720, minHeight: 60)
            .blur(radius: $showModal.wrappedValue ? 5 : 0, opaque: false)
            //    MARK: - PopUp
            
            if $showModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)
                }//VStack
                
                //    MARK: - Modal
                VStack(spacing: 0) {
                    Text("GAME OVER")
                        .font(.system(.title, design: .rounded ))
                        .fontWeight(.heavy)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("ColorPink"))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 16) {
                        Image("gfx-seven-reel")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 72)
                        
                        Text("Bad Luck! You lose all the coins. \nLet's play again")
                            .font(.system(.body, design: .rounded))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .layoutPriority(1)
                        
                        Button(action: {
                            self.showModal = false
                            self.animatingModal = false
                            self.activate10bet()
                            self.coins = 100
                        }, label: {
                            Text("New Game".uppercased())
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                                .accentColor(Color("ColorPink"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(minWidth: 128)
                                .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundColor(Color("ColorPink"))
                                )
                                
                        })//:Button
                        
                    }//VStack
                    Spacer()
                    
                }//VStack
                .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                .background(.white)
                .cornerRadius(20)
                .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 10, y: 20)
                .opacity($animatingModal.wrappedValue ? 1 : 0)
                .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                .onAppear {
                    self.animatingModal = true
                }
            }
        }//Zstack
        .sheet(isPresented: $showInfoView) {
            InfoView()
        }
    }
}

//    MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
