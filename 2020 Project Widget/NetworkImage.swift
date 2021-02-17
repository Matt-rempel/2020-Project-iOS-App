//
//  NetworkImage.swift
//  2020 Project WidgetExtension
//
//  Created by Matthew Rempel on 2020-08-22.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import SwiftUI

struct NetworkImage: View {

	let url: URL?

  var body: some View {

	Group {
	 if let url = url, let imageData = try? Data(contentsOf: url),
	   let uiImage = UIImage(data: imageData) {

	   Image(uiImage: uiImage)
		 .resizable()
		 .aspectRatio(contentMode: .fill)
	  } else {
	   Image("placeholder-image")
	  }
	}
  }

}
