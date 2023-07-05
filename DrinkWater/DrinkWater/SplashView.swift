//
//  SplashView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/06.
//

import SwiftUI

struct SplashView: View {
    @State private var navigated: Bool = false
    
    let moveToTimer = Timer.publish(every: 2, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            LottieView(lottieFile: "bubble")
                .ignoresSafeArea()
            
            
            FadeInOutView(text: "물리미", startTime: 1)
                .padding()
                .font(.title)
                .foregroundColor(.white)
        }
        .onReceive(moveToTimer) { _ in
            if UserDefaults.shared.integer(forKey: "totalCount") <= 0 {
                UserDefaults.shared.set(8, forKey: "totalCount")
            }
            
            navigated = true
        }
        .fullScreenCover(isPresented: $navigated) {
            MainTabView()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
