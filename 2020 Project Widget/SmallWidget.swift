//
//  SmallWidget.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-08-22.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import SwiftUI

struct SmallWidget: View {
	var devotion:Devotion
	
//	let url = URL(string: self.snippet.unsplash_url)!
//	self.snippet.unsplash_url
	var body: some View {
		
		ZStack {

			NetworkImage(url: URL(string: "https://source.unsplash.com/\(self.devotion.unsplash_id)/600x600")!)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
				.background(Color(UIColor.black))
				.brightness(-0.1)

			VStack(alignment: .leading, spacing: 4) {
				HStack(alignment: .top, spacing: 0) {

					Text("\(devotion.title)")
//						.font(.system(.footnote))
                        .font(.system(.subheadline))
						.foregroundColor(Color.white)
						.bold()

					Spacer()

					Image("Logo")
						.resizable()
						.frame(width: 21, height: 26.6, alignment: .topTrailing)
						.scaledToFit()

				}

				Spacer()

				Text("\(devotion.scriptureListFormated)")
					.font(.system(.caption))
					.foregroundColor(Color.white)

//				Spacer()

//				Text("\(snippet.author)")
//					.font(.system(.caption2))
//					.foregroundColor(Color.white)
//					.fontWeight(.light)

			}
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
					.padding(14)

//			.background(Color(UIColor.systemBackground))

	//		Color(UIColor.systemBackground)
			}
		}
}

struct SmallWidget_Previews: PreviewProvider {
    static var previews: some View {
		let devotion = Devotion()
		
        SmallWidget(devotion: devotion)
    }
}
