//
//  DrinkView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/28.
//

import SwiftUI
import WidgetKit

struct DrinkView: View {
    @State private var counter = 0
    @State private var isPresented: Bool = false
    @State var progress: CGFloat = 0
    @State var startAnimation: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                // MARK: 물방울
            ZStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .scaleEffect(x: 1.1, y: 1.1)
                            .offset(y: -1)
                        
                        WaterWave(progress: self.progress, waveHeight: 0.1, offset: self.startAnimation)
                            .fill(.teal)
                        // water drop
                            .overlay {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 15, height: 15)
                                        .offset(x: -20)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 15, height: 15)
                                        .offset(x: 40, y: 30)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 25, height: 25)
                                        .offset(x: -30, y: 80)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 25, height: 25)
                                        .offset(x: 50, y: 70)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 10, height: 10)
                                        .offset(x: 40, y: 100)
                                }
                            }
                            .mask {
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                    }
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .onAppear {
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                            startAnimation = size.width
                        }
                    }
                }
                .frame(height: 450)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
                Text("\(counter)잔")
                    .font(.title)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                HStack(spacing: 20) {
                    // MARK: 물마시기 버튼
                    Button(action: {
                        guard self.counter < 8 else {
                            isPresented = true
                            return
                        }
                        
                        self.counter += 1
                        self.progress += 0.125
                        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
                            UserDefaults.shared.set(value, forKey: key)
                        }
                        UserDefaults.shared.set(self.counter, forKey: key)
                        WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
                        
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                            startAnimation = 2
                        }
                    }) {
                        Text("마시기")
                            .padding()
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $isPresented, content: {
                        Alert(title: Text(""), message: Text("지금은 8잔까지만 설정 가능합니다 ㅜㅜ"))}
                    )
                    
                    // MARK: 초기화 버튼
                    Button(action: {
                        self.counter = 0
                        self.progress = 0
                        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
                            UserDefaults.shared.set(value, forKey: key)
                        }
                        UserDefaults.shared.set(self.counter, forKey: key)
                        WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
                    }) {
                        Text("초기화")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            self.counter = UserDefaults.shared.integer(forKey: key)
            self.progress = CGFloat(self.counter / 8)
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkView(progress: 0.5, startAnimation: 0)
    }
}

struct WaterWave: Shape {
    var progress: CGFloat
    // Wave Height
    var waveHeight: CGFloat
    // Initial Animation Start
    var offset: CGFloat
    
    // Enabling Animation
    var animateableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            // Drawing vwaves using sine
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2) {
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
