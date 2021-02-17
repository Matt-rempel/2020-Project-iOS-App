//
//  MediumWidget.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-08-22.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import SwiftUI

struct MediumWidget: View {
	var devotion: Devotion

	var body: some View {
		ZStack {

            NetworkImage(url: URL(string: "https://source.unsplash.com/\(self.devotion.unsplashId)/600x600")!)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
				.background(Color(UIColor.black))
				.brightness(-0.1)

			VStack(alignment: .leading, spacing: 4) {
				HStack(alignment: .top, spacing: 0) {

					Text("\(devotion.title)")
						.font(.system(.headline))
						.foregroundColor(Color.white)
						.bold()

					Spacer()

					Image("Logo")
						.resizable()
						.frame(width: 21, height: 26.6, alignment: .topTrailing)
						.scaledToFit()

				}

				Text("\(devotion.scriptureList)")
					.font(.system(.caption))
					.foregroundColor(Color.white)

				Spacer()

                Text("\(devotion.author.name)")
					.font(.system(.caption))
					.foregroundColor(Color.white)
					.fontWeight(.light)

			}
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
			.padding()

		}
	}
}

struct MediumWidget_Previews: PreviewProvider {
    static var previews: some View {
		let devotion = Devotion()
        MediumWidget(devotion: devotion)
    }
}
