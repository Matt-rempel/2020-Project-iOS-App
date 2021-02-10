//
//  LargeWidget.swift
//  2020 Project WidgetExtension
//
//  Created by Matthew Rempel on 2020-08-22.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import SwiftUI

struct LargeWidget: View {
    var devotion:Devotion
	
	var body: some View {
		ZStack {

            NetworkImage(url: URL(string: "https://source.unsplash.com/\(self.devotion.unsplash_id)/600x600")!)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
				.background(Color(UIColor.black))
				.brightness(-0.1)
			
			VStack(alignment: .leading, spacing: 4) {
				HStack(alignment: .top, spacing: 0) {
				
					Text("\(devotion.title)")
						.font(.system(.title))
						.foregroundColor(Color.white)
						.bold()
					
					Spacer()
					
					Image("Logo")
						.resizable()
						.frame(width: 21, height: 26.6, alignment: .topTrailing)
						.scaledToFit()
					
				}
								
				Text("\(devotion.scriptureList)")
					.font(.system(.body))
					.foregroundColor(Color.white)
				
				Spacer()
				
                Text("\(devotion.author.name)")
					.font(.system(.headline))
					.foregroundColor(Color.white)
					.fontWeight(.light)
				
			}
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
			.padding()

		}
	}
}

struct LargeWidget_Previews: PreviewProvider {
    static var previews: some View {
		let devotion = Devotion()
		
        LargeWidget(devotion: devotion)
    }
}
